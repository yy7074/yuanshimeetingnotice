import { EventStatus } from '../entities/event.entity';
export declare class CreateEventDto {
    titleEn: string;
    titleZh: string;
    descriptionEn?: string;
    descriptionZh?: string;
    locationEn?: string;
    locationZh?: string;
    imageUrl?: string;
    bannerUrl?: string;
    startDate: string;
    endDate: string;
    organizerEn?: string;
    organizerZh?: string;
    tags?: string[];
    isFeatured?: boolean;
    maxAttendees?: number;
    status?: EventStatus;
}
declare const UpdateEventDto_base: import("@nestjs/common").Type<Partial<CreateEventDto>>;
export declare class UpdateEventDto extends UpdateEventDto_base {
}
export {};
