import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { SessionsService } from './sessions.service';
import { Session } from './entities/session.entity';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole } from '../users/entities/user.entity';

@ApiTags('Sessions')
@Controller('events/:eventId/sessions')
export class SessionsController {
  constructor(private sessionsService: SessionsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all sessions for an event' })
  findByEvent(@Param('eventId') eventId: string) {
    return this.sessionsService.findByEvent(eventId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get session by ID' })
  findOne(@Param('id') id: string) {
    return this.sessionsService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create session (admin)' })
  create(@Param('eventId') eventId: string, @Body() data: Partial<Session>) {
    return this.sessionsService.create({ ...data, eventId });
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update session (admin)' })
  update(@Param('id') id: string, @Body() data: Partial<Session>) {
    return this.sessionsService.update(id, data);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete session (admin)' })
  remove(@Param('id') id: string) {
    return this.sessionsService.remove(id);
  }
}
