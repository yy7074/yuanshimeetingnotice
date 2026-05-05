import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToMany,
  JoinTable,
  OneToMany,
} from 'typeorm';
import { Event } from '../../events/entities/event.entity';
import { Exclude } from 'class-transformer';

export enum UserRole {
  ATTENDEE = 'attendee',
  SPEAKER = 'speaker',
  VIP = 'vip',
  ADMIN = 'admin',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  @Exclude()
  password: string;

  @Column({ name: 'name_en', default: '' })
  nameEn: string;

  @Column({ name: 'name_zh', default: '' })
  nameZh: string;

  @Column({ name: 'title_en', default: '' })
  titleEn: string;

  @Column({ name: 'title_zh', default: '' })
  titleZh: string;

  @Column({ name: 'organization_en', default: '' })
  organizationEn: string;

  @Column({ name: 'organization_zh', default: '' })
  organizationZh: string;

  @Column({ name: 'avatar_url', default: '' })
  avatarUrl: string;

  @Column({ type: 'varchar', default: UserRole.ATTENDEE })
  role: UserRole;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @Column({ name: 'push_enabled', default: true })
  pushEnabled: boolean;

  @Column({ name: 'language', default: 'zh' })
  language: string;

  @Column({ name: 'fcm_token', nullable: true })
  fcmToken: string;

  @Column({ name: 'token_version', default: 0 })
  tokenVersion: number;

  @Column({ name: 'must_change_password', default: false })
  mustChangePassword: boolean;

  @ManyToMany(() => Event, (event) => event.subscribers)
  @JoinTable({ name: 'user_subscriptions' })
  subscribedEvents: Event[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
