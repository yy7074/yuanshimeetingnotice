import {
  Controller,
  Get,
  Post,
  Param,
  Query,
  UseGuards,
  Request,
  Body,
  Put,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiBody,
  ApiOkResponse,
  ApiQuery,
} from '@nestjs/swagger';
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
  @ApiOperation({ summary: 'Get my notifications (paginated)' })
  @ApiQuery({ name: 'page', required: false, example: 1 })
  @ApiQuery({ name: 'pageSize', required: false, example: 50 })
  @ApiOkResponse({
    description: 'Paginated notification list',
    schema: {
      example: {
        items: [
          {
            id: '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
            titleEn: 'Session Starting Soon',
            titleZh: '议程即将开始',
            type: 'schedule_reminder',
            isRead: false,
            createdAt: '2026-04-15T10:45:00.000Z',
          },
        ],
        total: 42,
        page: 1,
        pageSize: 50,
      },
    },
  })
  findMy(
    @Request() req,
    @Query('page') page?: string,
    @Query('pageSize') pageSize?: string,
  ) {
    return this.notifService.findByUser(req.user.id, {
      page: page ? Number(page) : undefined,
      pageSize: pageSize ? Number(pageSize) : undefined,
    });
  }

  @Get('unread-count')
  @ApiOperation({ summary: 'Get unread notification count' })
  @ApiOkResponse({
    description: 'Unread notification count',
    schema: {
      example: {
        unreadCount: 3,
      },
    },
  })
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
  @ApiBody({
    schema: {
      type: 'object',
      required: ['token'],
      properties: {
        token: {
          type: 'string',
          example: 'fcm_device_token_example_123456',
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'FCM token saved',
    schema: {
      example: {
        message: 'FCM token registered',
      },
    },
  })
  async registerFcmToken(@Request() req, @Body('token') token: string) {
    await this.userRepo.update(req.user.id, { fcmToken: token });
    return { message: 'FCM token registered' };
  }

  @Put('push-settings')
  @ApiOperation({ summary: 'Update push notification settings' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['enabled'],
      properties: {
        enabled: { type: 'boolean', example: true },
      },
    },
  })
  @ApiOkResponse({
    description: 'Push settings updated',
    schema: {
      example: {
        message: 'Push settings updated',
      },
    },
  })
  async updatePushSettings(@Request() req, @Body('enabled') enabled: boolean) {
    await this.userRepo.update(req.user.id, { pushEnabled: enabled });
    return { message: 'Push settings updated' };
  }

  @Post('send')
  @UseGuards(RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiOperation({ summary: 'Send notification to a user (admin)' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['userId', 'titleEn', 'titleZh', 'bodyEn', 'bodyZh'],
      properties: {
        userId: {
          type: 'string',
          example: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
        },
        titleEn: { type: 'string', example: 'Material Updated' },
        titleZh: { type: 'string', example: '资料已更新' },
        bodyEn: {
          type: 'string',
          example: 'The presentation slides for Session 1 are now available.',
        },
        bodyZh: {
          type: 'string',
          example: '第一场议程的演示文稿现已开放下载。',
        },
        type: { type: 'string', example: 'material_update' },
        eventId: {
          type: 'string',
          example: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
        },
        sendPush: { type: 'boolean', example: true },
        sendEmail: { type: 'boolean', example: false },
      },
    },
  })
  @ApiOkResponse({
    description: 'Notification stored and dispatched',
    schema: {
      example: {
        id: '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
        userId: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
        titleEn: 'Material Updated',
        titleZh: '资料已更新',
        bodyEn: 'The presentation slides for Session 1 are now available.',
        bodyZh: '第一场议程的演示文稿现已开放下载。',
        type: 'material_update',
        isRead: false,
        eventId: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
      },
    },
  })
  send(
    @Body()
    body: {
      userId: string;
      titleEn: string;
      titleZh: string;
      bodyEn: string;
      bodyZh: string;
      type?: string;
      eventId?: string;
      sendPush?: boolean;
      sendEmail?: boolean;
    },
  ) {
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
  @ApiBody({
    schema: {
      type: 'object',
      required: ['titleEn', 'titleZh', 'bodyEn', 'bodyZh'],
      properties: {
        titleEn: { type: 'string', example: 'Event Schedule Updated' },
        titleZh: { type: 'string', example: '会议日程已更新' },
        bodyEn: {
          type: 'string',
          example: 'Please refresh the app to see the latest agenda.',
        },
        bodyZh: {
          type: 'string',
          example: '请刷新 App 查看最新日程。',
        },
        type: { type: 'string', example: 'event_update' },
        eventId: {
          type: 'string',
          example: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
        },
        userIds: {
          type: 'array',
          items: { type: 'string' },
          example: [
            '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
            '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
          ],
        },
        role: { type: 'string', example: 'speaker' },
        isActive: { type: 'boolean', example: true },
        search: { type: 'string', example: 'alice' },
        sendPush: { type: 'boolean', example: true },
        sendEmail: { type: 'boolean', example: true },
      },
    },
  })
  @ApiOkResponse({
    description: 'Broadcast accepted',
    schema: {
      example: {
        sent: 12,
        eventId: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
      },
    },
  })
  broadcast(
    @Body()
    body: {
      titleEn: string;
      titleZh: string;
      bodyEn: string;
      bodyZh: string;
      type?: string;
      eventId?: string;
      userIds?: string[];
      role?: UserRole;
      isActive?: boolean;
      search?: string;
      sendPush?: boolean;
      sendEmail?: boolean;
    },
  ) {
    const hasUserFilter =
      (Array.isArray(body.userIds) && body.userIds.length > 0) ||
      !!body.role ||
      typeof body.isActive === 'boolean' ||
      !!body.search?.trim();

    if (hasUserFilter) {
      return this.dispatcher.broadcastByFilter({
        ...body,
        type: (body.type as NotificationType) || NotificationType.SYSTEM,
      });
    }

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
