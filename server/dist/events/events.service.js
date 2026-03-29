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
exports.EventsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const event_entity_1 = require("./entities/event.entity");
const user_entity_1 = require("../users/entities/user.entity");
let EventsService = class EventsService {
    eventRepo;
    userRepo;
    constructor(eventRepo, userRepo) {
        this.eventRepo = eventRepo;
        this.userRepo = userRepo;
    }
    async findAll(query) {
        const qb = this.eventRepo.createQueryBuilder('event');
        if (query?.status) {
            qb.where('event.status = :status', { status: query.status });
        }
        if (query?.search) {
            qb.andWhere('(event.title_en LIKE :search OR event.title_zh LIKE :search OR event.location_en LIKE :search)', { search: `%${query.search}%` });
        }
        qb.orderBy('event.start_date', 'DESC');
        const events = await qb.getMany();
        const result = [];
        for (const event of events) {
            const count = await this.eventRepo
                .createQueryBuilder('e')
                .leftJoin('e.subscribers', 's')
                .where('e.id = :id', { id: event.id })
                .select('COUNT(s.id)', 'count')
                .getRawOne();
            result.push({ ...event, currentAttendees: parseInt(count?.count || '0') });
        }
        return result;
    }
    async findOne(id) {
        const event = await this.eventRepo.findOne({
            where: { id },
            relations: ['sessions', 'materials'],
        });
        if (!event)
            throw new common_1.NotFoundException('Event not found');
        return event;
    }
    async create(dto) {
        const event = this.eventRepo.create(dto);
        return this.eventRepo.save(event);
    }
    async update(id, dto) {
        const event = await this.findOne(id);
        Object.assign(event, dto);
        return this.eventRepo.save(event);
    }
    async remove(id) {
        const event = await this.findOne(id);
        return this.eventRepo.remove(event);
    }
    async subscribe(eventId, userId) {
        const user = await this.userRepo.findOne({
            where: { id: userId },
            relations: ['subscribedEvents'],
        });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        const event = await this.eventRepo.findOne({ where: { id: eventId } });
        if (!event)
            throw new common_1.NotFoundException('Event not found');
        const alreadySubscribed = user.subscribedEvents.some((e) => e.id === eventId);
        if (!alreadySubscribed) {
            user.subscribedEvents.push(event);
            await this.userRepo.save(user);
        }
        return { message: 'Subscribed successfully' };
    }
    async unsubscribe(eventId, userId) {
        const user = await this.userRepo.findOne({
            where: { id: userId },
            relations: ['subscribedEvents'],
        });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        user.subscribedEvents = user.subscribedEvents.filter((e) => e.id !== eventId);
        await this.userRepo.save(user);
        return { message: 'Unsubscribed successfully' };
    }
    async getMyEvents(userId) {
        const user = await this.userRepo.findOne({
            where: { id: userId },
            relations: ['subscribedEvents'],
        });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        return user.subscribedEvents;
    }
    async getStats() {
        const total = await this.eventRepo.count();
        const published = await this.eventRepo.count({ where: { status: 'published' } });
        const draft = await this.eventRepo.count({ where: { status: 'draft' } });
        return { total, published, draft };
    }
};
exports.EventsService = EventsService;
exports.EventsService = EventsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(event_entity_1.Event)),
    __param(1, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], EventsService);
//# sourceMappingURL=events.service.js.map