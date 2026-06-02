import { Controller, Get, Post, Query, Res, UseGuards } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import type { Response } from 'express';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { UserRole } from '../users/entities/user.entity';
import { ApscvirContentService } from './apscvir-content.service';

@ApiTags('APSCVIR Content')
@Controller('apscvir-content')
export class ApscvirContentController {
  constructor(private readonly apscvirContent: ApscvirContentService) {}

  @Get('manifest')
  @ApiOperation({ summary: 'Get the latest synced APSCVIR site manifest' })
  async getManifest(@Res({ passthrough: true }) res: Response) {
    res.setHeader('Cache-Control', 'public, max-age=300');
    return this.apscvirContent.getManifest();
  }

  @Get('file')
  @ApiOperation({ summary: 'Read a synced APSCVIR asset or HTML page' })
  @ApiQuery({
    name: 'path',
    required: true,
    example: 'assets/apscvir2026/site/pages/1814797-detailed-program.html',
  })
  async getFile(@Query('path') path: string, @Res() res: Response) {
    const file = await this.apscvirContent.resolveAssetFile(path || '');
    res.setHeader('Cache-Control', 'public, max-age=86400');
    return res.sendFile(file.absPath);
  }

  @Get('status')
  @ApiOperation({ summary: 'Get APSCVIR content sync status' })
  getStatus() {
    return this.apscvirContent.getStatus();
  }

  @Post('sync')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Trigger APSCVIR source-site sync (admin)' })
  sync() {
    return this.apscvirContent.sync('manual');
  }
}
