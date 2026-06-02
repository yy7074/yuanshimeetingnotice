import { Module, OnModuleInit } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule, TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { DataSource } from 'typeorm';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { EventsModule } from './events/events.module';
import { SessionsModule } from './sessions/sessions.module';
import { SpeakersModule } from './speakers/speakers.module';
import { MaterialsModule } from './materials/materials.module';
import { CheckInModule } from './check-in/check-in.module';
import { NotificationsModule } from './notifications/notifications.module';
import { CommonModule } from './common/common.module';
import { ApscvirContentModule } from './apscvir-content/apscvir-content.module';
import { seedDatabase } from './database/seed';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService): TypeOrmModuleOptions => {
        const dbType = config.get('DB_TYPE', 'sqlite');
        const isProduction = process.env.NODE_ENV === 'production';
        const configured = config.get('DB_SYNCHRONIZE');
        const requestedSync =
          configured === true ||
          configured === 'true' ||
          (configured === undefined && !isProduction);
        // Never auto-sync schema in production — it can silently drop columns.
        // Run explicit migrations instead.
        const synchronize = isProduction ? false : requestedSync;
        if (isProduction && requestedSync) {
          // eslint-disable-next-line no-console
          console.warn(
            '[startup] DB_SYNCHRONIZE ignored in production. Use migrations.',
          );
        }
        if (dbType === 'postgres') {
          return {
            type: 'postgres',
            host: config.get('DB_HOST', 'localhost'),
            port: config.get<number>('DB_PORT', 5432),
            username: config.get('DB_USERNAME', 'postgres'),
            password: config.get('DB_PASSWORD', 'postgres'),
            database: config.get('DB_DATABASE', 'conference_app'),
            autoLoadEntities: true,
            synchronize,
          };
        }
        return {
          type: 'better-sqlite3',
          database: config.get('DB_DATABASE', 'conference.db'),
          autoLoadEntities: true,
          synchronize,
        } as TypeOrmModuleOptions;
      },
    }),
    ScheduleModule.forRoot(),
    ThrottlerModule.forRoot([
      { name: 'short', ttl: 1000, limit: 20 },
      { name: 'medium', ttl: 60_000, limit: 120 },
      { name: 'long', ttl: 3_600_000, limit: 2000 },
    ]),
    CommonModule,
    AuthModule,
    UsersModule,
    EventsModule,
    SessionsModule,
    SpeakersModule,
    MaterialsModule,
    CheckInModule,
    NotificationsModule,
    ApscvirContentModule,
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule implements OnModuleInit {
  constructor(private dataSource: DataSource) {}

  async onModuleInit() {
    await seedDatabase(this.dataSource);
  }
}
