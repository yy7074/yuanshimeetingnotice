import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Speaker } from './entities/speaker.entity';

@Injectable()
export class SpeakersService {
  constructor(
    @InjectRepository(Speaker) private speakerRepo: Repository<Speaker>,
  ) {}

  async findAll(search?: string) {
    if (search) {
      return this.speakerRepo
        .createQueryBuilder('s')
        .where(
          's.name_en LIKE :q OR s.name_zh LIKE :q OR s.organization_en LIKE :q',
          { q: `%${search}%` },
        )
        .orderBy('s.category', 'ASC')
        .getMany();
    }
    return this.speakerRepo.find({ order: { category: 'ASC' } });
  }

  async findOne(id: string) {
    const speaker = await this.speakerRepo.findOne({ where: { id } });
    if (!speaker) throw new NotFoundException('Speaker not found');
    return speaker;
  }

  async create(data: Partial<Speaker>) {
    const speaker = this.speakerRepo.create(data);
    return this.speakerRepo.save(speaker);
  }

  async update(id: string, data: Partial<Speaker>) {
    const speaker = await this.findOne(id);
    Object.assign(speaker, data);
    return this.speakerRepo.save(speaker);
  }

  async remove(id: string) {
    const speaker = await this.findOne(id);
    return this.speakerRepo.remove(speaker);
  }
}
