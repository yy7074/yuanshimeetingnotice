import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import { existsSync, mkdirSync } from 'fs';
import { readFile, writeFile } from 'fs/promises';
import { join } from 'path';

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

const defaultBannerTimestamp = '2026-06-10T00:00:00.000Z';

const defaultHomeBanners: HomeBanner[] = [
  {
    id: 'apscvir-default-home-01',
    title: '',
    subtitle: '',
    imageUrl: '/assets/home-banners/home-01-apscvir.webp',
    linkUrl: '',
    sortOrder: 1,
    isActive: true,
    createdAt: defaultBannerTimestamp,
    updatedAt: defaultBannerTimestamp,
  },
  {
    id: 'apscvir-default-home-02-opening-ceremony',
    title: '',
    subtitle: '',
    imageUrl: '/assets/home-banners/home-02-opening-ceremony.webp',
    linkUrl: '',
    sortOrder: 2,
    isActive: true,
    createdAt: defaultBannerTimestamp,
    updatedAt: defaultBannerTimestamp,
  },
  {
    id: 'apscvir-default-home-03-morning-run',
    title: '',
    subtitle: '',
    imageUrl: '/assets/home-banners/home-03-morning-run.webp',
    linkUrl: '',
    sortOrder: 3,
    isActive: true,
    createdAt: defaultBannerTimestamp,
    updatedAt: defaultBannerTimestamp,
  },
  {
    id: 'apscvir-default-home-04-dinner',
    title: '',
    subtitle: '',
    imageUrl: '/assets/home-banners/home-04-dinner.webp',
    linkUrl: '',
    sortOrder: 4,
    isActive: true,
    createdAt: defaultBannerTimestamp,
    updatedAt: defaultBannerTimestamp,
  },
  {
    id: 'apscvir-default-home-05-chess',
    title: '',
    subtitle: '',
    imageUrl: '/assets/home-banners/home-05-chess.webp',
    linkUrl: '',
    sortOrder: 5,
    isActive: true,
    createdAt: defaultBannerTimestamp,
    updatedAt: defaultBannerTimestamp,
  },
  {
    id: 'apscvir-default-home-06-siemens',
    title: '',
    subtitle: '',
    imageUrl: '/assets/home-banners/home-06-siemens.webp',
    linkUrl: '',
    sortOrder: 6,
    isActive: true,
    createdAt: defaultBannerTimestamp,
    updatedAt: defaultBannerTimestamp,
  },
  {
    id: 'apscvir-default-home-07-engmedicine',
    title: '',
    subtitle: '',
    imageUrl: '/assets/home-banners/home-07-engmedicine.webp',
    linkUrl: '',
    sortOrder: 7,
    isActive: true,
    createdAt: defaultBannerTimestamp,
    updatedAt: defaultBannerTimestamp,
  },
];

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
      id: randomUUID(),
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
        input.subtitle === undefined
          ? existing.subtitle
          : input.subtitle.trim(),
      imageUrl:
        input.imageUrl === undefined
          ? existing.imageUrl
          : input.imageUrl.trim(),
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
      return defaultHomeBanners;
    }
    try {
      const raw = await readFile(this.configFile, 'utf8');
      const parsed = JSON.parse(raw);
      if (!Array.isArray(parsed)) return defaultHomeBanners;
      const banners = parsed.map((item) => this.normalizeBanner(item));
      return this.withDefaultBanners(banners);
    } catch {
      return defaultHomeBanners;
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
      id: String(item.id || randomUUID()),
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

  private withDefaultBanners(banners: HomeBanner[]): HomeBanner[] {
    if (banners.length === 0) {
      return defaultHomeBanners;
    }

    const existingImageUrls = new Set(
      banners.map((banner) => banner.imageUrl.trim()),
    );
    const supplementalDefaults = defaultHomeBanners
      .slice(1)
      .filter((banner) => !existingImageUrls.has(banner.imageUrl));
    if (supplementalDefaults.length === 0) {
      return banners;
    }

    const [first, ...rest] = banners.sort(this.compareBanner);
    return [first, ...supplementalDefaults, ...rest].map((banner, index) => ({
      ...banner,
      sortOrder: index + 1,
    }));
  }
}
