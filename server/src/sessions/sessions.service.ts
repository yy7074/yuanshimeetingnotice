import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Session } from './entities/session.entity';

@Injectable()
export class SessionsService {
  constructor(
    @InjectRepository(Session) private sessionRepo: Repository<Session>,
  ) {}

  async findByEvent(eventId: string) {
    return this.sessionRepo.find({
      where: { eventId },
      order: { dayIndex: 'ASC', startTime: 'ASC' },
      relations: ['speaker'],
    });
  }

  async findOne(id: string) {
    const session = await this.sessionRepo.findOne({ where: { id }, relations: ['speaker'] });
    if (!session) throw new NotFoundException('Session not found');
    return session;
  }

  async create(data: Partial<Session>) {
    const session = this.sessionRepo.create(data);
    return this.sessionRepo.save(session);
  }

  async update(id: string, data: Partial<Session>) {
    const session = await this.findOne(id);
    Object.assign(session, data);
    return this.sessionRepo.save(session);
  }

  async remove(id: string) {
    const session = await this.findOne(id);
    return this.sessionRepo.remove(session);
  }
}
