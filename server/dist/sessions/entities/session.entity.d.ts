import { Event } from '../../events/entities/event.entity';
import { Speaker } from '../../speakers/entities/speaker.entity';
export declare enum SessionType {
    KEYNOTE = "keynote",
    RESEARCH_PAPER = "research_paper",
    WORKSHOP = "workshop",
    PANEL = "panel",
    BREAK = "break"
}
export declare class Session {
    id: string;
    titleEn: string;
    titleZh: string;
    descriptionEn: string;
    descriptionZh: string;
    roomEn: string;
    roomZh: string;
    startTime: Date;
    endTime: Date;
    type: SessionType;
    dayIndex: number;
    sortOrder: number;
    event: Event;
    eventId: string;
    speaker: Speaker;
    speakerId: string;
    speakerName: string;
    speakerTitleEn: string;
    speakerTitleZh: string;
    speakerAvatarUrl: string;
    createdAt: Date;
    updatedAt: Date;
}
