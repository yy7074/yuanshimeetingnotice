import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { ImportController } from './import.controller';
import { CommonModule } from '../common/common.module';
import { Notification } from '../notifications/entities/notification.entity';
import { CheckIn } from '../check-in/entities/check-in.entity';
import { Material } from '../materials/entities/material.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, Notification, CheckIn, Material]),
    CommonModule,
  ],
  controllers: [UsersController, ImportController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
