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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("./entities/user.entity");
let UsersService = class UsersService {
    userRepo;
    constructor(userRepo) {
        this.userRepo = userRepo;
    }
    async findAll(query) {
        const qb = this.userRepo.createQueryBuilder('user');
        if (query?.role) {
            qb.where('user.role = :role', { role: query.role });
        }
        if (query?.search) {
            qb.andWhere('(user.email LIKE :q OR user.name_en LIKE :q OR user.name_zh LIKE :q)', { q: `%${query.search}%` });
        }
        qb.orderBy('user.created_at', 'DESC');
        return qb.getMany();
    }
    async findOne(id) {
        const user = await this.userRepo.findOne({ where: { id } });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        return user;
    }
    async updateProfile(id, data) {
        const user = await this.findOne(id);
        const { password, role, email, ...safeData } = data;
        Object.assign(user, safeData);
        return this.userRepo.save(user);
    }
    async updateRole(id, role) {
        const user = await this.findOne(id);
        user.role = role;
        return this.userRepo.save(user);
    }
    async deactivate(id) {
        const user = await this.findOne(id);
        user.isActive = false;
        return this.userRepo.save(user);
    }
    async getStats() {
        const total = await this.userRepo.count();
        const active = await this.userRepo.count({ where: { isActive: true } });
        const vip = await this.userRepo.count({ where: { role: 'vip' } });
        return { total, active, vip };
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], UsersService);
//# sourceMappingURL=users.service.js.map