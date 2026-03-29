import { OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
export declare class PushService implements OnModuleInit {
    private config;
    private jpushClient;
    private fcmMessaging;
    constructor(config: ConfigService);
    onModuleInit(): Promise<void>;
    private _initJPush;
    private _initFCM;
    get isJPushEnabled(): boolean;
    get isFCMEnabled(): boolean;
    sendToDevice(registrationId: string, title: string, body: string, extras?: Record<string, string>): Promise<{
        success: boolean;
        msgId: any;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        msgId?: undefined;
    } | {
        success: boolean;
        messageId: any;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        messageId?: undefined;
    } | {
        success: boolean;
        dev: boolean;
    }>;
    sendToMultiple(registrationIds: string[], title: string, body: string, extras?: Record<string, string>): Promise<{
        success: boolean;
        msgId: any;
        count: number;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        msgId?: undefined;
        count?: undefined;
    } | {
        success: boolean;
        successCount: any;
        failureCount: any;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        successCount?: undefined;
        failureCount?: undefined;
    } | {
        success: boolean;
        count: number;
        dev?: undefined;
    } | {
        success: boolean;
        dev: boolean;
        count: number;
    }>;
    sendToAll(title: string, body: string, extras?: Record<string, string>): Promise<{
        success: boolean;
        msgId: any;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        msgId?: undefined;
    } | {
        success: boolean;
        dev: boolean;
    }>;
    sendToTag(tag: string, title: string, body: string, extras?: Record<string, string>): Promise<{
        success: boolean;
        msgId: any;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        msgId?: undefined;
    } | {
        success: boolean;
        messageId: any;
        error?: undefined;
    } | {
        success: boolean;
        error: string;
        messageId?: undefined;
    } | {
        success: boolean;
        dev: boolean;
    }>;
    private _jpushToDevice;
    private _jpushToMultiple;
    private _jpushBroadcast;
    private _jpushToTag;
    private _fcmToDevice;
    private _fcmToMultiple;
    private _fcmToTopic;
}
