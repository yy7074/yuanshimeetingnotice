"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ImportController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const roles_guard_1 = require("../auth/roles.guard");
const user_entity_1 = require("./entities/user.entity");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_2 = require("./entities/user.entity");
const bcryptjs = __importStar(require("bcryptjs"));
let ImportController = class ImportController {
    userRepo;
    constructor(userRepo) {
        this.userRepo = userRepo;
    }
    async importAttendees(body) {
        if (!body.attendees || !Array.isArray(body.attendees)) {
            throw new common_1.BadRequestException('attendees array is required');
        }
        const results = { created: 0, skipped: 0, errors: [] };
        const defaultPassword = await bcryptjs.hash('Welcome2026!', 10);
        for (const row of body.attendees) {
            if (!row.email) {
                results.errors.push(`Missing email in row`);
                continue;
            }
            const existing = await this.userRepo.findOne({ where: { email: row.email.toLowerCase().trim() } });
            if (existing) {
                results.skipped++;
                continue;
            }
            try {
                const user = this.userRepo.create({
                    email: row.email.toLowerCase().trim(),
                    password: defaultPassword,
                    nameEn: row.nameEn || '',
                    nameZh: row.nameZh || '',
                    role: row.role || user_entity_1.UserRole.ATTENDEE,
                    organizationEn: row.organizationEn || '',
                    organizationZh: row.organizationZh || '',
                });
                await this.userRepo.save(user);
                results.created++;
            }
            catch (e) {
                results.errors.push(`Failed to create ${row.email}: ${e.message}`);
            }
        }
        return results;
    }
    async exportUsers() {
        const users = await this.userRepo.find({ order: { createdAt: 'DESC' } });
        return users.map(u => ({
            email: u.email,
            nameEn: u.nameEn,
            nameZh: u.nameZh,
            role: u.role,
            organizationEn: u.organizationEn,
            organizationZh: u.organizationZh,
            isActive: u.isActive,
            createdAt: u.createdAt,
        }));
    }
};
exports.ImportController = ImportController;
__decorate([
    (0, common_1.Post)('import'),
    (0, swagger_1.ApiOperation)({ summary: 'Import attendees from JSON (parsed CSV/Excel on frontend)' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ImportController.prototype, "importAttendees", null);
__decorate([
    (0, common_1.Post)('export'),
    (0, swagger_1.ApiOperation)({ summary: 'Export all users as JSON' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ImportController.prototype, "exportUsers", null);
exports.ImportController = ImportController = __decorate([
    (0, swagger_1.ApiTags)('User Import'),
    (0, common_1.Controller)('users'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard, roles_guard_1.RolesGuard),
    (0, roles_guard_1.Roles)(user_entity_1.UserRole.ADMIN),
    (0, swagger_1.ApiBearerAuth)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_2.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], ImportController);
//# sourceMappingURL=import.controller.js.map