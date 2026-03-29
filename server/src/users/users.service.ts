import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
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
    return qb.getMany();
  }

  async findOne(id: string) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async updateProfile(id: string, data: Partial<User>) {
    const user = await this.findOne(id);
    const { password, role, email, ...safeData } = data as any;
    Object.assign(user, safeData);
    return this.userRepo.save(user);
  }

  async updateRole(id: string, role: string) {
    const user = await this.findOne(id);
    user.role = role as any;
    return this.userRepo.save(user);
  }

  async deactivate(id: string) {
    const user = await this.findOne(id);
    user.isActive = false;
    return this.userRepo.save(user);
  }

  async getStats() {
    const total = await this.userRepo.count();
    const active = await this.userRepo.count({ where: { isActive: true } });
    const vip = await this.userRepo.count({ where: { role: 'vip' as any } });
    return { total, active, vip };
  }
}
