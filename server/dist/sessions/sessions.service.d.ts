import { Repository } from 'typeorm';
import { Session } from './entities/session.entity';
export declare class SessionsService {
    private sessionRepo;
    constructor(sessionRepo: Repository<Session>);
    findByEvent(eventId: string): Promise<Session[]>;
    findOne(id: string): Promise<Session>;
    create(data: Partial<Session>): Promise<Session>;
    update(id: string, data: Partial<Session>): Promise<Session>;
    remove(id: string): Promise<Session>;
}
