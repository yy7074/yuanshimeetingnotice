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
exports.User = exports.UserRole = void 0;
const typeorm_1 = require("typeorm");
const event_entity_1 = require("../../events/entities/event.entity");
const class_transformer_1 = require("class-transformer");
var UserRole;
(function (UserRole) {
    UserRole["ATTENDEE"] = "attendee";
    UserRole["SPEAKER"] = "speaker";
    UserRole["VIP"] = "vip";
    UserRole["ADMIN"] = "admin";
})(UserRole || (exports.UserRole = UserRole = {}));
let User = class User {
    id;
    email;
    password;
    nameEn;
    nameZh;
    titleEn;
    titleZh;
    organizationEn;
    organizationZh;
    avatarUrl;
    role;
    isActive;
    pushEnabled;
    language;
    fcmToken;
    subscribedEvents;
    createdAt;
    updatedAt;
};
exports.User = User;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], User.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ unique: true }),
    __metadata("design:type", String)
], User.prototype, "email", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    (0, class_transformer_1.Exclude)(),
    __metadata("design:type", String)
], User.prototype, "password", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'name_en', default: '' }),
    __metadata("design:type", String)
], User.prototype, "nameEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'name_zh', default: '' }),
    __metadata("design:type", String)
], User.prototype, "nameZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_en', default: '' }),
    __metadata("design:type", String)
], User.prototype, "titleEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_zh', default: '' }),
    __metadata("design:type", String)
], User.prototype, "titleZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'organization_en', default: '' }),
    __metadata("design:type", String)
], User.prototype, "organizationEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'organization_zh', default: '' }),
    __metadata("design:type", String)
], User.prototype, "organizationZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'avatar_url', default: '' }),
    __metadata("design:type", String)
], User.prototype, "avatarUrl", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', default: UserRole.ATTENDEE }),
    __metadata("design:type", String)
], User.prototype, "role", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'is_active', default: true }),
    __metadata("design:type", Boolean)
], User.prototype, "isActive", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'push_enabled', default: true }),
    __metadata("design:type", Boolean)
], User.prototype, "pushEnabled", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'language', default: 'zh' }),
    __metadata("design:type", String)
], User.prototype, "language", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'fcm_token', nullable: true }),
    __metadata("design:type", String)
], User.prototype, "fcmToken", void 0);
__decorate([
    (0, typeorm_1.ManyToMany)(() => event_entity_1.Event, (event) => event.subscribers),
    (0, typeorm_1.JoinTable)({ name: 'user_subscriptions' }),
    __metadata("design:type", Array)
], User.prototype, "subscribedEvents", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], User.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: 'updated_at' }),
    __metadata("design:type", Date)
], User.prototype, "updatedAt", void 0);
exports.User = User = __decorate([
    (0, typeorm_1.Entity)('users')
], User);
//# sourceMappingURL=user.entity.js.map