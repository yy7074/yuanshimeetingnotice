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
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { SpeakersService } from './speakers.service';
import { Speaker } from './entities/speaker.entity';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole } from '../users/entities/user.entity';

@ApiTags('Speakers')
@Controller('speakers')
export class SpeakersController {
  constructor(private speakersService: SpeakersService) {}

  @Get()
  @ApiOperation({ summary: 'Get all speakers' })
  findAll(@Query('search') search?: string) {
    return this.speakersService.findAll(search);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get speaker by ID' })
  findOne(@Param('id') id: string) {
    return this.speakersService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create speaker (admin)' })
  create(@Body() data: Partial<Speaker>) {
    return this.speakersService.create(data);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update speaker (admin)' })
  update(@Param('id') id: string, @Body() data: Partial<Speaker>) {
    return this.speakersService.update(id, data);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete speaker (admin)' })
  remove(@Param('id') id: string) {
    return this.speakersService.remove(id);
  }
}
