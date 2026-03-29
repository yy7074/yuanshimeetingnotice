import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
export declare class UsersService {
    private userRepo;
    constructor(userRepo: Repository<User>);
    findAll(query?: {
        search?: string;
        role?: string;
    }): Promise<User[]>;
    findOne(id: string): Promise<User>;
    updateProfile(id: string, data: Partial<User>): Promise<User>;
    updateRole(id: string, role: string): Promise<User>;
    deactivate(id: string): Promise<User>;
    getStats(): Promise<{
        total: number;
        active: number;
        vip: number;
    }>;
}
