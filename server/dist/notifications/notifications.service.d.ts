import { Repository } from 'typeorm';
import { Notification, NotificationType } from './entities/notification.entity';
export declare class NotificationsService {
    private notifRepo;
    constructor(notifRepo: Repository<Notification>);
    findByUser(userId: string): Promise<Notification[]>;
    getUnreadCount(userId: string): Promise<{
        unreadCount: number;
    }>;
    markAsRead(id: string, userId: string): Promise<{
        message: string;
    }>;
    markAllAsRead(userId: string): Promise<{
        message: string;
    }>;
    send(data: {
        userId: string;
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type: NotificationType;
        eventId?: string;
        targetUrl?: string;
    }): Promise<Notification>;
    broadcast(userIds: string[], data: {
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type: NotificationType;
        eventId?: string;
    }): Promise<Notification[]>;
    sendToAll(data: {
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type: NotificationType;
        eventId?: string;
    }): Promise<Notification>;
}
