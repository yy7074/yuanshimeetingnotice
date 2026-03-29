import { User } from '../../users/entities/user.entity';
import { Event } from '../../events/entities/event.entity';
export declare class CheckIn {
    id: string;
    user: User;
    userId: string;
    event: Event;
    eventId: string;
    qrCode: string;
    checkedIn: boolean;
    checkedInAt: Date;
}
