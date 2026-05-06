import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Session } from './entities/session.entity';
import { SessionsService } from './sessions.service';
import { SessionsController } from './sessions.controller';
import { SessionsStatsController } from './sessions-stats.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Session])],
  controllers: [SessionsController, SessionsStatsController],
  providers: [SessionsService],
  exports: [SessionsService],
})
export class SessionsModule {}
