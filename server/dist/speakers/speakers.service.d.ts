import { Repository } from 'typeorm';
import { Speaker } from './entities/speaker.entity';
export declare class SpeakersService {
    private speakerRepo;
    constructor(speakerRepo: Repository<Speaker>);
    findAll(search?: string): Promise<Speaker[]>;
    findOne(id: string): Promise<Speaker>;
    create(data: Partial<Speaker>): Promise<Speaker>;
    update(id: string, data: Partial<Speaker>): Promise<Speaker>;
    remove(id: string): Promise<Speaker>;
}
