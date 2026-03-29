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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificationDispatcherService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const notification_entity_1 = require("./entities/notification.entity");
const user_entity_1 = require("../users/entities/user.entity");
const push_service_1 = require("../common/push.service");
const email_service_1 = require("../common/email.service");
let NotificationDispatcherService = class NotificationDispatcherService {
    notifRepo;
    userRepo;
    pushService;
    emailService;
    constructor(notifRepo, userRepo, pushService, emailService) {
        this.notifRepo = notifRepo;
        this.userRepo = userRepo;
        this.pushService = pushService;
        this.emailService = emailService;
    }
    async dispatch(params) {
        const { userId, sendPush = true, sendEmail = false, ...notifData } = params;
        const notification = this.notifRepo.create({ ...notifData, userId });
        await this.notifRepo.save(notification);
        const user = await this.userRepo.findOne({ where: { id: userId } });
        if (!user)
            return notification;
        if (sendPush && user.pushEnabled && user.fcmToken) {
            const title = user.language === 'zh' ? notifData.titleZh : notifData.titleEn;
            const body = user.language === 'zh' ? notifData.bodyZh : notifData.bodyEn;
            await this.pushService.sendToDevice(user.fcmToken, title, body, {
                type: notifData.type,
                eventId: notifData.eventId || '',
                notificationId: notification.id,
            });
        }
        if (sendEmail && user.email) {
            const lang = user.language || 'zh';
            const subject = lang === 'zh' ? notifData.titleZh : notifData.titleEn;
            const html = `
        <div style="max-width:600px;margin:0 auto;font-family:sans-serif">
          <div style="background:#000666;padding:24px;color:white;text-align:center">
            <h1 style="margin:0;font-size:20px">APSCVIR</h1>
          </div>
          <div style="padding:24px;background:#f9fafb">
            <h2 style="color:#0F172A">${lang === 'zh' ? notifData.titleZh : notifData.titleEn}</h2>
            <p style="color:#64748B;line-height:1.6">${lang === 'zh' ? notifData.bodyZh : notifData.bodyEn}</p>
          </div>
          <div style="padding:16px;text-align:center;color:#94A3B8;font-size:12px">
            © 2026 APSCVIR Conference
          </div>
        </div>
      `;
            await this.emailService.send(user.email, subject, html);
        }
        return notification;
    }
    async broadcastToEvent(params) {
        const { eventId, sendPush = true, sendEmail = false, ...notifData } = params;
        const users = await this.userRepo
            .createQueryBuilder('u')
            .innerJoin('u.subscribedEvents', 'e', 'e.id = :eventId', { eventId })
            .getMany();
        let count = 0;
        for (const user of users) {
            await this.dispatch({
                ...notifData,
                userId: user.id,
                eventId,
                sendPush,
                sendEmail,
            });
            count++;
        }
        if (sendPush) {
            const title = notifData.titleEn;
            const body = notifData.bodyEn;
            await this.pushService.sendToTag(`event_${eventId}`, title, body);
        }
        return { sent: count, eventId };
    }
    async broadcastToAll(params) {
        const users = await this.userRepo.find({ where: { isActive: true } });
        let count = 0;
        for (const user of users) {
            await this.dispatch({
                ...params,
                userId: user.id,
            });
            count++;
        }
        return { sent: count };
    }
    async onEventPublished(eventId, eventNameEn, eventNameZh) {
        return this.broadcastToAll({
            titleEn: 'New Event Published',
            titleZh: '新会议已发布',
            bodyEn: `"${eventNameEn}" is now available. Check it out!`,
            bodyZh: `"${eventNameZh}" 现已发布，快来查看！`,
            type: notification_entity_1.NotificationType.EVENT_UPDATE,
            sendPush: true,
        });
    }
    async onEventUpdated(eventId, eventNameEn, eventNameZh) {
        return this.broadcastToEvent({
            eventId,
            titleEn: 'Event Updated',
            titleZh: '会议信息已更新',
            bodyEn: `"${eventNameEn}" has been updated.`,
            bodyZh: `"${eventNameZh}" 信息已更新。`,
            type: notification_entity_1.NotificationType.EVENT_UPDATE,
            sendPush: true,
        });
    }
    async onMaterialUploaded(eventId, materialNameEn, materialNameZh) {
        return this.broadcastToEvent({
            eventId,
            titleEn: 'New Material Available',
            titleZh: '新资料已上传',
            bodyEn: `"${materialNameEn}" has been uploaded.`,
            bodyZh: `"${materialNameZh}" 已上传，请查看。`,
            type: notification_entity_1.NotificationType.MATERIAL_UPDATE,
            sendPush: true,
        });
    }
    async onCheckInSuccess(userId, eventNameEn, eventNameZh) {
        return this.dispatch({
            userId,
            titleEn: 'Check-in Successful',
            titleZh: '签到成功',
            bodyEn: `You have checked in to "${eventNameEn}".`,
            bodyZh: `您已成功签到 "${eventNameZh}"。`,
            type: notification_entity_1.NotificationType.CHECK_IN_SUCCESS,
            sendPush: true,
        });
    }
    async sendScheduleReminder(userId, sessionTitleEn, sessionTitleZh, roomEn, roomZh) {
        return this.dispatch({
            userId,
            titleEn: 'Session Starting Soon',
            titleZh: '议程即将开始',
            bodyEn: `"${sessionTitleEn}" starts in 15 minutes at ${roomEn}.`,
            bodyZh: `"${sessionTitleZh}" 将于15分钟后在 ${roomZh} 开始。`,
            type: notification_entity_1.NotificationType.SCHEDULE_REMINDER,
            sendPush: true,
        });
    }
};
exports.NotificationDispatcherService = NotificationDispatcherService;
exports.NotificationDispatcherService = NotificationDispatcherService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(notification_entity_1.Notification)),
    __param(1, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        push_service_1.PushService,
        email_service_1.EmailService])
], NotificationDispatcherService);
//# sourceMappingURL=notification-dispatcher.service.js.map