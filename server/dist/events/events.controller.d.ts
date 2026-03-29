import { EventsService } from './events.service';
import { CreateEventDto, UpdateEventDto } from './dto/event.dto';
export declare class EventsController {
    private eventsService;
    constructor(eventsService: EventsService);
    findAll(search?: string, status?: string): Promise<any[]>;
    getStats(): Promise<{
        total: number;
        published: number;
        draft: number;
    }>;
    getMyEvents(req: any): Promise<import("./entities/event.entity").Event[]>;
    findOne(id: string): Promise<import("./entities/event.entity").Event>;
    create(dto: CreateEventDto): Promise<import("./entities/event.entity").Event>;
    update(id: string, dto: UpdateEventDto): Promise<import("./entities/event.entity").Event>;
    remove(id: string): Promise<import("./entities/event.entity").Event>;
    subscribe(id: string, req: any): Promise<{
        message: string;
    }>;
    unsubscribe(id: string, req: any): Promise<{
        message: string;
    }>;
}
