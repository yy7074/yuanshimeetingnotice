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
exports.Notification = exports.NotificationType = void 0;
const typeorm_1 = require("typeorm");
const user_entity_1 = require("../../users/entities/user.entity");
var NotificationType;
(function (NotificationType) {
    NotificationType["SCHEDULE_REMINDER"] = "schedule_reminder";
    NotificationType["EVENT_UPDATE"] = "event_update";
    NotificationType["MATERIAL_UPDATE"] = "material_update";
    NotificationType["CHECK_IN_SUCCESS"] = "check_in_success";
    NotificationType["SYSTEM"] = "system";
})(NotificationType || (exports.NotificationType = NotificationType = {}));
let Notification = class Notification {
    id;
    titleEn;
    titleZh;
    bodyEn;
    bodyZh;
    type;
    isRead;
    targetUrl;
    eventId;
    user;
    userId;
    createdAt;
};
exports.Notification = Notification;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], Notification.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_en' }),
    __metadata("design:type", String)
], Notification.prototype, "titleEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_zh' }),
    __metadata("design:type", String)
], Notification.prototype, "titleZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'body_en', type: 'text' }),
    __metadata("design:type", String)
], Notification.prototype, "bodyEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'body_zh', type: 'text' }),
    __metadata("design:type", String)
], Notification.prototype, "bodyZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', default: NotificationType.SYSTEM }),
    __metadata("design:type", String)
], Notification.prototype, "type", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'is_read', default: false }),
    __metadata("design:type", Boolean)
], Notification.prototype, "isRead", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'target_url', nullable: true }),
    __metadata("design:type", String)
], Notification.prototype, "targetUrl", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'event_id', nullable: true }),
    __metadata("design:type", String)
], Notification.prototype, "eventId", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => user_entity_1.User, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'user_id' }),
    __metadata("design:type", user_entity_1.User)
], Notification.prototype, "user", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'user_id' }),
    __metadata("design:type", String)
], Notification.prototype, "userId", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], Notification.prototype, "createdAt", void 0);
exports.Notification = Notification = __decorate([
    (0, typeorm_1.Entity)('notifications')
], Notification);
//# sourceMappingURL=notification.entity.js.map