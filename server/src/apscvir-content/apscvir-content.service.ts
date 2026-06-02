import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
  OnModuleInit,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Cron } from '@nestjs/schedule';
import { execFile } from 'child_process';
import { existsSync, mkdirSync } from 'fs';
import { readFile, writeFile } from 'fs/promises';
import { basename, resolve, sep } from 'path';
import { promisify } from 'util';

const execFileAsync = promisify(execFile);
const assetPrefix = 'assets/apscvir2026/';

type SyncStatus = {
  state: 'idle' | 'running' | 'success' | 'failed';
  reason: string;
  startedAt?: string;
  finishedAt?: string;
  error?: string;
};

@Injectable()
export class ApscvirContentService implements OnModuleInit {
  private readonly logger = new Logger(ApscvirContentService.name);
  private readonly contentRoot: string;
  private readonly manifestPath: string;
  private readonly statusPath: string;
  private syncPromise?: Promise<SyncStatus>;

  constructor(private readonly config: ConfigService) {
    this.contentRoot = resolve(
      this.config.get<string>('APSCVIR_CONTENT_DIR') ||
        resolve(process.cwd(), 'uploads', 'apscvir2026'),
    );
    this.manifestPath = resolve(
      this.contentRoot,
      'data',
      'site_manifest.json',
    );
    this.statusPath = resolve(this.contentRoot, 'data', 'sync_status.json');
  }

  onModuleInit() {
    if (!existsSync(this.manifestPath)) {
      this.logger.warn(
        'APSCVIR content manifest is missing; starting background sync.',
      );
      this.sync('startup').catch((error) =>
        this.logger.warn(`Startup APSCVIR sync failed: ${error.message}`),
      );
    }
  }

  @Cron('17 */6 * * *')
  handleScheduledSync() {
    this.sync('scheduled').catch((error) =>
      this.logger.warn(`Scheduled APSCVIR sync failed: ${error.message}`),
    );
  }

  async getManifest() {
    if (!existsSync(this.manifestPath)) {
      throw new NotFoundException(
        'APSCVIR content is not available yet. Sync is running or has not completed.',
      );
    }
    const raw = await readFile(this.manifestPath, 'utf8');
    return JSON.parse(raw);
  }

  async getStatus(): Promise<SyncStatus> {
    if (this.syncPromise) {
      return {
        state: 'running',
        reason: 'current',
        startedAt: new Date().toISOString(),
      };
    }
    if (!existsSync(this.statusPath)) {
      return { state: 'idle', reason: 'none' };
    }
    try {
      return JSON.parse(await readFile(this.statusPath, 'utf8'));
    } catch {
      return { state: 'idle', reason: 'invalid-status-file' };
    }
  }

  async sync(reason = 'manual'): Promise<SyncStatus> {
    if (this.syncPromise) return this.syncPromise;
    this.syncPromise = this.runSync(reason).finally(() => {
      this.syncPromise = undefined;
    });
    return this.syncPromise;
  }

  async resolveAssetFile(assetPath: string) {
    const normalized = this.normalizeAssetPath(assetPath);
    const relative = normalized.substring(assetPrefix.length);
    const absPath = resolve(this.contentRoot, relative);
    if (!this.isInsideContentRoot(absPath)) {
      throw new BadRequestException('Invalid APSCVIR content path');
    }
    if (!existsSync(absPath)) {
      throw new NotFoundException('APSCVIR content file not found');
    }
    return {
      absPath,
      filename: basename(absPath),
    };
  }

  private async runSync(reason: string): Promise<SyncStatus> {
    const startedAt = new Date().toISOString();
    const running: SyncStatus = { state: 'running', reason, startedAt };
    await this.writeStatus(running);

    const scriptPath = resolve(process.cwd(), 'scripts', 'crawl_apscvir.py');
    mkdirSync(this.contentRoot, { recursive: true });

    try {
      const { stdout, stderr } = await execFileAsync('python3', [scriptPath], {
        cwd: process.cwd(),
        env: {
          ...process.env,
          APSCVIR_OUT_ROOT: this.contentRoot,
        },
        maxBuffer: 10 * 1024 * 1024,
        timeout: 180_000,
      });
      if (stdout.trim()) {
        this.logger.log(stdout.trim());
      }
      if (stderr.trim()) {
        this.logger.warn(stderr.trim());
      }
      const status: SyncStatus = {
        state: 'success',
        reason,
        startedAt,
        finishedAt: new Date().toISOString(),
      };
      await this.writeStatus(status);
      return status;
    } catch (error) {
      const message =
        error instanceof Error ? error.message : 'Unknown APSCVIR sync error';
      const status: SyncStatus = {
        state: 'failed',
        reason,
        startedAt,
        finishedAt: new Date().toISOString(),
        error: message,
      };
      await this.writeStatus(status);
      throw error;
    }
  }

  private normalizeAssetPath(assetPath: string) {
    const normalized = assetPath.replace(/\\/g, '/').replace(/^\/+/, '').trim();
    if (
      !normalized.startsWith(assetPrefix) ||
      normalized.includes('../') ||
      normalized.includes('/..')
    ) {
      throw new BadRequestException('Invalid APSCVIR content path');
    }
    return normalized;
  }

  private isInsideContentRoot(absPath: string) {
    return absPath === this.contentRoot || absPath.startsWith(this.contentRoot + sep);
  }

  private async writeStatus(status: SyncStatus) {
    const statusDir = resolve(this.contentRoot, 'data');
    mkdirSync(statusDir, { recursive: true });
    await writeFile(this.statusPath, JSON.stringify(status, null, 2));
  }
}
