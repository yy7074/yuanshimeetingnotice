import { DataSource } from 'typeorm';
import * as bcryptjs from 'bcryptjs';
import { User, UserRole } from '../users/entities/user.entity';
import { Event, EventStatus } from '../events/entities/event.entity';
import { Session, SessionType } from '../sessions/entities/session.entity';
import { Speaker, SpeakerCategory } from '../speakers/entities/speaker.entity';
import { Material, MaterialType } from '../materials/entities/material.entity';
import {
  apscvir2026Event,
  apscvir2026Materials,
  apscvir2026Sessions,
  apscvir2026Speakers,
} from './apscvir2026-content';

export async function seedDatabase(dataSource: DataSource) {
  const userRepo = dataSource.getRepository(User);
  const eventRepo = dataSource.getRepository(Event);
  const sessionRepo = dataSource.getRepository(Session);
  const speakerRepo = dataSource.getRepository(Speaker);
  const materialRepo = dataSource.getRepository(Material);

  const existingUsers = await userRepo.count();
  if (existingUsers > 0) {
    console.log('Database already seeded, skipping...');
    return;
  }

  console.log('Seeding database...');

  const admin = userRepo.create({
    email: 'admin@apscvir.org',
    password: await bcryptjs.hash('admin123', 10),
    nameEn: 'System Admin',
    nameZh: '系统管理员',
    titleEn: 'Platform Administrator',
    titleZh: '平台管理员',
    organizationEn: 'APSCVIR',
    organizationZh: 'APSCVIR',
    role: UserRole.ADMIN,
    language: 'en',
  });
  await userRepo.save(admin);

  const demoUser = userRepo.create({
    email: 'demo@apscvir.org',
    password: await bcryptjs.hash('demo1234', 10),
    nameEn: 'APSCVIR Delegate',
    nameZh: 'APSCVIR 参会代表',
    titleEn: 'Conference Attendee',
    titleZh: '大会参会者',
    organizationEn: 'APSCVIR 2026',
    organizationZh: 'APSCVIR 2026',
    avatarUrl: '',
    role: UserRole.VIP,
    language: 'en',
  });
  await userRepo.save(demoUser);

  const speakers = await speakerRepo.save(
    apscvir2026Speakers.map((speaker) =>
      speakerRepo.create({
        ...speaker,
        avatarUrl: speaker.avatarUrl || '',
        category: speaker.category as SpeakerCategory,
      }),
    ),
  );
  const speakerById = new Map(speakers.map((speaker) => [speaker.id, speaker]));

  const event = await eventRepo.save(
    eventRepo.create({
      ...apscvir2026Event,
      startDate: new Date(apscvir2026Event.startDate),
      endDate: new Date(apscvir2026Event.endDate),
      status: apscvir2026Event.status as EventStatus,
    }),
  );

  await sessionRepo.save(
    apscvir2026Sessions.map((session) => {
      const speaker = session.speakerId
        ? speakerById.get(session.speakerId)
        : undefined;
      return sessionRepo.create({
        ...session,
        eventId: event.id,
        startTime: new Date(session.startTime),
        endTime: new Date(session.endTime),
        type: session.type as SessionType,
        speakerId: speaker?.id,
        speakerName: session.speakerName || speaker?.nameEn || '',
        speakerTitleEn: session.speakerTitleEn || speaker?.titleEn || '',
        speakerTitleZh: session.speakerTitleZh || speaker?.titleZh || '',
        speakerAvatarUrl: '',
      });
    }),
  );

  await materialRepo.save(
    apscvir2026Materials.map((material) =>
      materialRepo.create({
        ...material,
        type: material.type as MaterialType,
        eventId: event.id,
      }),
    ),
  );

  console.log('Database seeded successfully!');
  console.log('Admin: admin@apscvir.org / admin123');
  console.log('Demo:  demo@apscvir.org / demo1234');
}
