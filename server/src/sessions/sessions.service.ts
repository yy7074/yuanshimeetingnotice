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
    const session = await this.sessionRepo.findOne({
      where: { id },
      relations: ['speaker'],
    });
    if (!session) throw new NotFoundException('Session not found');
    // Fire-and-forget popularity counter; do not let stat tracking impact
    // the response time or fail the request.
    this.sessionRepo.increment({ id }, 'viewCount', 1).catch(() => undefined);
    return session;
  }

  /**
   * Top-N most-viewed sessions across every event. Used by the admin dashboard
   * "热门 Session" card.
   */
  async findPopular(limit = 10) {
    const safeLimit = Math.min(Math.max(limit, 1), 50);
    return this.sessionRepo
      .createQueryBuilder('session')
      .leftJoinAndSelect('session.event', 'event')
      .leftJoinAndSelect('session.speaker', 'speaker')
      .where('session.view_count > 0')
      .orderBy('session.view_count', 'DESC')
      .addOrderBy('session.start_time', 'DESC')
      .limit(safeLimit)
      .getMany();
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
