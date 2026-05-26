import { Injectable } from '@nestjs/common';
import { existsSync, mkdirSync } from 'fs';
import { readFile, writeFile } from 'fs/promises';
import { join } from 'path';
import { v4 as uuidv4 } from 'uuid';

export type HomeBanner = {
  id: string;
  title: string;
  subtitle: string;
  imageUrl: string;
  linkUrl: string;
  sortOrder: number;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
};

type SaveHomeBannerInput = Partial<
  Omit<HomeBanner, 'id' | 'createdAt' | 'updatedAt'>
>;

@Injectable()
export class HomeBannersService {
  private readonly configDir = join(process.cwd(), 'uploads', 'config');
  private readonly configFile = join(this.configDir, 'home-banners.json');

  async findPublic() {
    const banners = await this.readAll();
    return banners
      .filter((banner) => banner.isActive && banner.imageUrl.trim())
      .sort(this.compareBanner);
  }

  async findAdmin() {
    const banners = await this.readAll();
    return banners.sort(this.compareBanner);
  }

  async create(input: SaveHomeBannerInput) {
    const now = new Date().toISOString();
    const banners = await this.readAll();
    const banner: HomeBanner = {
      id: uuidv4(),
      title: input.title?.trim() ?? '',
      subtitle: input.subtitle?.trim() ?? '',
      imageUrl: input.imageUrl?.trim() ?? '',
      linkUrl: input.linkUrl?.trim() ?? '',
      sortOrder: Number(input.sortOrder ?? banners.length + 1),
      isActive: input.isActive ?? true,
      createdAt: now,
      updatedAt: now,
    };
    banners.push(banner);
    await this.writeAll(banners);
    return banner;
  }

  async update(id: string, input: SaveHomeBannerInput) {
    const banners = await this.readAll();
    const index = banners.findIndex((banner) => banner.id === id);
    if (index < 0) {
      return null;
    }
    const existing = banners[index];
    const updated: HomeBanner = {
      ...existing,
      ...input,
      title: input.title === undefined ? existing.title : input.title.trim(),
      subtitle:
        input.subtitle === undefined ? existing.subtitle : input.subtitle.trim(),
      imageUrl:
        input.imageUrl === undefined ? existing.imageUrl : input.imageUrl.trim(),
      linkUrl:
        input.linkUrl === undefined ? existing.linkUrl : input.linkUrl.trim(),
      sortOrder:
        input.sortOrder === undefined
          ? existing.sortOrder
          : Number(input.sortOrder),
      isActive:
        input.isActive === undefined ? existing.isActive : input.isActive,
      updatedAt: new Date().toISOString(),
    };
    banners[index] = updated;
    await this.writeAll(banners);
    return updated;
  }

  async remove(id: string) {
    const banners = await this.readAll();
    const next = banners.filter((banner) => banner.id !== id);
    if (next.length === banners.length) {
      return false;
    }
    await this.writeAll(next);
    return true;
  }

  private compareBanner(a: HomeBanner, b: HomeBanner) {
    if (a.sortOrder !== b.sortOrder) return a.sortOrder - b.sortOrder;
    return a.createdAt.localeCompare(b.createdAt);
  }

  private async readAll(): Promise<HomeBanner[]> {
    if (!existsSync(this.configFile)) {
      return [];
    }
    try {
      const raw = await readFile(this.configFile, 'utf8');
      const parsed = JSON.parse(raw);
      if (!Array.isArray(parsed)) return [];
      return parsed.map((item) => this.normalizeBanner(item));
    } catch {
      return [];
    }
  }

  private async writeAll(banners: HomeBanner[]) {
    if (!existsSync(this.configDir)) {
      mkdirSync(this.configDir, { recursive: true });
    }
    await writeFile(this.configFile, JSON.stringify(banners, null, 2));
  }

  private normalizeBanner(item: any): HomeBanner {
    const now = new Date().toISOString();
    return {
      id: String(item.id || uuidv4()),
      title: String(item.title || ''),
      subtitle: String(item.subtitle || ''),
      imageUrl: String(item.imageUrl || ''),
      linkUrl: String(item.linkUrl || ''),
      sortOrder: Number(item.sortOrder ?? 0),
      isActive: item.isActive !== false,
      createdAt: String(item.createdAt || now),
      updatedAt: String(item.updatedAt || item.createdAt || now),
    };
  }
}
