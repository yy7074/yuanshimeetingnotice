import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CheckIn } from './entities/check-in.entity';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class CheckInService {
  constructor(
    @InjectRepository(CheckIn) private checkInRepo: Repository<CheckIn>,
  ) {}

  async generateQrCode(userId: string, eventId: string) {
    const code = `${userId}:${eventId}:${uuidv4()}:${Date.now()}`;
    // In production, encode this as a signed token
    return { qrCode: code, expiresIn: 30 };
  }

  async verify(qrCode: string) {
    const parts = qrCode.split(':');
    if (parts.length < 3) {
      throw new BadRequestException('Invalid QR code');
    }

    const [userId, eventId] = parts;
    const timestamp = parseInt(parts[3] || '0');

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

    return { message: 'Check-in successful', checkIn };
  }

  async getCheckIns(eventId: string) {
    return this.checkInRepo.find({
      where: { eventId, checkedIn: true },
      relations: ['user'],
      order: { checkedInAt: 'DESC' },
    });
  }

  async getStats(eventId: string) {
    const total = await this.checkInRepo.count({ where: { eventId, checkedIn: true } });
    return { eventId, checkedInCount: total };
  }
}
