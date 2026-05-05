import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Notification } from './entities/notification.entity';
import { User } from '../users/entities/user.entity';
import { Session } from '../sessions/entities/session.entity';
import { NotificationsService } from './notifications.service';
import { NotificationsController } from './notifications.controller';
import { NotificationDispatcherService } from './notification-dispatcher.service';
import { ScheduleReminderService } from './schedule-reminder.service';

@Module({
  imports: [TypeOrmModule.forFeature([Notification, User, Session])],
  controllers: [NotificationsController],
  providers: [
    NotificationsService,
    NotificationDispatcherService,
    ScheduleReminderService,
  ],
  exports: [NotificationsService, NotificationDispatcherService],
})
export class NotificationsModule {}
