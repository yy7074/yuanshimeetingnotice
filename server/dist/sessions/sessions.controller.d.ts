import { SessionsService } from './sessions.service';
import { Session } from './entities/session.entity';
export declare class SessionsController {
    private sessionsService;
    constructor(sessionsService: SessionsService);
    findByEvent(eventId: string): Promise<Session[]>;
    findOne(id: string): Promise<Session>;
    create(eventId: string, data: Partial<Session>): Promise<Session>;
    update(id: string, data: Partial<Session>): Promise<Session>;
    remove(id: string): Promise<Session>;
}
