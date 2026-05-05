import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

/**
 * Multi-channel push notification service
 * - JPush (极光推送): iOS + Android in China
 * - FCM: iOS + Android overseas (optional)
 * - APNs: iOS direct (via JPush)
 */
@Injectable()
export class PushService implements OnModuleInit {
  private jpushClient: any = null;
  private fcmMessaging: any = null;
  private jpushModule: any = null;

  constructor(private config: ConfigService) {}

  async onModuleInit() {
    await this._initJPush();
    await this._initFCM();
  }

  private async _initJPush() {
    const appKey = this.config.get('JPUSH_APP_KEY');
    const masterSecret = this.config.get('JPUSH_MASTER_SECRET');
    if (appKey && masterSecret) {
      try {
        const JPush = this.loadJPushModule();
        this.jpushClient = JPush.buildClient(appKey, masterSecret);
        this.jpushModule = JPush;
        console.log('JPush initialized (China push enabled)');
      } catch (e) {
        console.log('JPush init failed:', (e as Error).message);
      }
    } else {
      console.log(
        'JPush not configured (set JPUSH_APP_KEY and JPUSH_MASTER_SECRET in .env)',
      );
    }
  }

  private async _initFCM() {
    const serviceAccountPath = this.config.get('FIREBASE_SERVICE_ACCOUNT');
    if (serviceAccountPath) {
      try {
        const firebaseAdmin = await import('firebase-admin');
        const serviceAccount = require(serviceAccountPath);
        firebaseAdmin.initializeApp({
          credential: firebaseAdmin.credential.cert(serviceAccount),
        });
        this.fcmMessaging = firebaseAdmin.messaging();
        console.log('FCM initialized (overseas push enabled)');
      } catch (e) {
        console.log('FCM not configured');
      }
    }
  }

  get isJPushEnabled(): boolean {
    return this.jpushClient !== null;
  }
  get isFCMEnabled(): boolean {
    return this.fcmMessaging !== null;
  }

  /**
   * Send push to a specific device via JPush Registration ID
   */
  async sendToDevice(
    registrationId: string,
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    // Try JPush first (works in China)
    if (this.jpushClient) {
      return this._jpushToDevice(registrationId, title, body, extras);
    }
    // Fallback to FCM
    if (this.fcmMessaging) {
      return this._fcmToDevice(registrationId, title, body, extras);
    }
    // Dev mode
    console.log(`[DEV PUSH] To: ${registrationId} | ${title}: ${body}`);
    return { success: true, dev: true };
  }

  /**
   * Send push to multiple devices
   */
  async sendToMultiple(
    registrationIds: string[],
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    if (registrationIds.length === 0) return { success: true, count: 0 };

    if (this.jpushClient) {
      return this._jpushToMultiple(registrationIds, title, body, extras);
    }
    if (this.fcmMessaging) {
      return this._fcmToMultiple(registrationIds, title, body, extras);
    }
    console.log(
      `[DEV PUSH] Broadcast to ${registrationIds.length} devices | ${title}`,
    );
    return { success: true, dev: true, count: registrationIds.length };
  }

  /**
   * Send push to all users (broadcast)
   */
  async sendToAll(
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    if (this.jpushClient) {
      return this._jpushBroadcast(title, body, extras);
    }
    console.log(`[DEV PUSH] Broadcast all | ${title}: ${body}`);
    return { success: true, dev: true };
  }

  /**
   * Send push by tag (e.g., event subscribers)
   */
  async sendToTag(
    tag: string,
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    if (this.jpushClient) {
      return this._jpushToTag(tag, title, body, extras);
    }
    if (this.fcmMessaging) {
      return this._fcmToTopic(tag, title, body, extras);
    }
    console.log(`[DEV PUSH] Tag: ${tag} | ${title}: ${body}`);
    return { success: true, dev: true };
  }

  // === JPush Implementation ===
  private async _jpushToDevice(
    regId: string,
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    try {
      const JPush = this.loadJPushModule();
      const result = await this.jpushClient
        .push()
        .setPlatform(JPush.ALL)
        .setAudience(JPush.registration_id(regId))
        .setNotification(
          JPush.android(body, title, null, extras),
          JPush.ios({
            alert: { title, body },
            sound: 'default',
            badge: '+1',
            extras,
          }),
        )
        .setOptions(null, null, null, true) // apns_production
        .send();
      return { success: true, msgId: result.msg_id };
    } catch (e) {
      console.error('JPush send error:', (e as Error).message);
      return { success: false, error: (e as Error).message };
    }
  }

