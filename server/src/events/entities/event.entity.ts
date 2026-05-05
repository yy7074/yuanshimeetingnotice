import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  ManyToMany,
} from 'typeorm';
import { Session } from '../../sessions/entities/session.entity';
import { Material } from '../../materials/entities/material.entity';
import { User } from '../../users/entities/user.entity';

export enum EventStatus {
  DRAFT = 'draft',
  PUBLISHED = 'published',
  ENDED = 'ended',
}

@Entity('events')
export class Event {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'title_en' })
  titleEn: string;

  @Column({ name: 'title_zh' })
  titleZh: string;

  @Column({ name: 'description_en', type: 'text', default: '' })
  descriptionEn: string;

  @Column({ name: 'description_zh', type: 'text', default: '' })
  descriptionZh: string;

  @Column({ name: 'location_en', default: '' })
  locationEn: string;

  @Column({ name: 'location_zh', default: '' })
  locationZh: string;

  @Column({ name: 'image_url', default: '' })
  imageUrl: string;

  @Column({ name: 'banner_url', default: '' })
  bannerUrl: string;

  @Column({ name: 'start_date', type: 'datetime' })
  startDate: Date;

  @Column({ name: 'end_date', type: 'datetime' })
  endDate: Date;

  @Column({ name: 'organizer_en', default: '' })
  organizerEn: string;

  @Column({ name: 'organizer_zh', default: '' })
  organizerZh: string;

  @Column('simple-array', { nullable: true })
  tags: string[];

  @Column({ name: 'is_featured', default: false })
  isFeatured: boolean;

  @Column({ name: 'max_attendees', default: 0 })
  maxAttendees: number;

  @Column({ type: 'varchar', default: EventStatus.DRAFT })
  status: EventStatus;

  @OneToMany(() => Session, (session) => session.event, { cascade: true })
  sessions: Session[];

  @OneToMany(() => Material, (material) => material.event, { cascade: true })
  materials: Material[];

  @ManyToMany(() => User, (user) => user.subscribedEvents)
  subscribers: User[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
