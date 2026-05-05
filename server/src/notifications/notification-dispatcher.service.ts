import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification, NotificationType } from './entities/notification.entity';
import { User, UserRole } from '../users/entities/user.entity';
import { PushService } from '../common/push.service';
import { EmailService } from '../common/email.service';

@Injectable()
export class NotificationDispatcherService {
  constructor(
    @InjectRepository(Notification) private notifRepo: Repository<Notification>,
    @InjectRepository(User) private userRepo: Repository<User>,
    private pushService: PushService,
    private emailService: EmailService,
  ) {}

  /**
   * Send notification via all channels: DB + Push + Email
   */
  async dispatch(params: {
    userId: string;
    titleEn: string;
    titleZh: string;
    bodyEn: string;
    bodyZh: string;
    type: NotificationType;
    eventId?: string;
    sendPush?: boolean;
    sendEmail?: boolean;
  }) {
    const { userId, sendPush = true, sendEmail = false, ...notifData } = params;

    // 1. Save to database
    const notification = this.notifRepo.create({ ...notifData, userId });
    await this.notifRepo.save(notification);

    // 2. Get user for push/email
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) return notification;

    // 3. Push notification
    if (sendPush && user.pushEnabled && user.fcmToken) {
      const title =
        user.language === 'zh' ? notifData.titleZh : notifData.titleEn;
      const body = user.language === 'zh' ? notifData.bodyZh : notifData.bodyEn;
      await this.pushService.sendToDevice(user.fcmToken, title, body, {
        type: notifData.type,
        eventId: notifData.eventId || '',
        notificationId: notification.id,
      });
    }

    // 4. Email notification
    if (sendEmail && user.email) {
      const lang = user.language || 'zh';
      const subject = lang === 'zh' ? notifData.titleZh : notifData.titleEn;
      const html = `
        <div style="max-width:600px;margin:0 auto;font-family:sans-serif">
          <div style="background:#000666;padding:24px;color:white;text-align:center">
            <h1 style="margin:0;font-size:20px">APSCVIR</h1>
          </div>
          <div style="padding:24px;background:#f9fafb">
            <h2 style="color:#0F172A">${lang === 'zh' ? notifData.titleZh : notifData.titleEn}</h2>
            <p style="color:#64748B;line-height:1.6">${lang === 'zh' ? notifData.bodyZh : notifData.bodyEn}</p>
          </div>
          <div style="padding:16px;text-align:center;color:#94A3B8;font-size:12px">
            © 2026 APSCVIR Conference
          </div>
        </div>
      `;
      // Use internal send method
      await (this.emailService as any).send(user.email, subject, html);
    }

