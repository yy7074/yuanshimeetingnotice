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
exports.SpeakersService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const speaker_entity_1 = require("./entities/speaker.entity");
let SpeakersService = class SpeakersService {
    speakerRepo;
    constructor(speakerRepo) {
        this.speakerRepo = speakerRepo;
    }
    async findAll(search) {
        if (search) {
            return this.speakerRepo
                .createQueryBuilder('s')
                .where('s.name_en LIKE :q OR s.name_zh LIKE :q OR s.organization_en LIKE :q', { q: `%${search}%` })
                .orderBy('s.category', 'ASC')
                .getMany();
        }
        return this.speakerRepo.find({ order: { category: 'ASC' } });
    }
    async findOne(id) {
        const speaker = await this.speakerRepo.findOne({ where: { id } });
        if (!speaker)
            throw new common_1.NotFoundException('Speaker not found');
        return speaker;
    }
    async create(data) {
        const speaker = this.speakerRepo.create(data);
        return this.speakerRepo.save(speaker);
    }
    async update(id, data) {
        const speaker = await this.findOne(id);
        Object.assign(speaker, data);
        return this.speakerRepo.save(speaker);
    }
    async remove(id) {
        const speaker = await this.findOne(id);
        return this.speakerRepo.remove(speaker);
    }
};
exports.SpeakersService = SpeakersService;
exports.SpeakersService = SpeakersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(speaker_entity_1.Speaker)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], SpeakersService);
//# sourceMappingURL=speakers.service.js.map