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
exports.Speaker = exports.SpeakerCategory = void 0;
const typeorm_1 = require("typeorm");
var SpeakerCategory;
(function (SpeakerCategory) {
    SpeakerCategory["KEYNOTE"] = "keynote";
    SpeakerCategory["VIP_GUEST"] = "vip_guest";
    SpeakerCategory["RESEARCH"] = "research";
    SpeakerCategory["WORKSHOP"] = "workshop";
})(SpeakerCategory || (exports.SpeakerCategory = SpeakerCategory = {}));
let Speaker = class Speaker {
    id;
    nameEn;
    nameZh;
    titleEn;
    titleZh;
    organizationEn;
    organizationZh;
    bioEn;
    bioZh;
    avatarUrl;
    category;
    createdAt;
    updatedAt;
};
exports.Speaker = Speaker;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], Speaker.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'name_en' }),
    __metadata("design:type", String)
], Speaker.prototype, "nameEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'name_zh' }),
    __metadata("design:type", String)
], Speaker.prototype, "nameZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_en', default: '' }),
    __metadata("design:type", String)
], Speaker.prototype, "titleEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'title_zh', default: '' }),
    __metadata("design:type", String)
], Speaker.prototype, "titleZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'organization_en', default: '' }),
    __metadata("design:type", String)
], Speaker.prototype, "organizationEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'organization_zh', default: '' }),
    __metadata("design:type", String)
], Speaker.prototype, "organizationZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'bio_en', type: 'text', default: '' }),
    __metadata("design:type", String)
], Speaker.prototype, "bioEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'bio_zh', type: 'text', default: '' }),
    __metadata("design:type", String)
], Speaker.prototype, "bioZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'avatar_url', default: '' }),
    __metadata("design:type", String)
], Speaker.prototype, "avatarUrl", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', default: SpeakerCategory.KEYNOTE }),
    __metadata("design:type", String)
], Speaker.prototype, "category", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], Speaker.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: 'updated_at' }),
    __metadata("design:type", Date)
], Speaker.prototype, "updatedAt", void 0);
exports.Speaker = Speaker = __decorate([
    (0, typeorm_1.Entity)('speakers')
], Speaker);
//# sourceMappingURL=speaker.entity.js.map