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
Object.defineProperty(exports, "__esModule", { value: true });
exports.EmailService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const nodemailer = __importStar(require("nodemailer"));
let EmailService = class EmailService {
    config;
    transporter;
    constructor(config) {
        this.config = config;
        const host = config.get('SMTP_HOST');
        if (host) {
            this.transporter = nodemailer.createTransport({
                host,
                port: config.get('SMTP_PORT', 465),
                secure: true,
                auth: {
                    user: config.get('SMTP_USER'),
                    pass: config.get('SMTP_PASS'),
                },
            });
        }
    }
    async sendVerificationCode(email, code, lang = 'zh') {
        const subject = lang === 'zh' ? 'APSCVIR 验证码' : 'APSCVIR Verification Code';
        const html = lang === 'zh'
            ? `<h2>您的验证码</h2><p style="font-size:32px;font-weight:bold;color:#196EE6">${code}</p><p>验证码有效期5分钟。</p><p>— APSCVIR 会议管理平台</p>`
            : `<h2>Your Verification Code</h2><p style="font-size:32px;font-weight:bold;color:#196EE6">${code}</p><p>This code expires in 5 minutes.</p><p>— APSCVIR Conference Platform</p>`;
        return this.send(email, subject, html);
    }
    async sendInvitation(email, data, lang = 'zh') {
        const subject = lang === 'zh'
            ? `您已被邀请参加 ${data.eventNameZh}`
            : `You are invited to ${data.eventNameEn}`;
        const html = lang === 'zh'
            ? `<h2>会议邀请</h2><p>您已被邀请参加 <strong>${data.eventNameZh}</strong>（${data.eventNameEn}）</p><p><a href="${data.inviteUrl}" style="background:#196EE6;color:white;padding:12px 24px;border-radius:8px;text-decoration:none">接受邀请</a></p><p>— APSCVIR 会议管理平台</p>`
            : `<h2>Conference Invitation</h2><p>You are invited to <strong>${data.eventNameEn}</strong></p><p><a href="${data.inviteUrl}" style="background:#196EE6;color:white;padding:12px 24px;border-radius:8px;text-decoration:none">Accept Invitation</a></p><p>— APSCVIR Conference Platform</p>`;
        return this.send(email, subject, html);
    }
    async send(to, subject, html) {
        if (!this.transporter) {
            console.log(`[DEV EMAIL] To: ${to} | Subject: ${subject}`);
            console.log(`[DEV EMAIL] Body: ${html.replace(/<[^>]+>/g, '')}`);
            return { success: true, dev: true };
        }
        try {
            const result = await this.transporter.sendMail({
                from: this.config.get('SMTP_FROM', 'noreply@apscvir.org'),
                to,
                subject,
                html,
            });
            return { success: true, messageId: result.messageId };
        }
        catch (err) {
            console.error('Email send error:', err);
            return { success: false, error: err.message };
        }
    }
};
exports.EmailService = EmailService;
exports.EmailService = EmailService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], EmailService);
//# sourceMappingURL=email.service.js.map