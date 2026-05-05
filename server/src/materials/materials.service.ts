import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { existsSync } from 'fs';
import { basename, join, resolve } from 'path';
import { Material } from './entities/material.entity';
import { NotificationDispatcherService } from '../notifications/notification-dispatcher.service';
import { UserRole } from '../users/entities/user.entity';

@Injectable()
export class MaterialsService {
  private readonly logger = new Logger(MaterialsService.name);
  private readonly materialsDir = resolve(process.cwd(), 'uploads', 'materials');

  constructor(
    @InjectRepository(Material) private materialRepo: Repository<Material>,
    private notificationDispatcher: NotificationDispatcherService,
  ) {}

  canUserAccess(material: Material, userRole: string): boolean {
    if (userRole === UserRole.ADMIN) return true;
    const visibleTo = Array.isArray(material.visibleTo) ? material.visibleTo : [];
    return visibleTo.length === 0 || visibleTo.includes(userRole);
  }

  async resolveDownloadPath(id: string, userRole: string) {
    const material = await this.findOne(id);
    if (!this.canUserAccess(material, userRole)) {
      throw new ForbiddenException('You do not have access to this material');
    }
    const raw = (material.fileUrl || '').trim();
    if (!raw) {
      throw new NotFoundException('Material file is missing');
    }
    // Only permit files that live under uploads/materials/ — never traverse out.
    const cleaned = raw.replace(/^\/+/, '');
    const match = cleaned.match(/^uploads\/materials\/(.+)$/);
    if (!match) {
      throw new ForbiddenException(
        'Material is stored in a legacy public location; re-upload via the admin to enable gated download.',
      );
    }
    const safeName = basename(match[1]);
    const absPath = join(this.materialsDir, safeName);
    const normalized = resolve(absPath);
    if (!normalized.startsWith(this.materialsDir + require('path').sep)) {
      throw new ForbiddenException('Invalid material path');
    }
    if (!existsSync(normalized)) {
      throw new NotFoundException('Material file is missing on disk');
    }
    return { material, absPath: normalized, filename: safeName };
  }

  async findByEvent(eventId: string, userRole?: string) {
    const materials = await this.materialRepo.find({
      where: { eventId },
      order: { createdAt: 'DESC' },
    });
    if (userRole) {
      return materials.filter((material) => {
        const visibleTo = Array.isArray(material.visibleTo)
          ? material.visibleTo
          : [];
        return visibleTo.length === 0 || visibleTo.includes(userRole);
      });
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
    const saved = await this.materialRepo.save(material);

    // Notify event subscribers about new material
    if (saved.eventId) {
      this.notificationDispatcher
        .onMaterialUploaded(
          saved.eventId,
          saved.nameEn || '',
          saved.nameZh || '',
        )
        .catch((e) =>
          this.logger.warn(
            `Failed to dispatch material notification: ${e.message}`,
          ),
        );
    }

    return saved;
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
