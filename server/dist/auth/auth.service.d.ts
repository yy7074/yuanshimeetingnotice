import { JwtService } from '@nestjs/jwt';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { RegisterDto, LoginDto, ForgotPasswordDto, ResetPasswordDto } from './dto/register.dto';
import { EmailService } from '../common/email.service';
export declare class AuthService {
    private userRepo;
    private jwtService;
    private emailService;
    private verificationCodes;
    constructor(userRepo: Repository<User>, jwtService: JwtService, emailService: EmailService);
    register(dto: RegisterDto): Promise<{
        user: {
            id: string;
            email: string;
            nameEn: string;
            nameZh: string;
            titleEn: string;
            titleZh: string;
            organizationEn: string;
            organizationZh: string;
            avatarUrl: string;
            role: import("../users/entities/user.entity").UserRole;
            isActive: boolean;
            pushEnabled: boolean;
            language: string;
            fcmToken: string;
            subscribedEvents: import("../events/entities/event.entity").Event[];
            createdAt: Date;
            updatedAt: Date;
        };
        token: string;
    }>;
    login(dto: LoginDto): Promise<{
        user: {
            id: string;
            email: string;
            nameEn: string;
            nameZh: string;
            titleEn: string;
            titleZh: string;
            organizationEn: string;
            organizationZh: string;
            avatarUrl: string;
            role: import("../users/entities/user.entity").UserRole;
            isActive: boolean;
            pushEnabled: boolean;
            language: string;
            fcmToken: string;
            subscribedEvents: import("../events/entities/event.entity").Event[];
            createdAt: Date;
            updatedAt: Date;
        };
        token: string;
    }>;
    sendVerificationCode(email: string): Promise<{
        message: string;
        code: string | undefined;
    }>;
    verifyCode(email: string, code: string): Promise<boolean>;
    registerWithCode(dto: RegisterDto & {
        code: string;
    }): Promise<{
        user: {
            id: string;
            email: string;
            nameEn: string;
            nameZh: string;
            titleEn: string;
            titleZh: string;
            organizationEn: string;
            organizationZh: string;
            avatarUrl: string;
            role: import("../users/entities/user.entity").UserRole;
            isActive: boolean;
            pushEnabled: boolean;
            language: string;
            fcmToken: string;
            subscribedEvents: import("../events/entities/event.entity").Event[];
            createdAt: Date;
            updatedAt: Date;
        };
        token: string;
    }>;
    forgotPassword(dto: ForgotPasswordDto): Promise<{
        message: string;
        code: string | undefined;
    } | {
        message: string;
    }>;
    resetPassword(dto: ResetPasswordDto): Promise<{
        message: string;
    }>;
    validateUser(userId: string): Promise<User | null>;
    private generateToken;
    private sanitizeUser;
}
