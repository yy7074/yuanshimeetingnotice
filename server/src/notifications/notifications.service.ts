import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification, NotificationType } from './entities/notification.entity';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification) private notifRepo: Repository<Notification>,
  ) {}

  async findByUser(userId: string) {
    return this.notifRepo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: 50,
    });
  }

  async getUnreadCount(userId: string) {
    const count = await this.notifRepo.count({ where: { userId, isRead: false } });
    return { unreadCount: count };
  }

  async markAsRead(id: string, userId: string) {
    await this.notifRepo.update({ id, userId }, { isRead: true });
    return { message: 'Marked as read' };
  }

  async markAllAsRead(userId: string) {
    await this.notifRepo.update({ userId, isRead: false }, { isRead: true });
    return { message: 'All marked as read' };
  }

  async send(data: {
    userId: string;
    titleEn: string;
    titleZh: string;
    bodyEn: string;
    bodyZh: string;
    type: NotificationType;
    eventId?: string;
    targetUrl?: string;
  }) {
    const notif = this.notifRepo.create(data);
    return this.notifRepo.save(notif);
  }

  async broadcast(userIds: string[], data: {
    titleEn: string; titleZh: string;
    bodyEn: string; bodyZh: string;
    type: NotificationType; eventId?: string;
  }) {
    const notifications = userIds.map(userId => this.notifRepo.create({ ...data, userId }));
    return this.notifRepo.save(notifications);
  }

  async sendToAll(data: {
    titleEn: string; titleZh: string;
    bodyEn: string; bodyZh: string;
    type: NotificationType; eventId?: string;
  }) {
    // This would query all active users - simplified version
    const notif = this.notifRepo.create({ ...data, userId: 'broadcast' });
    return this.notifRepo.save(notif);
  }
}
