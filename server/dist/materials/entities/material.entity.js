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
exports.Material = exports.MaterialType = void 0;
const typeorm_1 = require("typeorm");
const event_entity_1 = require("../../events/entities/event.entity");
var MaterialType;
(function (MaterialType) {
    MaterialType["PDF"] = "pdf";
    MaterialType["PPT"] = "ppt";
    MaterialType["IMAGE"] = "image";
    MaterialType["OTHER"] = "other";
})(MaterialType || (exports.MaterialType = MaterialType = {}));
let Material = class Material {
    id;
    nameEn;
    nameZh;
    fileUrl;
    fileSize;
    type;
    visibleTo;
    downloadCount;
    event;
    eventId;
    sessionId;
    createdAt;
    updatedAt;
};
exports.Material = Material;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], Material.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'name_en' }),
    __metadata("design:type", String)
], Material.prototype, "nameEn", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'name_zh' }),
    __metadata("design:type", String)
], Material.prototype, "nameZh", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'file_url' }),
    __metadata("design:type", String)
], Material.prototype, "fileUrl", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'file_size', default: 0 }),
    __metadata("design:type", Number)
], Material.prototype, "fileSize", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'varchar', default: MaterialType.PDF }),
    __metadata("design:type", String)
], Material.prototype, "type", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'visible_to', type: 'simple-array', default: 'attendee,speaker,vip,admin' }),
    __metadata("design:type", Array)
], Material.prototype, "visibleTo", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'download_count', default: 0 }),
    __metadata("design:type", Number)
], Material.prototype, "downloadCount", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => event_entity_1.Event, (event) => event.materials, { onDelete: 'CASCADE' }),
    (0, typeorm_1.JoinColumn)({ name: 'event_id' }),
    __metadata("design:type", event_entity_1.Event)
], Material.prototype, "event", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'event_id' }),
    __metadata("design:type", String)
], Material.prototype, "eventId", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'session_id', nullable: true }),
    __metadata("design:type", String)
], Material.prototype, "sessionId", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], Material.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)({ name: 'updated_at' }),
    __metadata("design:type", Date)
], Material.prototype, "updatedAt", void 0);
exports.Material = Material = __decorate([
    (0, typeorm_1.Entity)('materials')
], Material);
//# sourceMappingURL=material.entity.js.map