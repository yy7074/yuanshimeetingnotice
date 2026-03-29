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
exports.Event = exports.EventStatus = void 0;
const typeorm_1 = require("typeorm");
const session_entity_1 = require("../../sessions/entities/session.entity");
const material_entity_1 = require("../../materials/entities/material.entity");
const user_entity_1 = require("../../users/entities/user.entity");
var EventStatus;
(function (EventStatus) {
    EventStatus["DRAFT"] = "draft";
    EventStatus["PUBLISHED"] = "published";
    EventStatus["ENDED"] = "ended";
})(EventStatus || (exports.EventStatus = EventStatus = {}));
let Event = class Event {
    id;
    titleEn;
    titleZh;
    descriptionEn;
    descriptionZh;
    locationEn;
    locationZh;
    imageUrl;
    bannerUrl;
    startDate;
    endDate;
    organizerEn;
    organizerZh;
    tags;
    isFeatured;
    maxAttendees;
    status;
    sessions;
    materials;
    subscribers;
    createdAt;
    updatedAt;
};
exports.Event = Event;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], Event.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_en' }),
    __metadata("design:type", String)
], Event.prototype, "titleEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_zh' }),
    __metadata("design:type", String)
], Event.prototype, "titleZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'description_en', type: 'text', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "descriptionEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'description_zh', type: 'text', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "descriptionZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'location_en', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "locationEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'location_zh', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "locationZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'image_url', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "imageUrl", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'banner_url', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "bannerUrl", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'start_date', type: 'datetime' }),
    __metadata("design:type", Date)
], Event.prototype, "startDate", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'end_date', type: 'datetime' }),
    __metadata("design:type", Date)
], Event.prototype, "endDate", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'organizer_en', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "organizerEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'organizer_zh', default: '' }),
    __metadata("design:type", String)
], Event.prototype, "organizerZh", void 0);
__decorate([
    (0, typeorm_1.Column)('simple-array', { nullable: true }),
    __metadata("design:type", Array)
], Event.prototype, "tags", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'is_featured', default: false }),
    __metadata("design:type", Boolean)
], Event.prototype, "isFeatured", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'max_attendees', default: 0 }),
    __metadata("design:type", Number)
], Event.prototype, "maxAttendees", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', default: EventStatus.DRAFT }),
    __metadata("design:type", String)
], Event.prototype, "status", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => session_entity_1.Session, (session) => session.event, { cascade: true }),
    __metadata("design:type", Array)
], Event.prototype, "sessions", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => material_entity_1.Material, (material) => material.event, { cascade: true }),
    __metadata("design:type", Array)
], Event.prototype, "materials", void 0);
__decorate([
    (0, typeorm_1.ManyToMany)(() => user_entity_1.User, (user) => user.subscribedEvents),
    __metadata("design:type", Array)
], Event.prototype, "subscribers", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], Event.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: 'updated_at' }),
    __metadata("design:type", Date)
], Event.prototype, "updatedAt", void 0);
exports.Event = Event = __decorate([
    (0, typeorm_1.Entity)('events')
], Event);
//# sourceMappingURL=event.entity.js.map