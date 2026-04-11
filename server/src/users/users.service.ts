import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import { EmailService } from '../common/email.service';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
    private emailService: EmailService,
  ) {}

  async findAll(query?: { search?: string; role?: string }) {
    const qb = this.userRepo.createQueryBuilder('user');
    if (query?.role) {
      qb.where('user.role = :role', { role: query.role });
    }
    if (query?.search) {
      qb.andWhere(
        '(user.email LIKE :q OR user.name_en LIKE :q OR user.name_zh LIKE :q)',
        { q: `%${query.search}%` },
      );
    }
    qb.orderBy('user.created_at', 'DESC');
    const users = await qb.getMany();
    return users.map((user) => this.sanitizeUser(user));
  }

  async findOne(id: string) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return this.sanitizeUser(user);
  }

  async updateProfile(id: string, data: Partial<User>) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');

    const nextLanguage =
      typeof data.language === 'string' ? data.language.trim().toLowerCase() : '';
    if (nextLanguage && nextLanguage !== 'zh' && nextLanguage !== 'en') {
      throw new BadRequestException('Invalid language');
    }

    const safeData = {
      nameEn: typeof data.nameEn === 'string' ? data.nameEn.trim() : user.nameEn,
      nameZh: typeof data.nameZh === 'string' ? data.nameZh.trim() : user.nameZh,
      titleEn:
        typeof data.titleEn === 'string' ? data.titleEn.trim() : user.titleEn,
      titleZh:
        typeof data.titleZh === 'string' ? data.titleZh.trim() : user.titleZh,
      organizationEn:
        typeof data.organizationEn === 'string'
          ? data.organizationEn.trim()
          : user.organizationEn,
      organizationZh:
        typeof data.organizationZh === 'string'
          ? data.organizationZh.trim()
          : user.organizationZh,
      avatarUrl:
        typeof data.avatarUrl === 'string'
          ? data.avatarUrl.trim()
          : user.avatarUrl,
      language:
        nextLanguage || user.language,
    };

    Object.assign(user, safeData);
    const updatedUser = await this.userRepo.save(user);
    return this.sanitizeUser(updatedUser);
  }

  async updateRole(id: string, role: string) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    if (!Object.values(UserRole).includes(role as UserRole)) {
      throw new BadRequestException('Invalid role');
    }
    user.role = role as UserRole;
    const updatedUser = await this.userRepo.save(user);
    return this.sanitizeUser(updatedUser);
  }

  async deactivate(id: string) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    user.isActive = false;
    const updatedUser = await this.userRepo.save(user);
    return this.sanitizeUser(updatedUser);
  }

  async getStats() {
    const total = await this.userRepo.count();
    const active = await this.userRepo.count({ where: { isActive: true } });
    const vip = await this.userRepo.count({ where: { role: 'vip' as any } });
    return { total, active, vip };
  }

  async sendInvitations(data: {
    userIds?: string[];
    eventId?: string;
    subject?: string;
    content?: string;
  }) {
    let users: User[];

    if (data.userIds && data.userIds.length > 0) {
      users = await this.userRepo.find({
        where: data.userIds.map((id) => ({ id })),
      });
    } else {
      users = await this.userRepo.find();
    }

    let sent = 0;
    let failed = 0;

    for (const user of users) {
      try {
        await this.emailService.sendInvitationEmail(
          user.email,
          user.nameEn || user.nameZh || 'Attendee',
          data.subject || 'You are invited to APSCVIR Conference',
          data.content,
          data.eventId,
        );
        sent++;
      } catch (e) {
        failed++;
      }
    }

    return { sent, failed, total: users.length };
  }

  private sanitizeUser(user: User) {
    const { password, ...safeUser } = user;
    return safeUser;
  }
}
