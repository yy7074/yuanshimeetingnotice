#!/usr/bin/env node

const path = require('path');
const Database = require('better-sqlite3');

const {
  apscvir2026Event,
  apscvir2026Materials,
  apscvir2026Sessions,
  apscvir2026Speakers,
} = require('../dist/database/apscvir2026-content');

const dbPath =
  process.argv[2] ||
  process.env.DB_DATABASE ||
  path.resolve(__dirname, '../conference.db');

const db = new Database(dbPath);

const now = () => new Date().toISOString();

function hasColumn(table, column) {
  return db
    .prepare(`PRAGMA table_info(${table})`)
    .all()
    .some((row) => row.name === column);
}

if (!hasColumn('sessions', 'view_count')) {
  db.prepare(
    'ALTER TABLE sessions ADD COLUMN view_count INTEGER NOT NULL DEFAULT 0',
  ).run();
}

if (!hasColumn('materials', 'visible_user_ids')) {
  db.prepare('ALTER TABLE materials ADD COLUMN visible_user_ids TEXT').run();
}

const reset = db.transaction(() => {
  db.pragma('foreign_keys = ON');

  db.prepare('DELETE FROM notifications WHERE event_id IS NOT NULL').run();
  db.prepare(
    "DELETE FROM notifications WHERE title_en LIKE '%Global Oncology%' OR body_en LIKE '%Global Oncology%' OR title_en LIKE '%Digital Healthcare%' OR body_en LIKE '%Digital Healthcare%' OR title_en LIKE '%Cardiovascular Expo%' OR body_en LIKE '%Cardiovascular Expo%'",
  ).run();
  db.prepare('DELETE FROM check_ins').run();
  db.prepare('DELETE FROM user_subscriptions').run();
  db.prepare('DELETE FROM materials').run();
  db.prepare('DELETE FROM sessions').run();
  db.prepare('DELETE FROM events').run();
  db.prepare('DELETE FROM speakers').run();

  const insertSpeaker = db.prepare(`
    INSERT INTO speakers (
      id, name_en, name_zh, title_en, title_zh, organization_en,
      organization_zh, bio_en, bio_zh, avatar_url, category, created_at, updated_at
    ) VALUES (
      @id, @nameEn, @nameZh, @titleEn, @titleZh, @organizationEn,
      @organizationZh, @bioEn, @bioZh, @avatarUrl, @category, @createdAt, @updatedAt
    )
  `);

  for (const speaker of apscvir2026Speakers) {
    insertSpeaker.run({
      ...speaker,
      avatarUrl: speaker.avatarUrl || '',
      createdAt: now(),
      updatedAt: now(),
    });
  }

  db.prepare(
    `
    INSERT INTO events (
      id, title_en, title_zh, description_en, description_zh, location_en,
      location_zh, image_url, banner_url, start_date, end_date, organizer_en,
      organizer_zh, tags, is_featured, max_attendees, status, created_at, updated_at
    ) VALUES (
      @id, @titleEn, @titleZh, @descriptionEn, @descriptionZh, @locationEn,
      @locationZh, @imageUrl, @bannerUrl, @startDate, @endDate, @organizerEn,
      @organizerZh, @tags, @isFeatured, @maxAttendees, @status, @createdAt, @updatedAt
    )
  `,
  ).run({
    ...apscvir2026Event,
    tags: apscvir2026Event.tags.join(','),
    isFeatured: apscvir2026Event.isFeatured ? 1 : 0,
    createdAt: now(),
    updatedAt: now(),
  });

  const insertSession = db.prepare(`
    INSERT INTO sessions (
      id, title_en, title_zh, description_en, description_zh, room_en, room_zh,
      start_time, end_time, type, day_index, sort_order, view_count, event_id,
      speaker_id, speaker_name, speaker_title_en, speaker_title_zh,
      speaker_avatar_url, created_at, updated_at
    ) VALUES (
      @id, @titleEn, @titleZh, @descriptionEn, @descriptionZh, @roomEn, @roomZh,
      @startTime, @endTime, @type, @dayIndex, @sortOrder, 0, @eventId,
      @speakerId, @speakerName, @speakerTitleEn, @speakerTitleZh,
      @speakerAvatarUrl, @createdAt, @updatedAt
    )
  `);

  for (const session of apscvir2026Sessions) {
    insertSession.run({
      ...session,
      eventId: apscvir2026Event.id,
      speakerId: session.speakerId || null,
      speakerName: session.speakerName || '',
      speakerTitleEn: session.speakerTitleEn || '',
      speakerTitleZh: session.speakerTitleZh || '',
      speakerAvatarUrl: '',
      createdAt: now(),
      updatedAt: now(),
    });
  }

  const insertMaterial = db.prepare(`
    INSERT INTO materials (
      id, name_en, name_zh, file_url, file_size, type, visible_to,
      download_count, event_id, session_id, visible_user_ids, created_at, updated_at
    ) VALUES (
      @id, @nameEn, @nameZh, @fileUrl, @fileSize, @type, 'attendee,speaker,vip,admin',
      0, @eventId, NULL, NULL, @createdAt, @updatedAt
    )
  `);

  for (const material of apscvir2026Materials) {
    insertMaterial.run({
      ...material,
      eventId: apscvir2026Event.id,
      createdAt: now(),
      updatedAt: now(),
    });
  }

  db.prepare(
    `
    UPDATE users
    SET name_en = 'APSCVIR Delegate',
        name_zh = 'APSCVIR 参会代表',
        title_en = 'Conference Attendee',
        title_zh = '大会参会者',
        organization_en = 'APSCVIR 2026',
        organization_zh = 'APSCVIR 2026',
        avatar_url = '',
        language = 'en',
        updated_at = ?
    WHERE email = 'demo@apscvir.org'
  `,
  ).run(now());
});

reset();

const counts = {
  events: db.prepare('SELECT COUNT(*) AS count FROM events').get().count,
  speakers: db.prepare('SELECT COUNT(*) AS count FROM speakers').get().count,
  sessions: db.prepare('SELECT COUNT(*) AS count FROM sessions').get().count,
  materials: db.prepare('SELECT COUNT(*) AS count FROM materials').get().count,
};

console.log(`Reset APSCVIR 2026 content in ${dbPath}`);
console.log(JSON.stringify(counts));
