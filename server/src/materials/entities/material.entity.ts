import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Event } from '../../events/entities/event.entity';
import { UserRole } from '../../users/entities/user.entity';

export enum MaterialType {
  PDF = 'pdf',
  PPT = 'ppt',
  IMAGE = 'image',
  OTHER = 'other',
}

@Entity('materials')
export class Material {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'name_en' })
  nameEn: string;

  @Column({ name: 'name_zh' })
  nameZh: string;

  @Column({ name: 'file_url' })
  fileUrl: string;

  @Column({ name: 'file_size', default: 0 })
  fileSize: number;

  @Column({ type: 'varchar', default: MaterialType.PDF })
  type: MaterialType;

  @Column({
    name: 'visible_to',
    type: 'simple-array',
    default: 'attendee,speaker,vip,admin',
  })
  visibleTo: string[];

  @Column({ name: 'download_count', default: 0 })
  downloadCount: number;

  @ManyToOne(() => Event, (event) => event.materials, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'event_id' })
  event: Event;

  @Column({ name: 'event_id' })
  eventId: string;

  @Column({ name: 'session_id', nullable: true })
  sessionId: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
