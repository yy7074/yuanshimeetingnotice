import { User } from '../../users/entities/user.entity';
export declare enum NotificationType {
    SCHEDULE_REMINDER = "schedule_reminder",
    EVENT_UPDATE = "event_update",
    MATERIAL_UPDATE = "material_update",
    CHECK_IN_SUCCESS = "check_in_success",
    SYSTEM = "system"
}
export declare class Notification {
    id: string;
    titleEn: string;
    titleZh: string;
    bodyEn: string;
    bodyZh: string;
    type: NotificationType;
    isRead: boolean;
    targetUrl: string;
    eventId: string;
    user: User;
    userId: string;
    createdAt: Date;
}