    return notification;
  }

  /**
   * Broadcast to all subscribers of an event
   */
  async broadcastToEvent(params: {
    eventId: string;
    titleEn: string;
    titleZh: string;
    bodyEn: string;
    bodyZh: string;
    type: NotificationType;
    sendPush?: boolean;
    sendEmail?: boolean;
  }) {
    const {
      eventId,
      sendPush = true,
      sendEmail = false,
      ...notifData
    } = params;

    // Get all subscribers
    const users = await this.userRepo
      .createQueryBuilder('u')
      .innerJoin('u.subscribedEvents', 'e', 'e.id = :eventId', { eventId })
      .getMany();

    let count = 0;
    for (const user of users) {
      await this.dispatch({
        ...notifData,
        userId: user.id,
        eventId,
        sendPush,
        sendEmail,
      });
      count++;
    }

    // Also push to FCM topic
    if (sendPush) {
      const title = notifData.titleEn;
      const body = notifData.bodyEn;
      await this.pushService.sendToTag(`event_${eventId}`, title, body);
    }

    return { sent: count, eventId };
  }

  /**
   * Broadcast to users matched by admin-selected filters
   */
  async broadcastByFilter(params: {
    titleEn: string;
    titleZh: string;
    bodyEn: string;
    bodyZh: string;
    type: NotificationType;
    eventId?: string;
    sendPush?: boolean;
    sendEmail?: boolean;
    userIds?: string[];
    role?: UserRole;
    isActive?: boolean;
    search?: string;
  }) {
    const {
      userIds,
      role,
      isActive,
      search,
      ...notifData
    } = params;

    const qb = this.userRepo.createQueryBuilder('user');

    if (Array.isArray(userIds) && userIds.length > 0) {
      qb.andWhere('user.id IN (:...userIds)', { userIds });
    }
    if (role) {
      qb.andWhere('user.role = :role', { role });
    }
    if (typeof isActive === 'boolean') {
      qb.andWhere('user.is_active = :isActive', { isActive });
    }
    if (search?.trim()) {
      qb.andWhere(
        '(user.email LIKE :q OR user.name_en LIKE :q OR user.name_zh LIKE :q)',
        { q: `%${search.trim()}%` },
      );
    }

    const users = await qb.getMany();

    let count = 0;
    for (const user of users) {
      await this.dispatch({
        ...notifData,
        userId: user.id,
      });
      count++;
    }

    return {
      sent: count,
      filters: {
        userIds: userIds?.length || 0,
        role: role || null,
        isActive:
          typeof isActive === 'boolean' ? isActive : null,
        search: search?.trim() || null,
      },
    };
  }

  /**
   * Broadcast to all active users
   */
  async broadcastToAll(params: {
    titleEn: string;
    titleZh: string;
    bodyEn: string;
    bodyZh: string;
    type: NotificationType;
    sendPush?: boolean;
    sendEmail?: boolean;
  }) {
    const users = await this.userRepo.find({ where: { isActive: true } });
    let count = 0;
    for (const user of users) {
      await this.dispatch({
        ...params,
        userId: user.id,
      });
      count++;
    }
    return { sent: count };
  }

  /**
   * Event published notification
   */
  async onEventPublished(
    eventId: string,
    eventNameEn: string,
    eventNameZh: string,
  ) {
    return this.broadcastToAll({
      titleEn: 'New Event Published',
      titleZh: '新会议已发布',
      bodyEn: `"${eventNameEn}" is now available. Check it out!`,
      bodyZh: `"${eventNameZh}" 现已发布，快来查看！`,
      type: NotificationType.EVENT_UPDATE,
      sendPush: true,
    });
  }

  /**
   * Event updated notification
   */
  async onEventUpdated(
    eventId: string,
    eventNameEn: string,
    eventNameZh: string,
  ) {
    return this.broadcastToEvent({
      eventId,
      titleEn: 'Event Updated',
      titleZh: '会议信息已更新',
      bodyEn: `"${eventNameEn}" has been updated.`,
      bodyZh: `"${eventNameZh}" 信息已更新。`,
      type: NotificationType.EVENT_UPDATE,
      sendPush: true,
    });
  }

  /**
   * Material uploaded notification
   */
  async onMaterialUploaded(
    eventId: string,
    materialNameEn: string,
    materialNameZh: string,
  ) {
    return this.broadcastToEvent({
      eventId,
      titleEn: 'New Material Available',
      titleZh: '新资料已上传',
      bodyEn: `"${materialNameEn}" has been uploaded.`,
      bodyZh: `"${materialNameZh}" 已上传，请查看。`,
      type: NotificationType.MATERIAL_UPDATE,
      sendPush: true,
    });
  }

  /**
   * Check-in success notification
   */
  async onCheckInSuccess(
    userId: string,
    eventNameEn: string,
    eventNameZh: string,
  ) {
    return this.dispatch({
      userId,
      titleEn: 'Check-in Successful',
      titleZh: '签到成功',
      bodyEn: `You have checked in to "${eventNameEn}".`,
      bodyZh: `您已成功签到 "${eventNameZh}"。`,
      type: NotificationType.CHECK_IN_SUCCESS,
      sendPush: true,
    });
  }

  /**
   * Schedule reminder notification
   */
  async sendScheduleReminder(
    userId: string,
    sessionTitleEn: string,
    sessionTitleZh: string,
    roomEn: string,
    roomZh: string,
  ) {
    return this.dispatch({
      userId,
      titleEn: 'Session Starting Soon',
      titleZh: '议程即将开始',
      bodyEn: `"${sessionTitleEn}" starts in 15 minutes at ${roomEn}.`,
      bodyZh: `"${sessionTitleZh}" 将于15分钟后在 ${roomZh} 开始。`,
      type: NotificationType.SCHEDULE_REMINDER,
      sendPush: true,
    });
  }
}
