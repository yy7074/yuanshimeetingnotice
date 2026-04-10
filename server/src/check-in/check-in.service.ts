import {
  Injectable,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CheckIn } from './entities/check-in.entity';
import { createHmac } from 'crypto';
import { NotificationDispatcherService } from '../notifications/notification-dispatcher.service';
import { EventsService } from '../events/events.service';
import { Event } from '../events/entities/event.entity';

@Injectable()
export class CheckInService {
  private readonly logger = new Logger(CheckInService.name);
  private readonly qrSecret =
    process.env.CHECK_IN_QR_SECRET || 'apscvir-check-in-secret';

  constructor(
    @InjectRepository(CheckIn) private checkInRepo: Repository<CheckIn>,
    @InjectRepository(Event) private eventRepo: Repository<Event>,
    private notificationDispatcher: NotificationDispatcherService,
    private eventsService: EventsService,
  ) {}

  async generateQrCode(userId: string, eventId: string) {
    const timestamp = Date.now();
    const signature = this.signQrPayload(userId, eventId, timestamp);
    const code = `${userId}:${eventId}:${signature}:${timestamp}`;
    return { qrCode: code, expiresIn: 30 };
  }

  async verify(qrCode: string) {
    const parts = qrCode.split(':');
    if (parts.length < 4) {
      throw new BadRequestException('Invalid QR code');
    }

    const [userId, eventId, signature, timestampPart] = parts;
    const timestamp = parseInt(timestampPart, 10);

    if (Number.isNaN(timestamp) || !signature) {
      throw new BadRequestException('Invalid QR code');
    }

    const expectedSignature = this.signQrPayload(userId, eventId, timestamp);
    if (signature !== expectedSignature) {
      throw new BadRequestException('Invalid QR code');
    }

    // Check if QR code is expired (30 seconds)
    if (Date.now() - timestamp > 30000) {
      throw new BadRequestException('QR code expired');
    }

    // Check if already checked in
    const existing = await this.checkInRepo.findOne({
      where: { userId, eventId, checkedIn: true },
    });
    if (existing) {
      return { message: 'Already checked in', checkIn: existing };
    }

    const checkIn = this.checkInRepo.create({
      userId,
      eventId,
      qrCode,
      checkedIn: true,
    });
    await this.checkInRepo.save(checkIn);

    // Notify user of successful check-in
    this.eventsService
      .findOne(eventId)
      .then((event) => {
        this.notificationDispatcher
          .onCheckInSuccess(userId, event.titleEn, event.titleZh)
          .catch((e) =>
            this.logger.warn(
              `Failed to dispatch check-in notification: ${e.message}`,
            ),
          );
      })
      .catch((e) =>
        this.logger.warn(
          `Failed to find event for check-in notification: ${e.message}`,
        ),
      );

    return { message: 'Check-in successful', checkIn };
  }

  async getCheckIns(eventId: string) {
    return this.checkInRepo.find({
      where: { eventId, checkedIn: true },
      relations: ['user'],
      order: { checkedInAt: 'DESC' },
    });
  }

  async getMyCheckIn(userId: string, eventId: string) {
    const record = await this.checkInRepo.findOne({
      where: { userId, eventId, checkedIn: true },
      order: { checkedInAt: 'DESC' },
    });

    return {
      eventId,
      userId,
      checkedIn: !!record,
      checkedInAt: record?.checkedInAt ?? null,
      checkInId: record?.id ?? null,
    };
  }

  async getStats(eventId: string) {
    const checkedInCount = await this.checkInRepo.count({
      where: { eventId, checkedIn: true },
    });
    const subscriberCount = await this.eventRepo
      .createQueryBuilder('event')
      .leftJoin('event.subscribers', 'subscriber')
      .where('event.id = :eventId', { eventId })
      .select('COUNT(subscriber.id)', 'count')
      .getRawOne<{ count: string }>();

    const totalSubscribers = parseInt(subscriberCount?.count || '0', 10);
    const rate = totalSubscribers > 0
      ? Math.round((checkedInCount / totalSubscribers) * 100)
      : 0;

    return {
      eventId,
      checkedInCount,
      totalSubscribers,
      rate,
    };
  }

  private signQrPayload(userId: string, eventId: string, timestamp: number) {
    return createHmac('sha256', this.qrSecret)
      .update(`${userId}:${eventId}:${timestamp}`)
      .digest('hex');
  }
}
