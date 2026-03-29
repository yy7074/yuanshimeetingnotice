import { Repository } from 'typeorm';
import { Event } from './entities/event.entity';
import { CreateEventDto, UpdateEventDto } from './dto/event.dto';
import { User } from '../users/entities/user.entity';
export declare class EventsService {
    private eventRepo;
    private userRepo;
    constructor(eventRepo: Repository<Event>, userRepo: Repository<User>);
    findAll(query?: {
        search?: string;
        status?: string;
    }): Promise<any[]>;
    findOne(id: string): Promise<Event>;
    create(dto: CreateEventDto): Promise<Event>;
    update(id: string, dto: UpdateEventDto): Promise<Event>;
    remove(id: string): Promise<Event>;
    subscribe(eventId: string, userId: string): Promise<{
        message: string;
    }>;
    unsubscribe(eventId: string, userId: string): Promise<{
        message: string;
    }>;
    getMyEvents(userId: string): Promise<Event[]>;
    getStats(): Promise<{
        total: number;
        published: number;
        draft: number;
    }>;
}
