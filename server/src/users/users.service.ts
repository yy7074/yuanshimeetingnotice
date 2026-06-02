import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcryptjs from 'bcryptjs';
import { User, UserRole } from './entities/user.entity';
import { EmailService } from '../common/email.service';
import { CreateUserAdminDto } from './dto/create-user-admin.dto';
import { UpdateUserAdminDto } from './dto/update-user-admin.dto';
import { Notification } from '../notifications/entities/notification.entity';
import { CheckIn } from '../check-in/entities/check-in.entity';
import { Material } from '../materials/entities/material.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(Notification)
    private notifRepo: Repository<Notification>,
    @InjectRepository(CheckIn)
    private checkInRepo: Repository<CheckIn>,
    private emailService: EmailService,
  ) {}

  async createByAdmin(data: CreateUserAdminDto) {
    const email = data.email.trim().toLowerCase();
    const existing = await this.userRepo.findOne({ where: { email } });
    if (existing) {
      throw new ConflictException('Email already registered');
    }

    const nextLanguage =
      typeof data.language === 'string'
        ? data.language.trim().toLowerCase()
        : '';
    if (nextLanguage && nextLanguage !== 'zh' && nextLanguage !== 'en') {
      throw new BadRequestException('Invalid language');
    }

    const role = data.role || UserRole.ATTENDEE;
    if (!Object.values(UserRole).includes(role)) {
      throw new BadRequestException('Invalid role');
    }

    const user = this.userRepo.create({
      email,
      password: await bcryptjs.hash(data.password, 10),
      nameEn: data.nameEn?.trim() || '',
      nameZh: data.nameZh?.trim() || '',
      titleEn: data.titleEn?.trim() || '',
      titleZh: data.titleZh?.trim() || '',
      organizationEn: data.organizationEn?.trim() || '',
      organizationZh: data.organizationZh?.trim() || '',
      avatarUrl: data.avatarUrl?.trim() || '',
      role,
      language: nextLanguage || 'zh',
      isActive: typeof data.isActive === 'boolean' ? data.isActive : true,
      pushEnabled:
        typeof data.pushEnabled === 'boolean' ? data.pushEnabled : true,
    });

    const saved = await this.userRepo.save(user);
    return this.sanitizeUser(saved);
  }

  async findAll(query?: {
    search?: string;
    role?: string;
    isActive?: boolean;
    page?: number;
    pageSize?: number;
  }) {
    const qb = this.userRepo.createQueryBuilder('user');
    if (query?.role) {
      qb.where('user.role = :role', { role: query.role });
    }
    if (typeof query?.isActive === 'boolean') {
      qb.andWhere('user.is_active = :isActive', { isActive: query.isActive });
    }
    if (query?.search) {
      qb.andWhere(
        '(user.email LIKE :q OR user.name_en LIKE :q OR user.name_zh LIKE :q)',
        { q: `%${query.search}%` },
      );
    }
    qb.orderBy('user.created_at', 'DESC');

    const pageRaw = query?.page;
    const pageSizeRaw = query?.pageSize;
    const paginated = pageRaw !== undefined || pageSizeRaw !== undefined;
    if (!paginated) {
      const users = await qb.getMany();
      return users.map((user) => this.sanitizeUser(user));
    }
    const page = Math.max(1, Math.floor(pageRaw ?? 1));
    const pageSize = Math.min(500, Math.max(1, Math.floor(pageSizeRaw ?? 50)));
    qb.skip((page - 1) * pageSize).take(pageSize);
    const [users, total] = await qb.getManyAndCount();
    return {
      items: users.map((user) => this.sanitizeUser(user)),
      total,
      page,
      pageSize,
    };
  }

  async findOne(id: string) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return this.sanitizeUser(user);
  }

  async getOverview(id: string) {
    const user = await this.userRepo.findOne({
      where: { id },
      relations: ['subscribedEvents'],
    });
    if (!user) throw new NotFoundException('User not found');

    const [
      recentNotifications,
      recentCheckIns,
      unreadNotificationCount,
      totalCheckInCount,
    ] = await Promise.all([
      this.notifRepo.find({
        where: { userId: id },
        order: { createdAt: 'DESC' },
        take: 10,
      }),
      this.checkInRepo.find({
        where: { userId: id, checkedIn: true },
        relations: ['event'],
        order: { checkedInAt: 'DESC' },
        take: 10,
      }),
      this.notifRepo.count({
        where: { userId: id, isRead: false },
      }),
      this.checkInRepo.count({
        where: { userId: id, checkedIn: true },
      }),
    ]);

    return {
      user: this.sanitizeUser(user),
      stats: {
        subscribedEventsCount: user.subscribedEvents?.length || 0,
        checkInCount: totalCheckInCount,
        unreadNotificationCount,
      },
      subscribedEvents: (user.subscribedEvents || []).map((event) => ({
        id: event.id,
        titleEn: event.titleEn,
        titleZh: event.titleZh,
        startDate: event.startDate,
        endDate: event.endDate,
        status: event.status,
      })),
      recentCheckIns: recentCheckIns.map((checkIn) => ({
        id: checkIn.id,
        checkedInAt: checkIn.checkedInAt,
        eventId: checkIn.eventId,
        eventTitleEn: checkIn.event?.titleEn || '',
        eventTitleZh: checkIn.event?.titleZh || '',
      })),
      recentNotifications: recentNotifications.map((notification) => ({
        id: notification.id,
        titleEn: notification.titleEn,
        titleZh: notification.titleZh,
        type: notification.type,
        isRead: notification.isRead,
        createdAt: notification.createdAt,
      })),
    };
  }

  async updateProfile(id: string, data: Partial<User>) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');

    const nextLanguage =
      typeof data.language === 'string'
        ? data.language.trim().toLowerCase()
        : '';
    if (nextLanguage && nextLanguage !== 'zh' && nextLanguage !== 'en') {
      throw new BadRequestException('Invalid language');
    }

    const safeData = {
      nameEn:
        typeof data.nameEn === 'string' ? data.nameEn.trim() : user.nameEn,
      nameZh:
        typeof data.nameZh === 'string' ? data.nameZh.trim() : user.nameZh,
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
      language: nextLanguage || user.language,
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

  async updateRoleBatch(
    userIds: string[],
    role: UserRole,
    operatorId?: string,
  ) {
    if (!Array.isArray(userIds) || userIds.length === 0) {
      throw new BadRequestException('userIds array is required');
    }
    if (!Object.values(UserRole).includes(role)) {
      throw new BadRequestException('Invalid role');
    }
    if (operatorId && userIds.includes(operatorId) && role !== UserRole.ADMIN) {
      throw new BadRequestException(
        'Cannot change the current admin account to a non-admin role',
      );
    }

    const users = await this.userRepo.find({
      where: userIds.map((id) => ({ id })),
    });
    for (const user of users) {
      user.role = role;
    }
    await this.userRepo.save(users);

    return {
      updated: users.length,
      role,
    };
  }

  async updateByAdmin(id: string, data: UpdateUserAdminDto) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');

    const nextEmail =
      typeof data.email === 'string'
        ? data.email.trim().toLowerCase()
        : user.email;
    if (nextEmail !== user.email) {
      const existing = await this.userRepo.findOne({
        where: { email: nextEmail },
      });
      if (existing && existing.id !== id) {
        throw new ConflictException('Email already registered');
      }
    }

    const nextLanguage =
      typeof data.language === 'string'
        ? data.language.trim().toLowerCase()
        : '';
    if (nextLanguage && nextLanguage !== 'zh' && nextLanguage !== 'en') {
      throw new BadRequestException('Invalid language');
    }

    const safeData = {
      email: nextEmail,
      nameEn:
        typeof data.nameEn === 'string' ? data.nameEn.trim() : user.nameEn,
      nameZh:
        typeof data.nameZh === 'string' ? data.nameZh.trim() : user.nameZh,
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
      language: nextLanguage || user.language,
      pushEnabled:
        typeof data.pushEnabled === 'boolean'
          ? data.pushEnabled
          : user.pushEnabled,
    };

    Object.assign(user, safeData);
    const updatedUser = await this.userRepo.save(user);
    return this.sanitizeUser(updatedUser);
  }

  async updateActive(id: string, isActive: boolean, operatorId?: string) {
    if (typeof isActive !== 'boolean') {
      throw new BadRequestException('Invalid active status');
    }
    if (operatorId && operatorId === id && !isActive) {
      throw new BadRequestException(
        'Cannot deactivate the current admin account',
      );
    }
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    user.isActive = isActive;
    const updatedUser = await this.userRepo.save(user);
    return this.sanitizeUser(updatedUser);
  }

  async updateActiveBatch(
    userIds: string[],
    isActive: boolean,
    operatorId?: string,
  ) {
    if (!Array.isArray(userIds) || userIds.length === 0) {
      throw new BadRequestException('userIds array is required');
    }
    if (typeof isActive !== 'boolean') {
      throw new BadRequestException('Invalid active status');
    }
    if (operatorId && userIds.includes(operatorId) && !isActive) {
      throw new BadRequestException(
        'Cannot deactivate the current admin account',
      );
    }

    const users = await this.userRepo.find({
      where: userIds.map((id) => ({ id })),
    });
    for (const user of users) {
      user.isActive = isActive;
    }
    await this.userRepo.save(users);

    return {
      updated: users.length,
      isActive,
    };
  }

  async resetPasswordByAdmin(id: string, newPassword: string) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    user.password = await bcryptjs.hash(newPassword, 10);
    user.tokenVersion = (user.tokenVersion ?? 0) + 1;
    user.mustChangePassword = true;
    await this.userRepo.save(user);
    return { message: 'Password reset successfully.' };
  }

  async changeOwnPassword(
    id: string,
    currentPassword: string,
    newPassword: string,
  ) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    const matches = await bcryptjs.compare(currentPassword, user.password);
    if (!matches) {
      throw new BadRequestException('Current password is incorrect');
    }
    if (currentPassword === newPassword) {
      throw new BadRequestException(
        'New password must differ from current password',
      );
    }
    user.password = await bcryptjs.hash(newPassword, 10);
    user.tokenVersion = (user.tokenVersion ?? 0) + 1;
    user.mustChangePassword = false;
    await this.userRepo.save(user);
    return { message: 'Password changed successfully.' };
  }

  async deleteOwnAccount(id: string, password: string) {
    if (typeof password !== 'string' || password.length < 8) {
      throw new BadRequestException('Password is required');
    }

    return this.userRepo.manager.transaction(async (manager) => {
      const userRepo = manager.getRepository(User);
      const user = await userRepo.findOne({
        where: { id },
        relations: ['subscribedEvents'],
      });
      if (!user) throw new NotFoundException('User not found');

      const matches = await bcryptjs.compare(password, user.password);
      if (!matches) {
        throw new BadRequestException('Password is incorrect');
      }

      if (user.role === UserRole.ADMIN) {
        const activeAdminCount = await userRepo.count({
          where: { role: UserRole.ADMIN, isActive: true },
        });
        if (activeAdminCount <= 1) {
          throw new BadRequestException(
            'Cannot delete the last active admin account',
          );
        }
      }

      if (user.subscribedEvents?.length) {
        await manager
          .createQueryBuilder()
          .relation(User, 'subscribedEvents')
          .of(user)
          .remove(user.subscribedEvents);
      }

      await manager.getRepository(Notification).delete({ userId: id });
      await manager.getRepository(CheckIn).delete({ userId: id });

      const materialRepo = manager.getRepository(Material);
      const materials = await materialRepo.find();
      const changedMaterials = materials
        .map((material) => {
          const visibleUserIds = material.visibleUserIds || [];
          if (!visibleUserIds.includes(id)) return null;
          material.visibleUserIds = visibleUserIds.filter(
            (userId) => userId !== id,
          );
          return material;
        })
        .filter((material): material is Material => material !== null);
      if (changedMaterials.length > 0) {
        await materialRepo.save(changedMaterials);
      }

      await userRepo.delete(id);
      return { message: 'Account deleted successfully.' };
    });
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
