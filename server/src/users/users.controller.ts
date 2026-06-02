import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiBody,
  ApiOkResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole, User } from './entities/user.entity';
import { BatchUpdateUserActiveDto } from './dto/batch-update-user-active.dto';
import { BatchUpdateUserRoleDto } from './dto/batch-update-user-role.dto';
import { CreateUserAdminDto } from './dto/create-user-admin.dto';
import { UpdateUserAdminDto } from './dto/update-user-admin.dto';
import { ResetUserPasswordDto } from './dto/reset-user-password.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { DeleteAccountDto } from './dto/delete-account.dto';

@ApiTags('Users')
@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create user directly (admin)' })
  @ApiBody({
    type: CreateUserAdminDto,
    examples: {
      default: {
        value: {
          email: 'attendee@apscvir.org',
          password: 'Welcome2026!',
          nameEn: 'Dr. Alice Chen',
          nameZh: '陈爱丽',
          role: 'attendee',
          language: 'zh',
          isActive: true,
          pushEnabled: true,
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'User created',
    schema: {
      example: {
        id: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
        email: 'attendee@apscvir.org',
        nameEn: 'Dr. Alice Chen',
        role: 'attendee',
        isActive: true,
        pushEnabled: true,
        language: 'zh',
      },
    },
  })
  create(@Body() data: CreateUserAdminDto) {
    return this.usersService.createByAdmin(data);
  }

  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get all users (admin)' })
  @ApiQuery({ name: 'search', required: false, example: 'alice' })
  @ApiQuery({ name: 'role', required: false, example: 'speaker' })
  @ApiQuery({ name: 'isActive', required: false, example: 'true' })
  @ApiQuery({ name: 'page', required: false, example: 1 })
  @ApiQuery({ name: 'pageSize', required: false, example: 50 })
  @ApiOkResponse({
    description: 'User list',
    schema: {
      example: [
        {
          id: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
          email: 'attendee@apscvir.org',
          nameEn: 'Dr. Alice Chen',
          nameZh: '陈爱丽',
          organizationEn: 'APSCVIR',
          role: 'attendee',
          isActive: true,
          pushEnabled: true,
          language: 'zh',
        },
      ],
    },
  })
  findAll(
    @Query('search') search?: string,
    @Query('role') role?: string,
    @Query('isActive') isActive?: string,
    @Query('page') page?: string,
    @Query('pageSize') pageSize?: string,
  ) {
    return this.usersService.findAll({
      search,
      role,
      isActive: isActive === undefined ? undefined : isActive === 'true',
      page: page ? Number(page) : undefined,
      pageSize: pageSize ? Number(pageSize) : undefined,
    });
  }

  @Get('stats')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get user statistics (admin)' })
  getStats() {
    return this.usersService.getStats();
  }

  @Put('batch/active')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Enable or disable users in batch (admin)' })
  @ApiBody({
    type: BatchUpdateUserActiveDto,
    examples: {
      deactivate: {
        value: {
          userIds: [
            '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
            '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
          ],
          isActive: false,
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'Batch update succeeded',
    schema: {
      example: {
        updated: 2,
        isActive: false,
      },
    },
  })
  updateActiveBatch(@Body() data: BatchUpdateUserActiveDto, @Request() req) {
    return this.usersService.updateActiveBatch(
      data.userIds,
      data.isActive,
      req.user.id,
    );
  }

  @Put('batch/role')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update user role in batch (admin)' })
  @ApiBody({
    type: BatchUpdateUserRoleDto,
    examples: {
      promoteSpeakers: {
        value: {
          userIds: [
            '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
            '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
          ],
          role: 'speaker',
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'Batch role update succeeded',
    schema: {
      example: {
        updated: 2,
        role: 'speaker',
      },
    },
  })
  updateRoleBatch(@Body() data: BatchUpdateUserRoleDto, @Request() req) {
    return this.usersService.updateRoleBatch(
      data.userIds,
      data.role,
      req.user.id,
    );
  }

  @Get(':id/overview')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get user overview with related activity (admin)' })
  @ApiOkResponse({
    description: 'User overview with recent activity',
    schema: {
      example: {
        user: {
          id: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
          email: 'attendee@apscvir.org',
          nameEn: 'Dr. Alice Chen',
          role: 'attendee',
          isActive: true,
        },
        stats: {
          subscribedEventsCount: 2,
          checkInCount: 5,
          unreadNotificationCount: 1,
        },
        subscribedEvents: [
          {
            id: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
            titleEn: 'APSCVIR Annual Summit 2026',
            titleZh: '亚太血管介入年会 2026',
            status: 'published',
          },
        ],
        recentCheckIns: [
          {
            id: '9a1f6cbb-1d3e-47ab-b0c1-8a5f2a3c2201',
            eventId: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
            eventTitleEn: 'APSCVIR Annual Summit 2026',
            eventTitleZh: '亚太血管介入年会 2026',
            checkedInAt: '2026-05-20T08:58:00.000Z',
          },
        ],
        recentNotifications: [
          {
            id: '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
            titleEn: 'Session Starting Soon',
            titleZh: '议程即将开始',
            type: 'schedule_reminder',
            isRead: false,
            createdAt: '2026-05-20T08:45:00.000Z',
          },
        ],
      },
    },
  })
  getOverview(@Param('id') id: string) {
    return this.usersService.getOverview(id);
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get user details (admin)' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Put('profile')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update current user profile' })
  updateProfile(@Request() req, @Body() data: Partial<User>) {
    return this.usersService.updateProfile(req.user.id, data);
  }

  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Change own password (invalidates other sessions)',
  })
  @ApiBody({ type: ChangePasswordDto })
  @ApiOkResponse({
    description: 'Password changed',
    schema: { example: { message: 'Password changed successfully.' } },
  })
  changePassword(@Request() req, @Body() data: ChangePasswordDto) {
    return this.usersService.changeOwnPassword(
      req.user.id,
      data.currentPassword,
      data.newPassword,
    );
  }

  @Post('delete-account')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Delete current user account',
    description:
      'Deletes the signed-in user account and associated personal app data after password confirmation.',
  })
  @ApiBody({ type: DeleteAccountDto })
  @ApiOkResponse({
    description: 'Account deleted',
    schema: { example: { message: 'Account deleted successfully.' } },
  })
  deleteOwnAccount(@Request() req, @Body() data: DeleteAccountDto) {
    return this.usersService.deleteOwnAccount(req.user.id, data.password);
  }

  @Put(':id/role')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update user role (admin)' })
  updateRole(@Param('id') id: string, @Body('role') role: string) {
    return this.usersService.updateRole(id, role);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update user profile fields (admin)' })
  @ApiBody({
    type: UpdateUserAdminDto,
    examples: {
      default: {
        value: {
          email: 'attendee@apscvir.org',
          nameEn: 'Dr. Alice Chen',
          nameZh: '陈爱丽',
          language: 'zh',
          pushEnabled: true,
        },
      },
    },
  })
  updateByAdmin(@Param('id') id: string, @Body() data: UpdateUserAdminDto) {
    return this.usersService.updateByAdmin(id, data);
  }

  @Post(':id/reset-password')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Reset user password directly (admin)' })
  @ApiBody({
    type: ResetUserPasswordDto,
    examples: {
      default: {
        value: {
          newPassword: 'NewPassw0rd123',
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'Password reset succeeded',
    schema: {
      example: {
        message: 'Password reset successfully.',
      },
    },
  })
  resetPasswordByAdmin(
    @Param('id') id: string,
    @Body() data: ResetUserPasswordDto,
  ) {
    return this.usersService.resetPasswordByAdmin(id, data.newPassword);
  }

  @Put(':id/active')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Enable or disable a user (admin)' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['isActive'],
      properties: {
        isActive: { type: 'boolean', example: false },
      },
    },
  })
  updateActive(
    @Param('id') id: string,
    @Body('isActive') isActive: boolean,
    @Request() req,
  ) {
    return this.usersService.updateActive(id, isActive, req.user.id);
  }

  @Post('send-invitations')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Send invitation emails to users (admin)' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        userIds: {
          type: 'array',
          items: { type: 'string' },
          example: [
            '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
            '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
          ],
        },
        eventId: {
          type: 'string',
          example: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
        },
        subject: {
          type: 'string',
          example: 'Welcome to APSCVIR 2026',
        },
        content: {
          type: 'string',
          example:
            'Your registration has been approved. Please sign in to the app to view your agenda.',
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'Invitation email dispatch summary',
    schema: {
      example: {
        sent: 2,
        failed: 0,
        total: 2,
      },
    },
  })
  sendInvitations(
    @Body()
    body: {
      userIds?: string[];
      eventId?: string;
      subject?: string;
      content?: string;
    },
  ) {
    return this.usersService.sendInvitations(body);
  }
}
