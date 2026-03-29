import { SpeakersService } from './speakers.service';
import { Speaker } from './entities/speaker.entity';
export declare class SpeakersController {
    private speakersService;
    constructor(speakersService: SpeakersService);
    findAll(search?: string): Promise<Speaker[]>;
    findOne(id: string): Promise<Speaker>;
    create(data: Partial<Speaker>): Promise<Speaker>;
    update(id: string, data: Partial<Speaker>): Promise<Speaker>;
    remove(id: string): Promise<Speaker>;
}
