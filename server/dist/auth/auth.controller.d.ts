import { AuthService } from './auth.service';
import { RegisterDto, LoginDto, ForgotPasswordDto, ResetPasswordDto } from './dto/register.dto';
export declare class AuthController {
    private authService;
    constructor(authService: AuthService);
    sendCode(email: string): Promise<{
        message: string;
        code: string | undefined;
    }>;
    register(dto: RegisterDto & {
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
    forgotPassword(dto: ForgotPasswordDto): Promise<{
        message: string;
        code: string | undefined;
    } | {
        message: string;
    }>;
    resetPassword(dto: ResetPasswordDto): Promise<{
        message: string;
    }>;
    getProfile(req: any): any;
}
