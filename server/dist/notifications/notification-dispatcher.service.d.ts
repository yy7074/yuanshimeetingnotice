import { Repository } from 'typeorm';
import { Notification, NotificationType } from './entities/notification.entity';
import { User } from '../users/entities/user.entity';
import { PushService } from '../common/push.service';
import { EmailService } from '../common/email.service';
export declare class NotificationDispatcherService {
    private notifRepo;
    private userRepo;
    private pushService;
    private emailService;
    constructor(notifRepo: Repository<Notification>, userRepo: Repository<User>, pushService: PushService, emailService: EmailService);
    dispatch(params: {
        userId: string;
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type: NotificationType;
        eventId?: string;
        sendPush?: boolean;
        sendEmail?: boolean;
    }): Promise<Notification>;
    broadcastToEvent(params: {
        eventId: string;
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type: NotificationType;
        sendPush?: boolean;
        sendEmail?: boolean;
    }): Promise<{
        sent: number;
        eventId: string;
    }>;
    broadcastToAll(params: {
        titleEn: string;
        titleZh: string;
        bodyEn: string;
        bodyZh: string;
        type: NotificationType;
        sendPush?: boolean;
        sendEmail?: boolean;
    }): Promise<{
        sent: number;
    }>;
    onEventPublished(eventId: string, eventNameEn: string, eventNameZh: string): Promise<{
        sent: number;
    }>;
    onEventUpdated(eventId: string, eventNameEn: string, eventNameZh: string): Promise<{
        sent: number;
        eventId: string;
    }>;
    onMaterialUploaded(eventId: string, materialNameEn: string, materialNameZh: string): Promise<{
        sent: number;
        eventId: string;
    }>;
    onCheckInSuccess(userId: string, eventNameEn: string, eventNameZh: string): Promise<Notification>;
    sendScheduleReminder(userId: string, sessionTitleEn: string, sessionTitleZh: string, roomEn: string, roomZh: string): Promise<Notification>;
}
