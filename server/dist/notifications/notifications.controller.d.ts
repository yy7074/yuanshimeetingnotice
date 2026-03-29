import { Repository } from 'typeorm';
import { NotificationsService } from './notifications.service';
import { NotificationDispatcherService } from './notification-dispatcher.service';
import { User } from '../users/entities/user.entity';
export declare class NotificationsController {
    private notifService;
    private dispatcher;
    private userRepo;
    constructor(notifService: NotificationsService, dispatcher: NotificationDispatcherService, userRepo: Repository<User>);
    findMy(req: any): Promise<import("./entities/notification.entity").Notification[]>;
    getUnreadCount(req: any): Promise<{
        unreadCount: number;
    }>;
    markAsRead(id: string, req: any): Promise<{
        message: string;
    }>;
    markAllAsRead(req: any): Promise<{
        message: string;
    }>;
    registerFcmToken(req: any, token: string): Promise<{
        message: string;
    }>;
    updatePushSettings(req: any, enabled: boolean): Promise<{
        message: string;
    }>;
    send(body: {
        userId: string;
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type?: string;
        eventId?: string;
        sendPush?: boolean;
        sendEmail?: boolean;
    }): Promise<import("./entities/notification.entity").Notification>;
    broadcast(body: {
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type?: string;
        eventId?: string;
        sendPush?: boolean;
        sendEmail?: boolean;
    }): Promise<{
        sent: number;
    }>;
}
