import { CheckInService } from './check-in.service';
export declare class CheckInController {
    private checkInService;
    constructor(checkInService: CheckInService);
    generateQr(eventId: string, req: any): Promise<{
        qrCode: string;
        expiresIn: number;
    }>;
    verify(qrCode: string): Promise<{
        message: string;
        checkIn: import("./entities/check-in.entity").CheckIn;
    }>;
    getCheckIns(eventId: string): Promise<import("./entities/check-in.entity").CheckIn[]>;
    getStats(eventId: string): Promise<{
        eventId: string;
        checkedInCount: number;
    }>;
}
