import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, Raw } from 'typeorm';
import { Session } from '../sessions/entities/session.entity';
import { User } from '../users/entities/user.entity';
import { NotificationDispatcherService } from './notification-dispatcher.service';

const scheduleTimeZone = process.env.SCHEDULE_TIMEZONE || 'Asia/Shanghai';

@Injectable()
export class ScheduleReminderService {
  private readonly logger = new Logger(ScheduleReminderService.name);

  constructor(
    @InjectRepository(Session) private sessionRepo: Repository<Session>,
    @InjectRepository(User) private userRepo: Repository<User>,
    private notificationDispatcher: NotificationDispatcherService,
  ) {}

  /**
   * Run every 5 minutes to check for sessions starting in the next 15 minutes.
   * Sends reminders to all subscribers of the event containing those sessions.
   */
  @Cron(CronExpression.EVERY_5_MINUTES, { timeZone: scheduleTimeZone })
  async handleSessionReminders() {
    const now = new Date();
    const in15Min = new Date(now.getTime() + 15 * 60 * 1000);
    const in20Min = new Date(now.getTime() + 20 * 60 * 1000);

    // Use a half-open time window [15m, 20m) so boundary sessions are not
    // picked up twice by adjacent cron ticks.
    const sessions = await this.sessionRepo.find({
      where: {
        startTime: Raw(
          (alias) => `${alias} >= :windowStart AND ${alias} < :windowEnd`,
          {
            windowStart: in15Min,
            windowEnd: in20Min,
          },
        ),
      },
      relations: ['event'],
    });

    if (sessions.length === 0) return;

    this.logger.log(
      `Found ${sessions.length} sessions starting in ~15 minutes`,
    );

    for (const session of sessions) {
      if (!session.event) continue;

      // Get all subscribers of this event
      const subscribers = await this.userRepo
        .createQueryBuilder('u')
        .innerJoin('u.subscribedEvents', 'e', 'e.id = :eventId', {
          eventId: session.eventId,
        })
        .getMany();

      for (const user of subscribers) {
        this.notificationDispatcher
          .sendScheduleReminder(
            user.id,
            session.titleEn,
            session.titleZh,
            session.roomEn,
            session.roomZh,
          )
          .catch((e) =>
            this.logger.warn(
              `Failed to send reminder to user ${user.id}: ${e.message}`,
            ),
          );
      }
    }
  }

  /**
   * Daily summary at 9:00 AM - remind users of today's schedule
   */
  @Cron('0 9 * * *', { timeZone: scheduleTimeZone })
  async handleDailySummary() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today.getTime() + 24 * 60 * 60 * 1000);

    // Find all sessions today
    const sessions = await this.sessionRepo.find({
      where: {
        startTime: Between(today, tomorrow),
      },
      relations: ['event'],
    });

    if (sessions.length === 0) return;

    // Group sessions by eventId
    const eventSessions = new Map<string, { event: any; count: number }>();
    for (const session of sessions) {
      if (!session.event) continue;
      if (!eventSessions.has(session.eventId)) {
        eventSessions.set(session.eventId, { event: session.event, count: 0 });
      }
      eventSessions.get(session.eventId)!.count += 1;
    }

    this.logger.log(
      `Daily summary: ${sessions.length} sessions across ${eventSessions.size} events today`,
    );

    for (const [eventId, { event, count }] of eventSessions) {
      // Get all subscribers
      const subscribers = await this.userRepo
        .createQueryBuilder('u')
        .innerJoin('u.subscribedEvents', 'e', 'e.id = :eventId', { eventId })
        .getMany();

      for (const user of subscribers) {
        this.notificationDispatcher
          .dispatch({
            userId: user.id,
            titleEn: "Today's Schedule",
            titleZh: '今日日程提醒',
            bodyEn: `You have ${count} session${count > 1 ? 's' : ''} today at "${event.titleEn}".`,
            bodyZh: `您今天在"${event.titleZh}"有 ${count} 场议程。`,
            type: 'schedule_reminder' as any,
            eventId,
            sendPush: true,
          })
          .catch((e) =>
            this.logger.warn(
              `Failed to send daily summary to user ${user.id}: ${e.message}`,
            ),
          );
      }
    }
  }
}
