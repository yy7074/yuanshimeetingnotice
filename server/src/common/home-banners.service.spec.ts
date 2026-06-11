import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from 'fs';
import { join } from 'path';
import { tmpdir } from 'os';
import { HomeBannersService } from './home-banners.service';

describe('HomeBannersService', () => {
  const originalCwd = process.cwd();
  let tmpRoot: string;

  beforeEach(() => {
    tmpRoot = mkdtempSync(join(tmpdir(), 'home-banners-'));
    process.chdir(tmpRoot);
  });

  afterEach(() => {
    process.chdir(originalCwd);
    rmSync(tmpRoot, { recursive: true, force: true });
  });

  it('returns default APSCVIR banners in order when no admin config exists', async () => {
    const service = new HomeBannersService();

    const banners = await service.findPublic();

    expect(banners.map((banner) => banner.imageUrl)).toEqual([
      '/assets/home-banners/home-01-apscvir.webp',
      '/assets/home-banners/home-02-opening-ceremony.webp',
      '/assets/home-banners/home-03-morning-run.webp',
      '/assets/home-banners/home-04-dinner.webp',
      '/assets/home-banners/home-05-chess.webp',
      '/assets/home-banners/home-06-siemens.webp',
      '/assets/home-banners/home-07-engmedicine.webp',
    ]);
  });

  it('inserts supplemental APSCVIR banners after the first configured banner and preserves the rest', async () => {
    const configDir = join(tmpRoot, 'uploads', 'config');
    mkdirSync(configDir, { recursive: true });
    writeFileSync(
      join(configDir, 'home-banners.json'),
      JSON.stringify([
        {
          id: 'configured-first',
          title: '',
          subtitle: '',
          imageUrl: '/uploads/configured-first.jpg',
          linkUrl: '',
          sortOrder: 10,
          isActive: true,
          createdAt: '2026-06-10T00:00:00.000Z',
          updatedAt: '2026-06-10T00:00:00.000Z',
        },
        {
          id: 'configured-second',
          title: '',
          subtitle: '',
          imageUrl: '/uploads/configured-second.jpg',
          linkUrl: '',
          sortOrder: 20,
          isActive: true,
          createdAt: '2026-06-10T00:00:00.000Z',
          updatedAt: '2026-06-10T00:00:00.000Z',
        },
        {
          id: 'configured-third',
          title: '',
          subtitle: '',
          imageUrl: '/uploads/configured-third.jpg',
          linkUrl: '',
          sortOrder: 30,
          isActive: true,
          createdAt: '2026-06-10T00:00:00.000Z',
          updatedAt: '2026-06-10T00:00:00.000Z',
        },
      ]),
    );
    const service = new HomeBannersService();

    const banners = await service.findPublic();

    expect(banners.map((banner) => banner.imageUrl)).toEqual([
      '/uploads/configured-first.jpg',
      '/assets/home-banners/home-02-opening-ceremony.webp',
      '/assets/home-banners/home-03-morning-run.webp',
      '/assets/home-banners/home-04-dinner.webp',
      '/assets/home-banners/home-05-chess.webp',
      '/assets/home-banners/home-06-siemens.webp',
      '/assets/home-banners/home-07-engmedicine.webp',
      '/uploads/configured-second.jpg',
      '/uploads/configured-third.jpg',
    ]);
  });
});
