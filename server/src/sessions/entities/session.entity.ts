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
import { Speaker } from '../../speakers/entities/speaker.entity';

export enum SessionType {
  KEYNOTE = 'keynote',
  RESEARCH_PAPER = 'research_paper',
  WORKSHOP = 'workshop',
  PANEL = 'panel',
  BREAK = 'break',
}

@Entity('sessions')
export class Session {
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

  @Column({ name: 'room_en', default: '' })
  roomEn: string;

  @Column({ name: 'room_zh', default: '' })
  roomZh: string;

  @Column({ name: 'start_time', type: 'datetime' })
  startTime: Date;

  @Column({ name: 'end_time', type: 'datetime' })
  endTime: Date;

  @Column({ type: 'varchar', default: SessionType.KEYNOTE })
  type: SessionType;

  @Column({ name: 'day_index', default: 0 })
  dayIndex: number;

  @Column({ name: 'sort_order', default: 0 })
  sortOrder: number;

  @ManyToOne(() => Event, (event) => event.sessions, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'event_id' })
  event: Event;

  @Column({ name: 'event_id' })
  eventId: string;

  @ManyToOne(() => Speaker, { nullable: true, eager: true })
  @JoinColumn({ name: 'speaker_id' })
  speaker: Speaker;

  @Column({ name: 'speaker_id', nullable: true })
  speakerId: string;

  @Column({ name: 'speaker_name', default: '' })
  speakerName: string;

  @Column({ name: 'speaker_title_en', default: '' })
  speakerTitleEn: string;

  @Column({ name: 'speaker_title_zh', default: '' })
  speakerTitleZh: string;

  @Column({ name: 'speaker_avatar_url', default: '' })
  speakerAvatarUrl: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
