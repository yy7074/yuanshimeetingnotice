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
exports.CheckInService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const check_in_entity_1 = require("./entities/check-in.entity");
const uuid_1 = require("uuid");
let CheckInService = class CheckInService {
    checkInRepo;
    constructor(checkInRepo) {
        this.checkInRepo = checkInRepo;
    }
    async generateQrCode(userId, eventId) {
        const code = `${userId}:${eventId}:${(0, uuid_1.v4)()}:${Date.now()}`;
        return { qrCode: code, expiresIn: 30 };
    }
    async verify(qrCode) {
        const parts = qrCode.split(':');
        if (parts.length < 3) {
            throw new common_1.BadRequestException('Invalid QR code');
        }
        const [userId, eventId] = parts;
        const timestamp = parseInt(parts[3] || '0');
        if (Date.now() - timestamp > 30000) {
            throw new common_1.BadRequestException('QR code expired');
        }
        const existing = await this.checkInRepo.findOne({
            where: { userId, eventId, checkedIn: true },
        });
        if (existing) {
            return { message: 'Already checked in', checkIn: existing };
        }
        const checkIn = this.checkInRepo.create({
            userId,
            eventId,
            qrCode,
            checkedIn: true,
        });
        await this.checkInRepo.save(checkIn);
        return { message: 'Check-in successful', checkIn };
    }
    async getCheckIns(eventId) {
        return this.checkInRepo.find({
            where: { eventId, checkedIn: true },
            relations: ['user'],
            order: { checkedInAt: 'DESC' },
        });
    }
    async getStats(eventId) {
        const total = await this.checkInRepo.count({ where: { eventId, checkedIn: true } });
        return { eventId, checkedInCount: total };
    }
};
exports.CheckInService = CheckInService;
exports.CheckInService = CheckInService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(check_in_entity_1.CheckIn)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], CheckInService);
//# sourceMappingURL=check-in.service.js.map