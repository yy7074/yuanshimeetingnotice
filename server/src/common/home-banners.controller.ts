import {
  Body,
  Controller,
  Delete,
  Get,
  NotFoundException,
  Param,
  Post,
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import {
  IsBoolean,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles, RolesGuard } from '../auth/roles.guard';
import { UserRole } from '../users/entities/user.entity';
import { HomeBannersService } from './home-banners.service';

class SaveHomeBannerDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  subtitle?: string;

  @IsOptional()
  @IsString()
  imageUrl?: string;

  @IsOptional()
  @IsString()
  linkUrl?: string;

  @IsOptional()
  @IsNumber()
  sortOrder?: number;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

@ApiTags('Home Banners')
@Controller('home-banners')
export class HomeBannersController {
  constructor(private readonly homeBannersService: HomeBannersService) {}

  @Get()
  @ApiOperation({ summary: 'List active home carousel banners' })
  findPublic() {
    return this.homeBannersService.findPublic();
  }

  @Get('admin')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'List all home carousel banners (admin)' })
  findAdmin() {
    return this.homeBannersService.findAdmin();
  }

  @Post()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a home carousel banner' })
  create(@Body() dto: SaveHomeBannerDto) {
    return this.homeBannersService.create(dto);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update a home carousel banner' })
  async update(@Param('id') id: string, @Body() dto: SaveHomeBannerDto) {
    const updated = await this.homeBannersService.update(id, dto);
    if (!updated) throw new NotFoundException('Home banner not found');
    return updated;
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete a home carousel banner' })
  async remove(@Param('id') id: string) {
    const removed = await this.homeBannersService.remove(id);
    if (!removed) throw new NotFoundException('Home banner not found');
    return { deleted: true };
  }
}
