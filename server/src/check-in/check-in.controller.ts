import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { CheckInService } from './check-in.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole } from '../users/entities/user.entity';

@ApiTags('Check-in')
@Controller('check-in')
export class CheckInController {
  constructor(private checkInService: CheckInService) {}

  @Post('generate/:eventId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Generate QR code for check-in' })
  generateQr(@Param('eventId') eventId: string, @Request() req) {
    return this.checkInService.generateQrCode(req.user.id, eventId);
  }

  @Post('verify')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Verify QR code (admin/scanner)' })
  verify(@Body('qrCode') qrCode: string) {
    return this.checkInService.verify(qrCode);
  }

  @Get('my/:eventId')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get my check-in status for an event' })
  getMyCheckIn(@Param('eventId') eventId: string, @Request() req) {
    return this.checkInService.getMyCheckIn(req.user.id, eventId);
  }

  @Get('event/:eventId')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get check-in records for event (admin)' })
  getCheckIns(@Param('eventId') eventId: string) {
    return this.checkInService.getCheckIns(eventId);
  }

  @Get('stats/:eventId')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get check-in stats (admin)' })
  getStats(@Param('eventId') eventId: string) {
    return this.checkInService.getStats(eventId);
  }
}
