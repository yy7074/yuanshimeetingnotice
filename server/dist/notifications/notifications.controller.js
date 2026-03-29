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
exports.NotificationsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const notifications_service_1 = require("./notifications.service");
const notification_dispatcher_service_1 = require("./notification-dispatcher.service");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const user_entity_1 = require("../users/entities/user.entity");
const notification_entity_1 = require("./entities/notification.entity");
let NotificationsController = class NotificationsController {
    notifService;
    dispatcher;
    userRepo;
    constructor(notifService, dispatcher, userRepo) {
        this.notifService = notifService;
        this.dispatcher = dispatcher;
        this.userRepo = userRepo;
    }
    findMy(req) {
        return this.notifService.findByUser(req.user.id);
    }
    getUnreadCount(req) {
        return this.notifService.getUnreadCount(req.user.id);
    }
    markAsRead(id, req) {
        return this.notifService.markAsRead(id, req.user.id);
    }
    markAllAsRead(req) {
        return this.notifService.markAllAsRead(req.user.id);
    }
    async registerFcmToken(req, token) {
        await this.userRepo.update(req.user.id, { fcmToken: token });
        return { message: 'FCM token registered' };
    }
    async updatePushSettings(req, enabled) {
        await this.userRepo.update(req.user.id, { pushEnabled: enabled });
        return { message: 'Push settings updated' };
    }
    send(body) {
        return this.dispatcher.dispatch({
            ...body,
            type: body.type || notification_entity_1.NotificationType.SYSTEM,
            sendPush: body.sendPush ?? true,
            sendEmail: body.sendEmail ?? false,
        });
    }
    broadcast(body) {
        if (body.eventId) {
            return this.dispatcher.broadcastToEvent({
                ...body,
                eventId: body.eventId,
                type: body.type || notification_entity_1.NotificationType.SYSTEM,
            });
        }
        return this.dispatcher.broadcastToAll({
            ...body,
            type: body.type || notification_entity_1.NotificationType.SYSTEM,
        });
    }
};
exports.NotificationsController = NotificationsController;
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get my notifications' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], NotificationsController.prototype, "findMy", null);
__decorate([
    (0, common_1.Get)('unread-count'),
    (0, swagger_1.ApiOperation)({ summary: 'Get unread notification count' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], NotificationsController.prototype, "getUnreadCount", null);
__decorate([
    (0, common_1.Post)(':id/read'),
    (0, swagger_1.ApiOperation)({ summary: 'Mark notification as read' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", void 0)
], NotificationsController.prototype, "markAsRead", null);
__decorate([
    (0, common_1.Post)('read-all'),
    (0, swagger_1.ApiOperation)({ summary: 'Mark all notifications as read' }),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], NotificationsController.prototype, "markAllAsRead", null);
__decorate([
    (0, common_1.Put)('fcm-token'),
    (0, swagger_1.ApiOperation)({ summary: 'Register FCM token for push notifications' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)('token')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], NotificationsController.prototype, "registerFcmToken", null);
__decorate([
    (0, common_1.Put)('push-settings'),
    (0, swagger_1.ApiOperation)({ summary: 'Update push notification settings' }),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)('enabled')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Boolean]),
    __metadata("design:returntype", Promise)
], NotificationsController.prototype, "updatePushSettings", null);
__decorate([
    (0, common_1.Post)('send'),
    (0, common_1.UseGuards)(roles_guard_1.RolesGuard),
    (0, roles_guard_1.Roles)(user_entity_1.UserRole.ADMIN),
    (0, swagger_1.ApiOperation)({ summary: 'Send notification to a user (admin)' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], NotificationsController.prototype, "send", null);
__decorate([
    (0, common_1.Post)('broadcast'),
    (0, common_1.UseGuards)(roles_guard_1.RolesGuard),
    (0, roles_guard_1.Roles)(user_entity_1.UserRole.ADMIN),
    (0, swagger_1.ApiOperation)({ summary: 'Broadcast notification to all users (admin)' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], NotificationsController.prototype, "broadcast", null);
exports.NotificationsController = NotificationsController = __decorate([
    (0, swagger_1.ApiTags)('Notifications'),
    (0, common_1.Controller)('notifications'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    __param(2, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [notifications_service_1.NotificationsService,
        notification_dispatcher_service_1.NotificationDispatcherService,
        typeorm_2.Repository])
], NotificationsController);
//# sourceMappingURL=notifications.controller.js.map