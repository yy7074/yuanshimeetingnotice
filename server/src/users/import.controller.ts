import {
  Controller,
  Post,
  UseGuards,
  Body,
  BadRequestException,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard, Roles } from '../auth/roles.guard';
import { UserRole } from './entities/user.entity';
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
  constructor(@InjectRepository(User) private userRepo: Repository<User>) {}

  private normalizeRole(role?: string): UserRole {
    const normalized = role?.trim().toLowerCase();
    switch (normalized) {
      case UserRole.ADMIN:
        return UserRole.ADMIN;
      case UserRole.SPEAKER:
        return UserRole.SPEAKER;
      case UserRole.VIP:
        return UserRole.VIP;
      case UserRole.ATTENDEE:
      case undefined:
      case '':
        return UserRole.ATTENDEE;
      default:
        return UserRole.ATTENDEE;
    }
  }

  @Post('import')
  @ApiOperation({
    summary: 'Import attendees from JSON (parsed CSV/Excel on frontend)',
  })
  async importAttendees(
    @Body()
    body: {
      attendees: Array<{
        email: string;
        nameEn?: string;
        nameZh?: string;
        role?: string;
        organizationEn?: string;
        organizationZh?: string;
      }>;
    },
  ) {
    if (!body.attendees || !Array.isArray(body.attendees)) {
      throw new BadRequestException('attendees array is required');
    }

    const results = {
      created: 0,
      skipped: 0,
      createdIds: [] as string[],
      errors: [] as string[],
    };
    const defaultPassword = await bcryptjs.hash('Welcome2026!', 10);

    for (const row of body.attendees) {
      const normalizedEmail = row.email?.toLowerCase().trim();

      if (!normalizedEmail) {
        results.errors.push(`Missing email in row`);
        continue;
      }

      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)) {
        results.errors.push(`Invalid email: ${row.email}`);
        continue;
      }

      const existing = await this.userRepo.findOne({
        where: { email: normalizedEmail },
      });
      if (existing) {
        results.skipped++;
        continue;
      }

      try {
        const user = this.userRepo.create({
          email: normalizedEmail,
          password: defaultPassword,
          nameEn: row.nameEn?.trim() || '',
          nameZh: row.nameZh?.trim() || '',
          role: this.normalizeRole(row.role),
          organizationEn: row.organizationEn?.trim() || '',
          organizationZh: row.organizationZh?.trim() || '',
          mustChangePassword: true,
        });
        const saved = await this.userRepo.save(user);
        results.created++;
        results.createdIds.push(saved.id);
      } catch (e) {
        results.errors.push(
          `Failed to create ${row.email}: ${(e as Error).message}`,
        );
      }
    }

    return results;
  }

  @Post('export')
  @ApiOperation({ summary: 'Export all users as JSON' })
  async exportUsers() {
    const users = await this.userRepo.find({ order: { createdAt: 'DESC' } });
    return users.map((u) => ({
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
