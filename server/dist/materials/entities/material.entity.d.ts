import { Event } from '../../events/entities/event.entity';
export declare enum MaterialType {
    PDF = "pdf",
    PPT = "ppt",
    IMAGE = "image",
    OTHER = "other"
}
export declare class Material {
    id: string;
    nameEn: string;
    nameZh: string;
    fileUrl: string;
    fileSize: number;
    type: MaterialType;
    visibleTo: string[];
    downloadCount: number;
    event: Event;
    eventId: string;
    sessionId: string;
    createdAt: Date;
    updatedAt: Date;
}
