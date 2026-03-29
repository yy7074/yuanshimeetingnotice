import { Controller, Get, Post, Param, UseGuards, Request, Body, Put } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { NotificationsService } from './notifications.service';
import { NotificationDispatcherService } from './notification-dispatcher.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { User, UserRole } from '../users/entities/user.entity';
import { NotificationType } from './entities/notification.entity';

@ApiTags('Notifications')
@Controller('notifications')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class NotificationsController {
  constructor(
    private notifService: NotificationsService,
    private dispatcher: NotificationDispatcherService,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Get my notifications' })
  findMy(@Request() req) {
    return this.notifService.findByUser(req.user.id);
  }

  @Get('unread-count')
  @ApiOperation({ summary: 'Get unread notification count' })
  getUnreadCount(@Request() req) {
    return this.notifService.getUnreadCount(req.user.id);
  }

  @Post(':id/read')
  @ApiOperation({ summary: 'Mark notification as read' })
  markAsRead(@Param('id') id: string, @Request() req) {
    return this.notifService.markAsRead(id, req.user.id);
  }

  @Post('read-all')
  @ApiOperation({ summary: 'Mark all notifications as read' })
  markAllAsRead(@Request() req) {
    return this.notifService.markAllAsRead(req.user.id);
  }

  @Put('fcm-token')
  @ApiOperation({ summary: 'Register FCM token for push notifications' })
  async registerFcmToken(@Request() req, @Body('token') token: string) {
    await this.userRepo.update(req.user.id, { fcmToken: token });
    return { message: 'FCM token registered' };
  }

  @Put('push-settings')
  @ApiOperation({ summary: 'Update push notification settings' })
  async updatePushSettings(@Request() req, @Body('enabled') enabled: boolean) {
    await this.userRepo.update(req.user.id, { pushEnabled: enabled });
    return { message: 'Push settings updated' };
  }

  @Post('send')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiOperation({ summary: 'Send notification to a user (admin)' })
  send(@Body() body: {
    userId: string; titleEn: string; titleZh: string;
    bodyEn: string; bodyZh: string;
    type?: string; eventId?: string;
    sendPush?: boolean; sendEmail?: boolean;
  }) {
    return this.dispatcher.dispatch({
      ...body,
      type: (body.type as NotificationType) || NotificationType.SYSTEM,
      sendPush: body.sendPush ?? true,
      sendEmail: body.sendEmail ?? false,
    });
  }

  @Post('broadcast')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiOperation({ summary: 'Broadcast notification to all users (admin)' })
  broadcast(@Body() body: {
    titleEn: string; titleZh: string;
    bodyEn: string; bodyZh: string;
    type?: string; eventId?: string;
    sendPush?: boolean; sendEmail?: boolean;
  }) {
    if (body.eventId) {
      return this.dispatcher.broadcastToEvent({
        ...body,
        eventId: body.eventId,
        type: (body.type as NotificationType) || NotificationType.SYSTEM,
      });
    }
    return this.dispatcher.broadcastToAll({
      ...body,
      type: (body.type as NotificationType) || NotificationType.SYSTEM,
    });
  }
}
