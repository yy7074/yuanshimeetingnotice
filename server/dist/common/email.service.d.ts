import { ConfigService } from '@nestjs/config';
export declare class EmailService {
    private config;
    private transporter;
    constructor(config: ConfigService);
    sendVerificationCode(email: string, code: string, lang?: string): Promise<{
        success: boolean;
        dev: boolean;
        messageId?: undefined;
        error?: undefined;
    } | {
        success: boolean;
        messageId: any;
        dev?: undefined;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        dev?: undefined;
        messageId?: undefined;
    }>;
    sendInvitation(email: string, data: {
        eventNameEn: string;
        eventNameZh: string;
        inviteUrl: string;
    }, lang?: string): Promise<{
        success: boolean;
        dev: boolean;
        messageId?: undefined;
        error?: undefined;
    } | {
        success: boolean;
        messageId: any;
        dev?: undefined;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        dev?: undefined;
        messageId?: undefined;
    }>;
    private send;
}
