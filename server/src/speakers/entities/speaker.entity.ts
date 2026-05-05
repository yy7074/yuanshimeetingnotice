import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

export enum SpeakerCategory {
  KEYNOTE = 'keynote',
  VIP_GUEST = 'vip_guest',
  RESEARCH = 'research',
  WORKSHOP = 'workshop',
}

@Entity('speakers')
export class Speaker {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'name_en' })
  nameEn: string;

  @Column({ name: 'name_zh' })
  nameZh: string;

  @Column({ name: 'title_en', default: '' })
  titleEn: string;

  @Column({ name: 'title_zh', default: '' })
  titleZh: string;

  @Column({ name: 'organization_en', default: '' })
  organizationEn: string;

  @Column({ name: 'organization_zh', default: '' })
  organizationZh: string;

  @Column({ name: 'bio_en', type: 'text', default: '' })
  bioEn: string;

  @Column({ name: 'bio_zh', type: 'text', default: '' })
  bioZh: string;

  @Column({ name: 'avatar_url', default: '' })
  avatarUrl: string;

  @Column({ type: 'varchar', default: SpeakerCategory.KEYNOTE })
  category: SpeakerCategory;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
