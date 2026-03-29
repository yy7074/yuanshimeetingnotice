import { Repository } from 'typeorm';
import { CheckIn } from './entities/check-in.entity';
export declare class CheckInService {
    private checkInRepo;
    constructor(checkInRepo: Repository<CheckIn>);
    generateQrCode(userId: string, eventId: string): Promise<{
        qrCode: string;
        expiresIn: number;
    }>;
    verify(qrCode: string): Promise<{
        message: string;
        checkIn: CheckIn;
    }>;
    getCheckIns(eventId: string): Promise<CheckIn[]>;
    getStats(eventId: string): Promise<{
        eventId: string;
        checkedInCount: number;
    }>;
}
