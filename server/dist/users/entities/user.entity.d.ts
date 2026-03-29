import { Event } from '../../events/entities/event.entity';
export declare enum UserRole {
    ATTENDEE = "attendee",
    SPEAKER = "speaker",
    VIP = "vip",
    ADMIN = "admin"
}
export declare class User {
    id: string;
    email: string;
    password: string;
    nameEn: string;
    nameZh: string;
    titleEn: string;
    titleZh: string;
    organizationEn: string;
    organizationZh: string;
    avatarUrl: string;
    role: UserRole;
    isActive: boolean;
    pushEnabled: boolean;
    language: string;
    fcmToken: string;
    subscribedEvents: Event[];
    createdAt: Date;
    updatedAt: Date;
}
