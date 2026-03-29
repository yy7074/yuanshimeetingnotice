import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Material } from './entities/material.entity';

@Injectable()
export class MaterialsService {
  constructor(
    @InjectRepository(Material) private materialRepo: Repository<Material>,
  ) {}

  async findByEvent(eventId: string, userRole?: string) {
    const materials = await this.materialRepo.find({
      where: { eventId },
      order: { createdAt: 'DESC' },
    });
    if (userRole) {
      return materials.filter((m) => m.visibleTo.includes(userRole));
    }
    return materials;
  }

  async findOne(id: string) {
    const material = await this.materialRepo.findOne({ where: { id } });
    if (!material) throw new NotFoundException('Material not found');
    return material;
  }

  async create(data: Partial<Material>) {
    const material = this.materialRepo.create(data);
    return this.materialRepo.save(material);
  }

  async update(id: string, data: Partial<Material>) {
    const material = await this.findOne(id);
    Object.assign(material, data);
    return this.materialRepo.save(material);
  }

  async remove(id: string) {
    const material = await this.findOne(id);
    return this.materialRepo.remove(material);
  }

  async incrementDownload(id: string) {
    await this.materialRepo.increment({ id }, 'downloadCount', 1);
    return this.findOne(id);
  }
}
