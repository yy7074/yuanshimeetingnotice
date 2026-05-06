import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
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
  ApiOkResponse,
  ApiCreatedResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { EventsService } from './events.service';
import { CreateEventDto, UpdateEventDto } from './dto/event.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole } from '../users/entities/user.entity';

@ApiTags('Events')
@Controller('events')
export class EventsController {
  constructor(private eventsService: EventsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all events' })
  @ApiQuery({ name: 'search', required: false, example: 'summit' })
  @ApiQuery({ name: 'status', required: false, example: 'published' })
  @ApiQuery({ name: 'region', required: false, example: '上海' })
  @ApiOkResponse({
    description: 'Event list',
    schema: {
      example: [
        {
          id: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
          titleEn: 'APSCVIR Annual Summit 2026',
          titleZh: '亚太血管介入年会 2026',
          locationEn: 'Shanghai Convention Center',
          locationZh: '上海国际会议中心',
          startDate: '2026-05-20T09:00:00.000Z',
          endDate: '2026-05-22T17:00:00.000Z',
          organizerEn: 'APSCVIR',
          organizerZh: '亚太血管介入学会',
          tags: ['intervention', 'vascular'],
          isFeatured: true,
          maxAttendees: 1200,
          status: 'published',
        },
      ],
    },
  })
  findAll(
    @Query('search') search?: string,
    @Query('status') status?: string,
    @Query('region') region?: string,
  ) {
    return this.eventsService.findAll({ search, status, region });
  }

  @Get('regions')
  @ApiOperation({ summary: 'List distinct event regions (for filter dropdown)' })
  getRegions() {
    return this.eventsService.getRegions();
  }

  @Get('stats')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get event statistics (admin)' })
  getStats() {
    return this.eventsService.getStats();
  }

  @Get('my')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get my subscribed events' })
  getMyEvents(@Request() req) {
    return this.eventsService.getMyEvents(req.user.id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get event by ID' })
  findOne(@Param('id') id: string) {
    return this.eventsService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create event (admin)' })
  @ApiCreatedResponse({
    description: 'Event created',
    schema: {
      example: {
        id: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
        titleEn: 'APSCVIR Annual Summit 2026',
        titleZh: '亚太血管介入年会 2026',
        descriptionEn: 'Three-day conference for vascular intervention specialists.',
        descriptionZh: '面向血管介入专家的三天会议。',
        locationEn: 'Shanghai Convention Center',
        locationZh: '上海国际会议中心',
        imageUrl: 'https://cdn.example.com/events/apscvir-2026-cover.jpg',
        bannerUrl: 'https://cdn.example.com/events/apscvir-2026-banner.jpg',
        startDate: '2026-05-20T09:00:00.000Z',
        endDate: '2026-05-22T17:00:00.000Z',
        organizerEn: 'APSCVIR',
        organizerZh: '亚太血管介入学会',
        tags: ['intervention', 'vascular'],
        isFeatured: true,
        maxAttendees: 1200,
        status: 'published',
      },
    },
  })
  create(@Body() dto: CreateEventDto) {
    return this.eventsService.create(dto);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update event (admin)' })
  @ApiOkResponse({
    description: 'Event updated',
    schema: {
      example: {
        id: '6b0d3a51-5af0-4855-8b58-593cb551c5fb',
        titleEn: 'APSCVIR Annual Summit 2026',
        titleZh: '亚太血管介入年会 2026',
        status: 'published',
        isFeatured: true,
        maxAttendees: 1500,
      },
    },
  })
  update(@Param('id') id: string, @Body() dto: UpdateEventDto) {
    return this.eventsService.update(id, dto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete event (admin)' })
  remove(@Param('id') id: string) {
    return this.eventsService.remove(id);
  }

  @Post(':id/subscribe')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Subscribe to an event' })
  @ApiOkResponse({
    description: 'Subscription succeeded',
    schema: {
      example: {
        message: 'Subscribed successfully',
      },
    },
  })
  subscribe(@Param('id') id: string, @Request() req) {
    return this.eventsService.subscribe(id, req.user.id);
  }

  @Delete(':id/subscribe')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Unsubscribe from an event' })
  @ApiOkResponse({
    description: 'Unsubscribe succeeded',
    schema: {
      example: {
        message: 'Unsubscribed successfully',
      },
    },
  })
  unsubscribe(@Param('id') id: string, @Request() req) {
    return this.eventsService.unsubscribe(id, req.user.id);
  }
}
