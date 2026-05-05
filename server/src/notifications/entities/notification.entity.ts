import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum NotificationType {
  SCHEDULE_REMINDER = 'schedule_reminder',
  EVENT_UPDATE = 'event_update',
  MATERIAL_UPDATE = 'material_update',
  CHECK_IN_SUCCESS = 'check_in_success',
  SYSTEM = 'system',
}

@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'title_en' })
  titleEn: string;

  @Column({ name: 'title_zh' })
  titleZh: string;

  @Column({ name: 'body_en', type: 'text' })
  bodyEn: string;

  @Column({ name: 'body_zh', type: 'text' })
  bodyZh: string;

  @Column({ type: 'varchar', default: NotificationType.SYSTEM })
  type: NotificationType;

  @Column({ name: 'is_read', default: false })
  isRead: boolean;

  @Column({ name: 'target_url', nullable: true })
  targetUrl: string;

  @Column({ name: 'event_id', nullable: true })
  eventId: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ name: 'user_id' })
  userId: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}
