import { Session } from '../../sessions/entities/session.entity';
import { Material } from '../../materials/entities/material.entity';
import { User } from '../../users/entities/user.entity';
export declare enum EventStatus {
    DRAFT = "draft",
    PUBLISHED = "published",
    ENDED = "ended"
}
export declare class Event {
    id: string;
    titleEn: string;
    titleZh: string;
    descriptionEn: string;
    descriptionZh: string;
    locationEn: string;
    locationZh: string;
    imageUrl: string;
    bannerUrl: string;
    startDate: Date;
    endDate: Date;
    organizerEn: string;
    organizerZh: string;
    tags: string[];
    isFeatured: boolean;
    maxAttendees: number;
    status: EventStatus;
    sessions: Session[];
    materials: Material[];
    subscribers: User[];
    createdAt: Date;
    updatedAt: Date;
}
