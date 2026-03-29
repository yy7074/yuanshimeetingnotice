"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.seedDatabase = seedDatabase;
const bcryptjs = __importStar(require("bcryptjs"));
const user_entity_1 = require("../users/entities/user.entity");
const event_entity_1 = require("../events/entities/event.entity");
const session_entity_1 = require("../sessions/entities/session.entity");
const speaker_entity_1 = require("../speakers/entities/speaker.entity");
const material_entity_1 = require("../materials/entities/material.entity");
async function seedDatabase(dataSource) {
    const userRepo = dataSource.getRepository(user_entity_1.User);
    const eventRepo = dataSource.getRepository(event_entity_1.Event);
    const sessionRepo = dataSource.getRepository(session_entity_1.Session);
    const speakerRepo = dataSource.getRepository(speaker_entity_1.Speaker);
    const materialRepo = dataSource.getRepository(material_entity_1.Material);
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
        role: user_entity_1.UserRole.ADMIN,
    });
    await userRepo.save(admin);
    const demoUser = userRepo.create({
        email: 'demo@apscvir.org',
        password: await bcryptjs.hash('demo1234', 10),
        nameEn: 'Dr. Alistair Thorne',
        nameZh: '艾利斯泰尔·索恩博士',
        titleEn: 'Senior Oncology Curator',
        titleZh: '高级肿瘤学研究员',
        organizationEn: "ST. JUDE'S MEDICAL RESEARCH CENTER",
        organizationZh: '圣裘德医学研究中心',
        avatarUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop',
        role: user_entity_1.UserRole.VIP,
    });
    await userRepo.save(demoUser);
    const speakers = await speakerRepo.save([
        speakerRepo.create({
            nameEn: 'Dr. Sarah Chen, PhD', nameZh: 'Sarah Chen 博士',
            titleEn: 'Director of Bio-Informatics', titleZh: '生物信息学主任',
            organizationEn: 'Stanford Medicine', organizationZh: '斯坦福医学院',
            bioEn: 'Pioneer in computational genomics with 20+ years of research experience.',
            bioZh: '计算基因组学先驱，拥有20余年研究经验。',
            avatarUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop',
            category: speaker_entity_1.SpeakerCategory.KEYNOTE,
        }),
        speakerRepo.create({
            nameEn: 'Prof. James Sterling', nameZh: 'James Sterling 教授',
            titleEn: 'Oncology Lead', titleZh: '肿瘤学负责人',
            organizationEn: 'Mayo Clinic', organizationZh: '梅奥诊所',
            bioEn: 'Renowned oncologist specializing in CAR-T cell therapy.',
            bioZh: 'CAR-T细胞疗法领域的知名肿瘤学家。',
            avatarUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=200&auto=format&fit=crop',
            category: speaker_entity_1.SpeakerCategory.RESEARCH,
        }),
        speakerRepo.create({
            nameEn: 'Dr. Elena Rodriguez', nameZh: 'Elena Rodriguez 博士',
            titleEn: 'Senior Pharmacologist', titleZh: '高级药理学家',
            organizationEn: 'Novartis', organizationZh: '诺华制药',
            bioEn: 'Expert in precision medicine and drug dosage optimization.',
            bioZh: '精准医学与药物剂量优化专家。',
            avatarUrl: 'https://images.unsplash.com/photo-1594824461559-67d483b3e32e?q=80&w=200&auto=format&fit=crop',
            category: speaker_entity_1.SpeakerCategory.WORKSHOP,
        }),
        speakerRepo.create({
            nameEn: 'Dr. Alistair Thorne', nameZh: 'Alistair Thorne 博士',
            titleEn: 'Senior Oncology Curator', titleZh: '资深肿瘤学研究员',
            organizationEn: "St. Jude's Medical Research Center", organizationZh: '圣裘德医学研究中心',
            bioEn: 'Leading expert in targeted cancer therapies.',
            bioZh: '靶向癌症疗法领先专家。',
            avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200&auto=format&fit=crop',
            category: speaker_entity_1.SpeakerCategory.VIP_GUEST,
        }),
    ]);
    const event1 = eventRepo.create({
        titleEn: 'Global Oncology Summit 2026', titleZh: '2026 全球肿瘤学创新峰会',
        descriptionEn: 'The premier global conference on oncology innovations.',
        descriptionZh: '全球顶级肿瘤学创新学术会议。',
        locationEn: 'Convention Center, San Francisco, CA', locationZh: '旧金山国际会议中心, CA',
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop',
        startDate: new Date('2026-10-15'), endDate: new Date('2026-10-17'),
        organizerEn: 'APSCVIR', organizerZh: 'APSCVIR',
        tags: ['Oncology', 'Innovation'], maxAttendees: 500,
        status: event_entity_1.EventStatus.PUBLISHED,
    });
    await eventRepo.save(event1);
    const event2 = eventRepo.create({
        titleEn: 'Future of Digital Healthcare & AI Forum', titleZh: '未来数字医疗与AI论坛',
        descriptionEn: 'Exploring the intersection of AI and clinical practice.',
        descriptionZh: '探讨AI与临床实践的交叉前沿。',
        locationEn: 'Grand Hyatt, Shanghai, CN', locationZh: '上海君悦大酒店, CN',
        imageUrl: 'https://images.unsplash.com/photo-1591115765373-5207764f72e7?q=80&w=2070&auto=format&fit=crop',
        startDate: new Date('2026-11-02'), endDate: new Date('2026-11-04'),
        organizerEn: 'APSCVIR & Digital Health Alliance', organizerZh: 'APSCVIR & 数字健康联盟',
        tags: ['Digital Health', 'AI'], isFeatured: true, maxAttendees: 300,
        status: event_entity_1.EventStatus.PUBLISHED,
    });
    await eventRepo.save(event2);
    const event3 = eventRepo.create({
        titleEn: 'International Cardiovascular Expo', titleZh: '国际心血管医学博览会',
        descriptionEn: 'Annual cardiovascular research and technology expo.',
        descriptionZh: '年度心血管研究与技术展览。',
        locationEn: 'Exhibition Hall, Berlin, DE', locationZh: '柏林展览中心, DE',
        imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=2069&auto=format&fit=crop',
        startDate: new Date('2026-12-12'), endDate: new Date('2026-12-12'),
        organizerEn: 'European Cardiovascular Society', organizerZh: '欧洲心血管学会',
        tags: ['Cardiovascular', 'Technology'], maxAttendees: 100,
        status: event_entity_1.EventStatus.PUBLISHED,
    });
    await eventRepo.save(event3);
    const sessionsData = [
        { titleEn: 'Future of AI in Genomic Research', titleZh: '人工智能在基因组研究中的未来展望', roomEn: 'Lecture Hall 1', roomZh: '第一学术报告厅', startTime: new Date('2026-10-15T09:00'), endTime: new Date('2026-10-15T10:00'), type: session_entity_1.SessionType.KEYNOTE, dayIndex: 0, speaker: speakers[0] },
        { titleEn: 'Breakthroughs in CAR-T Cell Therapy', titleZh: 'CAR-T细胞疗法的重大突破', roomEn: 'Seminar Hall 2', roomZh: '研讨会第二厅', startTime: new Date('2026-10-15T10:15'), endTime: new Date('2026-10-15T11:15'), type: session_entity_1.SessionType.RESEARCH_PAPER, dayIndex: 0, speaker: speakers[1] },
        { titleEn: 'Precision Medicine: From Data to Dosage', titleZh: '精准医学：从数据到剂量', roomEn: 'Innovation Lab 4', roomZh: '创新实验室 4', startTime: new Date('2026-10-15T13:00'), endTime: new Date('2026-10-15T14:30'), type: session_entity_1.SessionType.WORKSHOP, dayIndex: 0, speaker: speakers[2] },
        { titleEn: 'Ethical Frameworks for Global Health Data', titleZh: '全球健康数据的伦理框架', roomEn: 'Digital Suite A', roomZh: '数字套房 A', startTime: new Date('2026-10-15T15:00'), endTime: new Date('2026-10-15T16:30'), type: session_entity_1.SessionType.PANEL, dayIndex: 0, speakerName: 'Panel: WHO Ethics Committee', speakerTitleEn: 'Multi-speaker Session', speakerTitleZh: '多讲者联合论坛' },
        { titleEn: 'Precision Medicine & AI Diagnostics', titleZh: '精准医疗与AI诊断', roomEn: 'Lecture Hall 1', roomZh: '第一学术报告厅', startTime: new Date('2026-10-16T09:00'), endTime: new Date('2026-10-16T10:30'), type: session_entity_1.SessionType.KEYNOTE, dayIndex: 1, speaker: speakers[3] },
        { titleEn: 'Targeted Immunotherapy Workshop', titleZh: '新型靶向免疫疗法临床研讨', roomEn: 'Lab Center', roomZh: '实验教学中心', startTime: new Date('2026-10-16T11:00'), endTime: new Date('2026-10-16T12:30'), type: session_entity_1.SessionType.WORKSHOP, dayIndex: 1, speaker: speakers[2] },
        { titleEn: 'Genomic Data in Rare Diseases', titleZh: '基因组学数据在罕见病中的应用', roomEn: 'Medical Data Lab', roomZh: '医学数据实验室', startTime: new Date('2026-10-16T14:15'), endTime: new Date('2026-10-16T15:45'), type: session_entity_1.SessionType.RESEARCH_PAPER, dayIndex: 1, speaker: speakers[1] },
        { titleEn: 'Next-Generation Sequencing in Oncology', titleZh: '新一代基因组测序在肿瘤学中的应用', roomEn: 'Lecture Hall 1', roomZh: '第一学术报告厅', startTime: new Date('2026-10-17T09:00'), endTime: new Date('2026-10-17T10:30'), type: session_entity_1.SessionType.KEYNOTE, dayIndex: 2, speaker: speakers[0] },
        { titleEn: 'Closing Ceremony & Awards', titleZh: '闭幕式及颁奖典礼', roomEn: 'Grand Ballroom', roomZh: '宴会大厅', startTime: new Date('2026-10-17T15:00'), endTime: new Date('2026-10-17T17:00'), type: session_entity_1.SessionType.PANEL, dayIndex: 2, speakerName: 'Organizing Committee' },
    ];
    for (const sd of sessionsData) {
        const session = sessionRepo.create({
            titleEn: sd.titleEn, titleZh: sd.titleZh,
            roomEn: sd.roomEn, roomZh: sd.roomZh,
            startTime: sd.startTime, endTime: sd.endTime,
            type: sd.type, dayIndex: sd.dayIndex,
            eventId: event1.id,
            speakerId: sd.speaker?.id,
            speakerName: sd.speaker ? sd.speaker.nameEn : (sd.speakerName || ''),
            speakerTitleEn: sd.speaker ? sd.speaker.titleEn : (sd.speakerTitleEn || ''),
            speakerTitleZh: sd.speaker ? sd.speaker.titleZh : (sd.speakerTitleZh || ''),
            speakerAvatarUrl: sd.speaker ? sd.speaker.avatarUrl : '',
        });
        await sessionRepo.save(session);
    }
    await materialRepo.save([
        materialRepo.create({ nameEn: 'Conference Program Guide', nameZh: '大会议程指南', fileUrl: '/files/program-guide.pdf', fileSize: 2400000, type: material_entity_1.MaterialType.PDF, eventId: event1.id }),
        materialRepo.create({ nameEn: 'Speaker Abstracts Collection', nameZh: '嘉宾摘要合集', fileUrl: '/files/abstracts.pdf', fileSize: 5100000, type: material_entity_1.MaterialType.PDF, eventId: event1.id }),
        materialRepo.create({ nameEn: 'Workshop Preparation Materials', nameZh: '研讨会准备材料', fileUrl: '/files/workshop.pptx', fileSize: 12800000, type: material_entity_1.MaterialType.PPT, eventId: event1.id }),
        materialRepo.create({ nameEn: 'Venue Map & Floor Plan', nameZh: '场馆地图与平面图', fileUrl: '/files/venue-map.pdf', fileSize: 1200000, type: material_entity_1.MaterialType.PDF, eventId: event1.id }),
    ]);
    console.log('Database seeded successfully!');
    console.log('Admin: admin@apscvir.org / admin123');
    console.log('Demo:  demo@apscvir.org / demo1234');
}
//# sourceMappingURL=seed.js.map