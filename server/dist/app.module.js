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
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const auth_module_1 = require("./auth/auth.module");
const users_module_1 = require("./users/users.module");
const events_module_1 = require("./events/events.module");
const sessions_module_1 = require("./sessions/sessions.module");
const speakers_module_1 = require("./speakers/speakers.module");
const materials_module_1 = require("./materials/materials.module");
const check_in_module_1 = require("./check-in/check-in.module");
const notifications_module_1 = require("./notifications/notifications.module");
const common_module_1 = require("./common/common.module");
const seed_1 = require("./database/seed");
let AppModule = class AppModule {
    dataSource;
    constructor(dataSource) {
        this.dataSource = dataSource;
    }
    async onModuleInit() {
        await (0, seed_1.seedDatabase)(this.dataSource);
    }
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({ isGlobal: true }),
            typeorm_1.TypeOrmModule.forRootAsync({
                imports: [config_1.ConfigModule],
                inject: [config_1.ConfigService],
                useFactory: (config) => {
                    const dbType = config.get('DB_TYPE', 'sqlite');
                    if (dbType === 'postgres') {
                        return {
                            type: 'postgres',
                            host: config.get('DB_HOST', 'localhost'),
                            port: config.get('DB_PORT', 5432),
                            username: config.get('DB_USERNAME', 'postgres'),
                            password: config.get('DB_PASSWORD', 'postgres'),
                            database: config.get('DB_DATABASE', 'conference_app'),
                            autoLoadEntities: true,
                            synchronize: true,
                        };
                    }
                    return {
                        type: 'better-sqlite3',
                        database: config.get('DB_DATABASE', 'conference.db'),
                        autoLoadEntities: true,
                        synchronize: true,
                    };
                },
            }),
            common_module_1.CommonModule,
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            events_module_1.EventsModule,
            sessions_module_1.SessionsModule,
            speakers_module_1.SpeakersModule,
            materials_module_1.MaterialsModule,
            check_in_module_1.CheckInModule,
            notifications_module_1.NotificationsModule,
        ],
    }),
    __metadata("design:paramtypes", [typeorm_2.DataSource])
], AppModule);
//# sourceMappingURL=app.module.js.map