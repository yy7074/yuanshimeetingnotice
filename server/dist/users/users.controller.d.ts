import { UsersService } from './users.service';
import { User } from './entities/user.entity';
export declare class UsersController {
    private usersService;
    constructor(usersService: UsersService);
    findAll(search?: string, role?: string): Promise<User[]>;
    getStats(): Promise<{
        total: number;
        active: number;
        vip: number;
    }>;
    updateProfile(req: any, data: Partial<User>): Promise<User>;
    updateRole(id: string, role: string): Promise<User>;
}
