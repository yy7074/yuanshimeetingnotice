import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Res,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import type { Response } from 'express';
import { MaterialsService } from './materials.service';
import { Material } from './entities/material.entity';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole } from '../users/entities/user.entity';

@ApiTags('Materials')
@Controller('events/:eventId/materials')
export class MaterialsController {
  constructor(private materialsService: MaterialsService) {}

  @Get()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get materials for an event' })
  findByEvent(@Param('eventId') eventId: string, @Request() req) {
    return this.materialsService.findByEvent(eventId, req.user.role);
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Upload material (admin)' })
  create(@Param('eventId') eventId: string, @Body() data: Partial<Material>) {
    return this.materialsService.create({ ...data, eventId });
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update material (admin)' })
  update(@Param('id') id: string, @Body() data: Partial<Material>) {
    return this.materialsService.update(id, data);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete material (admin)' })
  remove(@Param('id') id: string) {
    return this.materialsService.remove(id);
  }

  @Post(':id/download')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Track material download' })
  download(@Param('id') id: string) {
    return this.materialsService.incrementDownload(id);
  }

  @Get(':id/file')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Download material file (role-gated, streams the protected file)',
  })
  async downloadFile(
    @Param('id') id: string,
    @Request() req,
    @Res() res: Response,
  ) {
    const { absPath, filename, material } =
      await this.materialsService.resolveDownloadPath(id, req.user.role);
    this.materialsService.incrementDownload(id).catch(() => undefined);
    const downloadName =
      (material.nameEn || material.nameZh || filename).replace(/[^\w\-. ]/g, '_');
    res.download(absPath, downloadName);
  }
}