  private async _jpushToMultiple(
    regIds: string[],
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    try {
      const JPush = this.loadJPushModule();
      const result = await this.jpushClient
        .push()
        .setPlatform(JPush.ALL)
        .setAudience(JPush.registration_id(...regIds))
        .setNotification(
          JPush.android(body, title, null, extras),
          JPush.ios({
            alert: { title, body },
            sound: 'default',
            badge: '+1',
            extras,
          }),
        )
        .setOptions(null, null, null, true)
        .send();
      return { success: true, msgId: result.msg_id, count: regIds.length };
    } catch (e) {
      return { success: false, error: (e as Error).message };
    }
  }

  private async _jpushBroadcast(
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    try {
      const JPush = this.loadJPushModule();
      const result = await this.jpushClient
        .push()
        .setPlatform(JPush.ALL)
        .setAudience(JPush.ALL)
        .setNotification(
          JPush.android(body, title, null, extras),
          JPush.ios({
            alert: { title, body },
            sound: 'default',
            badge: '+1',
            extras,
          }),
        )
        .setOptions(null, null, null, true)
        .send();
      return { success: true, msgId: result.msg_id };
    } catch (e) {
      return { success: false, error: (e as Error).message };
    }
  }

  private async _jpushToTag(
    tag: string,
    title: string,
    body: string,
    extras?: Record<string, string>,
  ) {
    try {
      const JPush = this.loadJPushModule();
      const result = await this.jpushClient
        .push()
        .setPlatform(JPush.ALL)
        .setAudience(JPush.tag(tag))
        .setNotification(
          JPush.android(body, title, null, extras),
          JPush.ios({
            alert: { title, body },
            sound: 'default',
            badge: '+1',
            extras,
          }),
        )
        .setOptions(null, null, null, true)
        .send();
      return { success: true, msgId: result.msg_id };
    } catch (e) {
      return { success: false, error: (e as Error).message };
    }
  }

  // === FCM Implementation (overseas fallback) ===
  private async _fcmToDevice(
    token: string,
    title: string,
    body: string,
    data?: Record<string, string>,
  ) {
    try {
      const result = await this.fcmMessaging.send({
        token,
        notification: { title, body },
        data: data || {},
        android: {
          priority: 'high' as const,
          notification: { sound: 'default' },
        },
        apns: { payload: { aps: { sound: 'default', badge: 1 } } },
      });
      return { success: true, messageId: result };
    } catch (e) {
      return { success: false, error: (e as Error).message };
    }
  }

  private async _fcmToMultiple(
    tokens: string[],
    title: string,
    body: string,
    data?: Record<string, string>,
  ) {
    try {
      const result = await this.fcmMessaging.sendEachForMulticast({
        tokens,
        notification: { title, body },
        data: data || {},
      });
      return {
        success: true,
        successCount: result.successCount,
        failureCount: result.failureCount,
      };
    } catch (e) {
      return { success: false, error: (e as Error).message };
    }
  }

  private async _fcmToTopic(
    topic: string,
    title: string,
    body: string,
    data?: Record<string, string>,
  ) {
    try {
      const result = await this.fcmMessaging.send({
        topic,
        notification: { title, body },
        data: data || {},
      });
      return { success: true, messageId: result };
    } catch (e) {
      return { success: false, error: (e as Error).message };
    }
  }

  private loadJPushModule() {
    if (this.jpushModule) {
      return this.jpushModule;
    }

    // `jpush-async` is a CommonJS package. In some runtime combinations it is
    // exposed directly, and in others it is nested under `default`.
    const loaded = require('jpush-async');
    const normalized =
      typeof loaded?.buildClient === 'function'
        ? loaded
        : typeof loaded?.default?.buildClient === 'function'
          ? loaded.default
          : typeof loaded?.JPushAsync?.buildClient === 'function'
            ? loaded.JPushAsync
            : typeof loaded?.JPush?.buildClient === 'function'
              ? loaded.JPush
          : null;

    if (!normalized) {
      throw new Error('Unsupported jpush-async export shape');
    }

    this.jpushModule = normalized;
    return normalized;
  }
}
