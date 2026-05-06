import { Controller, Get, Query } from '@nestjs/common';
import { ApiOperation, ApiQuery, ApiTags } from '@nestjs/swagger';
import { SessionsService } from './sessions.service';

/**
 * Top-level /sessions endpoints for cross-event aggregations. The per-event
 * CRUD lives on SessionsController under /events/:eventId/sessions.
 */
@ApiTags('Sessions')
@Controller('sessions')
export class SessionsStatsController {
  constructor(private sessionsService: SessionsService) {}

  @Get('popular')
  @ApiOperation({ summary: 'Top-N most viewed sessions across all events' })
  @ApiQuery({ name: 'limit', required: false, example: 10 })
  popular(@Query('limit') limit?: string) {
    const n = limit ? parseInt(limit, 10) : 10;
    return this.sessionsService.findPopular(Number.isFinite(n) ? n : 10);
  }
}
