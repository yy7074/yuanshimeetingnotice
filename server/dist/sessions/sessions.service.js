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
exports.SessionsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const session_entity_1 = require("./entities/session.entity");
let SessionsService = class SessionsService {
    sessionRepo;
    constructor(sessionRepo) {
        this.sessionRepo = sessionRepo;
    }
    async findByEvent(eventId) {
        return this.sessionRepo.find({
            where: { eventId },
            order: { dayIndex: 'ASC', startTime: 'ASC' },
            relations: ['speaker'],
        });
    }
    async findOne(id) {
        const session = await this.sessionRepo.findOne({ where: { id }, relations: ['speaker'] });
        if (!session)
            throw new common_1.NotFoundException('Session not found');
        return session;
    }
    async create(data) {
        const session = this.sessionRepo.create(data);
        return this.sessionRepo.save(session);
    }
    async update(id, data) {
        const session = await this.findOne(id);
        Object.assign(session, data);
        return this.sessionRepo.save(session);
    }
    async remove(id) {
        const session = await this.findOne(id);
        return this.sessionRepo.remove(session);
    }
};
exports.SessionsService = SessionsService;
exports.SessionsService = SessionsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(session_entity_1.Session)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], SessionsService);
//# sourceMappingURL=sessions.service.js.map