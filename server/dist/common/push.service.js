"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PushService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
let PushService = class PushService {
    config;
    jpushClient = null;
    fcmMessaging = null;
    constructor(config) {
        this.config = config;
    }
    async onModuleInit() {
        await this._initJPush();
        await this._initFCM();
    }
    async _initJPush() {
        const appKey = this.config.get('JPUSH_APP_KEY');
        const masterSecret = this.config.get('JPUSH_MASTER_SECRET');
        if (appKey && masterSecret) {
            try {
                const JPush = (await import('jpush-async')).default;
                this.jpushClient = JPush.buildClient(appKey, masterSecret);
                console.log('JPush initialized (China push enabled)');
            }
            catch (e) {
                console.log('JPush init failed:', e.message);
            }
        }
        else {
            console.log('JPush not configured (set JPUSH_APP_KEY and JPUSH_MASTER_SECRET in .env)');
        }
    }
    async _initFCM() {
        const serviceAccountPath = this.config.get('FIREBASE_SERVICE_ACCOUNT');
        if (serviceAccountPath) {
            try {
                const firebaseAdmin = await import('firebase-admin');
                const serviceAccount = require(serviceAccountPath);
                firebaseAdmin.initializeApp({ credential: firebaseAdmin.credential.cert(serviceAccount) });
                this.fcmMessaging = firebaseAdmin.messaging();
                console.log('FCM initialized (overseas push enabled)');
            }
            catch (e) {
                console.log('FCM not configured');
            }
        }
    }
    get isJPushEnabled() { return this.jpushClient !== null; }
    get isFCMEnabled() { return this.fcmMessaging !== null; }
    async sendToDevice(registrationId, title, body, extras) {
        if (this.jpushClient) {
            return this._jpushToDevice(registrationId, title, body, extras);
        }
        if (this.fcmMessaging) {
            return this._fcmToDevice(registrationId, title, body, extras);
        }
        console.log(`[DEV PUSH] To: ${registrationId} | ${title}: ${body}`);
        return { success: true, dev: true };
    }
    async sendToMultiple(registrationIds, title, body, extras) {
        if (registrationIds.length === 0)
            return { success: true, count: 0 };
        if (this.jpushClient) {
            return this._jpushToMultiple(registrationIds, title, body, extras);
        }
        if (this.fcmMessaging) {
            return this._fcmToMultiple(registrationIds, title, body, extras);
        }
        console.log(`[DEV PUSH] Broadcast to ${registrationIds.length} devices | ${title}`);
        return { success: true, dev: true, count: registrationIds.length };
    }
    async sendToAll(title, body, extras) {
        if (this.jpushClient) {
            return this._jpushBroadcast(title, body, extras);
        }
        console.log(`[DEV PUSH] Broadcast all | ${title}: ${body}`);
        return { success: true, dev: true };
    }
    async sendToTag(tag, title, body, extras) {
        if (this.jpushClient) {
            return this._jpushToTag(tag, title, body, extras);
        }
        if (this.fcmMessaging) {
            return this._fcmToTopic(tag, title, body, extras);
        }
        console.log(`[DEV PUSH] Tag: ${tag} | ${title}: ${body}`);
        return { success: true, dev: true };
    }
    async _jpushToDevice(regId, title, body, extras) {
        try {
            const JPush = (await import('jpush-async')).default;
            const result = await this.jpushClient.push()
                .setPlatform(JPush.ALL)
                .setAudience(JPush.registration_id(regId))
                .setNotification(JPush.android(body, title, null, extras), JPush.ios({ alert: { title, body }, sound: 'default', badge: '+1', extras }))
                .setOptions(null, null, null, true)
                .send();
            return { success: true, msgId: result.msg_id };
        }
        catch (e) {
            console.error('JPush send error:', e.message);
            return { success: false, error: e.message };
        }
    }
    async _jpushToMultiple(regIds, title, body, extras) {
        try {
            const JPush = (await import('jpush-async')).default;
            const result = await this.jpushClient.push()
                .setPlatform(JPush.ALL)
                .setAudience(JPush.registration_id(...regIds))
                .setNotification(JPush.android(body, title, null, extras), JPush.ios({ alert: { title, body }, sound: 'default', badge: '+1', extras }))
                .setOptions(null, null, null, true)
                .send();
            return { success: true, msgId: result.msg_id, count: regIds.length };
        }
        catch (e) {
            return { success: false, error: e.message };
        }
    }
    async _jpushBroadcast(title, body, extras) {
        try {
            const JPush = (await import('jpush-async')).default;
            const result = await this.jpushClient.push()
                .setPlatform(JPush.ALL)
                .setAudience(JPush.ALL)
                .setNotification(JPush.android(body, title, null, extras), JPush.ios({ alert: { title, body }, sound: 'default', badge: '+1', extras }))
                .setOptions(null, null, null, true)
                .send();
            return { success: true, msgId: result.msg_id };
        }
        catch (e) {
            return { success: false, error: e.message };
        }
    }
    async _jpushToTag(tag, title, body, extras) {
        try {
            const JPush = (await import('jpush-async')).default;
            const result = await this.jpushClient.push()
                .setPlatform(JPush.ALL)
                .setAudience(JPush.tag(tag))
                .setNotification(JPush.android(body, title, null, extras), JPush.ios({ alert: { title, body }, sound: 'default', badge: '+1', extras }))
                .setOptions(null, null, null, true)
                .send();
            return { success: true, msgId: result.msg_id };
        }
        catch (e) {
            return { success: false, error: e.message };
        }
    }
    async _fcmToDevice(token, title, body, data) {
        try {
            const result = await this.fcmMessaging.send({
                token,
                notification: { title, body },
                data: data || {},
                android: { priority: 'high', notification: { sound: 'default' } },
                apns: { payload: { aps: { sound: 'default', badge: 1 } } },
            });
            return { success: true, messageId: result };
        }
        catch (e) {
            return { success: false, error: e.message };
        }
    }
    async _fcmToMultiple(tokens, title, body, data) {
        try {
            const result = await this.fcmMessaging.sendEachForMulticast({
                tokens,
                notification: { title, body },
                data: data || {},
            });
            return { success: true, successCount: result.successCount, failureCount: result.failureCount };
        }
        catch (e) {
            return { success: false, error: e.message };
        }
    }
    async _fcmToTopic(topic, title, body, data) {
        try {
            const result = await this.fcmMessaging.send({ topic, notification: { title, body }, data: data || {} });
            return { success: true, messageId: result };
        }
        catch (e) {
            return { success: false, error: e.message };
        }
    }
};
exports.PushService = PushService;
exports.PushService = PushService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], PushService);
//# sourceMappingURL=push.service.js.map