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
exports.Session = exports.SessionType = void 0;
const typeorm_1 = require("typeorm");
const event_entity_1 = require("../../events/entities/event.entity");
const speaker_entity_1 = require("../../speakers/entities/speaker.entity");
var SessionType;
(function (SessionType) {
    SessionType["KEYNOTE"] = "keynote";
    SessionType["RESEARCH_PAPER"] = "research_paper";
    SessionType["WORKSHOP"] = "workshop";
    SessionType["PANEL"] = "panel";
    SessionType["BREAK"] = "break";
})(SessionType || (exports.SessionType = SessionType = {}));
let Session = class Session {
    id;
    titleEn;
    titleZh;
    descriptionEn;
    descriptionZh;
    roomEn;
    roomZh;
    startTime;
    endTime;
    type;
    dayIndex;
    sortOrder;
    event;
    eventId;
    speaker;
    speakerId;
    speakerName;
    speakerTitleEn;
    speakerTitleZh;
    speakerAvatarUrl;
    createdAt;
    updatedAt;
};
exports.Session = Session;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], Session.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_en' }),
    __metadata("design:type", String)
], Session.prototype, "titleEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_zh' }),
    __metadata("design:type", String)
], Session.prototype, "titleZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'description_en', type: 'text', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "descriptionEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'description_zh', type: 'text', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "descriptionZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'room_en', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "roomEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'room_zh', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "roomZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'start_time', type: 'datetime' }),
    __metadata("design:type", Date)
], Session.prototype, "startTime", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'end_time', type: 'datetime' }),
    __metadata("design:type", Date)
], Session.prototype, "endTime", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', default: SessionType.KEYNOTE }),
    __metadata("design:type", String)
], Session.prototype, "type", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'day_index', default: 0 }),
    __metadata("design:type", Number)
], Session.prototype, "dayIndex", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'sort_order', default: 0 }),
    __metadata("design:type", Number)
], Session.prototype, "sortOrder", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => event_entity_1.Event, (event) => event.sessions, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'event_id' }),
    __metadata("design:type", event_entity_1.Event)
], Session.prototype, "event", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'event_id' }),
    __metadata("design:type", String)
], Session.prototype, "eventId", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => speaker_entity_1.Speaker, { nullable: true, eager: true }),
    (0, typeorm_1.JoinColumn)({ name: 'speaker_id' }),
    __metadata("design:type", speaker_entity_1.Speaker)
], Session.prototype, "speaker", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'speaker_id', nullable: true }),
    __metadata("design:type", String)
], Session.prototype, "speakerId", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'speaker_name', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "speakerName", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'speaker_title_en', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "speakerTitleEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'speaker_title_zh', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "speakerTitleZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'speaker_avatar_url', default: '' }),
    __metadata("design:type", String)
], Session.prototype, "speakerAvatarUrl", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], Session.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: 'updated_at' }),
    __metadata("design:type", Date)
], Session.prototype, "updatedAt", void 0);
exports.Session = Session = __decorate([
    (0, typeorm_1.Entity)('sessions')
], Session);
//# sourceMappingURL=session.entity.js.map