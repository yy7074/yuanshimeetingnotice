import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Event } from './entities/event.entity';
import { CreateEventDto, UpdateEventDto } from './dto/event.dto';
import { User } from '../users/entities/user.entity';
import { NotificationDispatcherService } from '../notifications/notification-dispatcher.service';

@Injectable()
export class EventsService {
  private readonly logger = new Logger(EventsService.name);

  constructor(
    @InjectRepository(Event) private eventRepo: Repository<Event>,
    @InjectRepository(User) private userRepo: Repository<User>,
    private notificationDispatcher: NotificationDispatcherService,
  ) {}

  async findAll(query?: { search?: string; status?: string }) {
    const qb = this.eventRepo.createQueryBuilder('event');

    if (query?.status) {
      qb.where('event.status = :status', { status: query.status });
    }
    if (query?.search) {
      qb.andWhere(
        '(event.title_en LIKE :search OR event.title_zh LIKE :search OR event.location_en LIKE :search)',
        { search: `%${query.search}%` },
      );
    }

    qb.orderBy('event.start_date', 'DESC');
    const events = await qb.getMany();

    // Add subscriber count
    const result: any[] = [];
    for (const event of events) {
      const count = await this.eventRepo
        .createQueryBuilder('e')
        .leftJoin('e.subscribers', 's')
        .where('e.id = :id', { id: event.id })
        .select('COUNT(s.id)', 'count')
        .getRawOne();
      result.push({
        ...event,
        currentAttendees: parseInt(count?.count || '0'),
      });
    }
    return result;
  }

  async findOne(id: string) {
    const event = await this.eventRepo.findOne({
      where: { id },
      relations: ['sessions', 'materials'],
    });
    if (!event) throw new NotFoundException('Event not found');
    return event;
  }

  async create(dto: CreateEventDto) {
    const event = this.eventRepo.create(dto);
    const saved = await this.eventRepo.save(event);

    // Notify all users if event is published on creation
    if (saved.status === 'published') {
      this.notificationDispatcher
        .onEventPublished(saved.id, saved.titleEn, saved.titleZh)
        .catch((e) =>
          this.logger.warn(
            `Failed to dispatch event published notification: ${e.message}`,
          ),
        );
    }

    return saved;
  }

  async update(id: string, dto: UpdateEventDto) {
    const event = await this.findOne(id);
    const wasDraft = event.status !== 'published';
    Object.assign(event, dto);
    const saved = await this.eventRepo.save(event);

    // If just published (was draft/ended, now published) → broadcast to all
    if (wasDraft && saved.status === 'published') {
      this.notificationDispatcher
        .onEventPublished(saved.id, saved.titleEn, saved.titleZh)
        .catch((e) =>
          this.logger.warn(
            `Failed to dispatch event published notification: ${e.message}`,
          ),
        );
    } else if (saved.status === 'published') {
      // Already published, just updated → notify subscribers
      this.notificationDispatcher
        .onEventUpdated(saved.id, saved.titleEn, saved.titleZh)
        .catch((e) =>
          this.logger.warn(
            `Failed to dispatch event updated notification: ${e.message}`,
          ),
        );
    }

    return saved;
  }

  async remove(id: string) {
    const event = await this.findOne(id);
    return this.eventRepo.remove(event);
  }

  async subscribe(eventId: string, userId: string) {
    const user = await this.userRepo.findOne({
      where: { id: userId },
      relations: ['subscribedEvents'],
    });
    if (!user) throw new NotFoundException('User not found');

    const event = await this.eventRepo.findOne({ where: { id: eventId } });
    if (!event) throw new NotFoundException('Event not found');

    const alreadySubscribed = user.subscribedEvents.some(
      (e) => e.id === eventId,
    );
    if (!alreadySubscribed) {
      user.subscribedEvents.push(event);
      await this.userRepo.save(user);
    }
    return { message: 'Subscribed successfully' };
  }

  async unsubscribe(eventId: string, userId: string) {
    const user = await this.userRepo.findOne({
      where: { id: userId },
      relations: ['subscribedEvents'],
    });
    if (!user) throw new NotFoundException('User not found');

    user.subscribedEvents = user.subscribedEvents.filter(
      (e) => e.id !== eventId,
    );
    await this.userRepo.save(user);
    return { message: 'Unsubscribed successfully' };
  }

  async getMyEvents(userId: string) {
    const user = await this.userRepo.findOne({
      where: { id: userId },
      relations: ['subscribedEvents'],
    });
    if (!user) throw new NotFoundException('User not found');
    return user.subscribedEvents;
  }

  async getStats() {
    const total = await this.eventRepo.count();
    const published = await this.eventRepo.count({
      where: { status: 'published' as any },
    });
    const draft = await this.eventRepo.count({
      where: { status: 'draft' as any },
    });
    return { total, published, draft };
  }
}
