import { Controller, Post, UseInterceptors, UploadedFile, UseGuards, Body, BadRequestException } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiConsumes } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole } from './entities/user.entity';
import { UsersService } from './users.service';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import * as bcryptjs from 'bcryptjs';

@ApiTags('User Import')
@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN)
@ApiBearerAuth()
export class ImportController {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  @Post('import')
  @ApiOperation({ summary: 'Import attendees from JSON (parsed CSV/Excel on frontend)' })
  async importAttendees(@Body() body: {
    attendees: Array<{
      email: string;
      nameEn?: string;
      nameZh?: string;
      role?: string;
      organizationEn?: string;
      organizationZh?: string;
    }>;
  }) {
    if (!body.attendees || !Array.isArray(body.attendees)) {
      throw new BadRequestException('attendees array is required');
    }

    const results = { created: 0, skipped: 0, errors: [] as string[] };
    const defaultPassword = await bcryptjs.hash('Welcome2026!', 10);

    for (const row of body.attendees) {
      if (!row.email) {
        results.errors.push(`Missing email in row`);
        continue;
      }

      const existing = await this.userRepo.findOne({ where: { email: row.email.toLowerCase().trim() } });
      if (existing) {
        results.skipped++;
        continue;
      }

      try {
        const user = this.userRepo.create({
          email: row.email.toLowerCase().trim(),
          password: defaultPassword,
          nameEn: row.nameEn || '',
          nameZh: row.nameZh || '',
          role: (row.role as UserRole) || UserRole.ATTENDEE,
          organizationEn: row.organizationEn || '',
          organizationZh: row.organizationZh || '',
        });
        await this.userRepo.save(user);
        results.created++;
      } catch (e) {
        results.errors.push(`Failed to create ${row.email}: ${(e as Error).message}`);
      }
    }

    return results;
  }

  @Post('export')
  @ApiOperation({ summary: 'Export all users as JSON' })
  async exportUsers() {
    const users = await this.userRepo.find({ order: { createdAt: 'DESC' } });
    return users.map(u => ({
      email: u.email,
      nameEn: u.nameEn,
      nameZh: u.nameZh,
      role: u.role,
      organizationEn: u.organizationEn,
      organizationZh: u.organizationZh,
      isActive: u.isActive,
      createdAt: u.createdAt,
    }));
  }
}
