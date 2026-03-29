import { UserRole } from './entities/user.entity';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
export declare class ImportController {
    private userRepo;
    constructor(userRepo: Repository<User>);
    importAttendees(body: {
        attendees: Array<{
            email: string;
            nameEn?: string;
            nameZh?: string;
            role?: string;
            organizationEn?: string;
            organizationZh?: string;
        }>;
    }): Promise<{
        created: number;
        skipped: number;
        errors: string[];
    }>;
    exportUsers(): Promise<{
        email: string;
        nameEn: string;
        nameZh: string;
        role: UserRole;
        organizationEn: string;
        organizationZh: string;
        isActive: boolean;
        createdAt: Date;
    }[]>;
}
