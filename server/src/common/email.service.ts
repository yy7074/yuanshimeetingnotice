import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class EmailService {
  private transporter: nodemailer.Transporter;

  constructor(private config: ConfigService) {
    const host = config.get('SMTP_HOST');
    if (host) {
      this.transporter = nodemailer.createTransport({
        host,
        port: config.get<number>('SMTP_PORT', 465),
        secure: true,
        auth: {
          user: config.get('SMTP_USER'),
          pass: config.get('SMTP_PASS'),
        },
      });
    }
  }

  async sendVerificationCode(email: string, code: string, lang: string = 'zh') {
    const subject = lang === 'zh' ? 'APSCVIR 验证码' : 'APSCVIR Verification Code';
    const html = lang === 'zh'
      ? `<h2>您的验证码</h2><p style="font-size:32px;font-weight:bold;color:#196EE6">${code}</p><p>验证码有效期5分钟。</p><p>— APSCVIR 会议管理平台</p>`
      : `<h2>Your Verification Code</h2><p style="font-size:32px;font-weight:bold;color:#196EE6">${code}</p><p>This code expires in 5 minutes.</p><p>— APSCVIR Conference Platform</p>`;

    return this.send(email, subject, html);
  }

  async sendInvitation(email: string, data: { eventNameEn: string; eventNameZh: string; inviteUrl: string }, lang: string = 'zh') {
    const subject = lang === 'zh'
      ? `您已被邀请参加 ${data.eventNameZh}`
      : `You are invited to ${data.eventNameEn}`;
    const html = lang === 'zh'
      ? `<h2>会议邀请</h2><p>您已被邀请参加 <strong>${data.eventNameZh}</strong>（${data.eventNameEn}）</p><p><a href="${data.inviteUrl}" style="background:#196EE6;color:white;padding:12px 24px;border-radius:8px;text-decoration:none">接受邀请</a></p><p>— APSCVIR 会议管理平台</p>`
      : `<h2>Conference Invitation</h2><p>You are invited to <strong>${data.eventNameEn}</strong></p><p><a href="${data.inviteUrl}" style="background:#196EE6;color:white;padding:12px 24px;border-radius:8px;text-decoration:none">Accept Invitation</a></p><p>— APSCVIR Conference Platform</p>`;

    return this.send(email, subject, html);
  }

  private async send(to: string, subject: string, html: string) {
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
    } catch (err) {
      console.error('Email send error:', err);
      return { success: false, error: (err as Error).message };
    }
  }
}
