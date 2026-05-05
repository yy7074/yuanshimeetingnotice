import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcryptjs from 'bcryptjs';
import { User } from '../users/entities/user.entity';
import {
  RegisterDto,
  LoginDto,
  ForgotPasswordDto,
  ResetPasswordDto,
} from './dto/register.dto';
import { EmailService } from '../common/email.service';

@Injectable()
export class AuthService {
  private verificationCodes = new Map<
    string,
    { code: string; expiresAt: number; count: number; lastSent: number }
  >();

  constructor(
    @InjectRepository(User)
    private userRepo: Repository<User>,
    private jwtService: JwtService,
    private emailService: EmailService,
  ) {}

  async register(dto: RegisterDto) {
    const existing = await this.userRepo.findOne({
      where: { email: dto.email },
    });
    if (existing) {
      throw new ConflictException('Email already registered');
    }

    const hashedPassword = await bcryptjs.hash(dto.password, 10);
    const user = this.userRepo.create({
      email: dto.email,
      password: hashedPassword,
      nameEn: dto.nameEn || '',
      nameZh: dto.nameZh || '',
    });

    await this.userRepo.save(user);
    const token = this.generateToken(user);

    return {
      user: this.sanitizeUser(user),
      token,
    };
  }

  async login(dto: LoginDto) {
    const user = await this.userRepo.findOne({ where: { email: dto.email } });
    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isMatch = await bcryptjs.compare(dto.password, user.password);
    if (!isMatch) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (!user.isActive) {
      throw new UnauthorizedException('Account is disabled');
    }

    const token = this.generateToken(user);
    return {
      user: this.sanitizeUser(user),
      token,
    };
  }

  async sendVerificationCode(email: string) {
    // Rate limiting: 1 per minute, 5 per day
    const existing = this.verificationCodes.get(email);
    if (existing) {
      if (Date.now() - existing.lastSent < 60000) {
        throw new BadRequestException(
          'Please wait 1 minute before requesting another code',
        );
      }
      if (existing.count >= 5) {
        throw new BadRequestException(
          'Daily verification code limit reached (5)',
        );
      }
    }

    const simulateVerification = this.isVerificationSimulationEnabled();
    const code = simulateVerification
      ? this.configuredSimulationCode()
      : Math.floor(100000 + Math.random() * 900000).toString();

    this.verificationCodes.set(email, {
      code,
      expiresAt: Date.now() + 5 * 60 * 1000,
      count: (existing?.count || 0) + 1,
      lastSent: Date.now(),
    });

    await this.emailService.sendVerificationCode(email, code);
    if (simulateVerification) {
      console.log(`[SIMULATED] Verification code for ${email}: ${code}`);
    } else {
      console.log(`[DEV] Verification code for ${email}: ${code}`);
    }
    return {
      message: 'Verification code sent.',
      code:
        process.env.NODE_ENV === 'development' || simulateVerification
          ? code
          : undefined,
      simulated: simulateVerification,
    };
  }

  async verifyCode(email: string, code: string) {
    const stored = this.verificationCodes.get(email);
    if (!stored || stored.code !== code || Date.now() > stored.expiresAt) {
      throw new BadRequestException('Invalid or expired verification code');
    }
    return true;
  }

  async registerWithCode(dto: RegisterDto & { code: string }) {
    await this.verifyCode(dto.email, dto.code);
    this.verificationCodes.delete(dto.email);
    return this.register(dto);
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    const user = await this.userRepo.findOne({ where: { email: dto.email } });
    if (!user) {
      return {
        message:
          'If this email is registered, a verification code has been sent.',
      };
    }
    return this.sendVerificationCode(dto.email);
  }

  async resetPassword(dto: ResetPasswordDto) {
    const stored = this.verificationCodes.get(dto.email);
    if (!stored || stored.code !== dto.code || Date.now() > stored.expiresAt) {
      throw new BadRequestException('Invalid or expired verification code');
    }

    const user = await this.userRepo.findOne({ where: { email: dto.email } });
    if (!user) {
      throw new BadRequestException('User not found');
    }

    user.password = await bcryptjs.hash(dto.newPassword, 10);
    user.tokenVersion = (user.tokenVersion ?? 0) + 1;
    user.mustChangePassword = false;
    await this.userRepo.save(user);
    this.verificationCodes.delete(dto.email);

    return { message: 'Password reset successfully.' };
  }

  async validateUser(userId: string): Promise<User | null> {
    return this.userRepo.findOne({ where: { id: userId } });
  }

  private generateToken(user: User): string {
    return this.jwtService.sign({
      sub: user.id,
      email: user.email,
      role: user.role,
      tv: user.tokenVersion ?? 0,
    });
  }

  private sanitizeUser(user: User) {
    const { password, ...result } = user;
    return result;
  }

  private isVerificationSimulationEnabled(): boolean {
    const configured = process.env.AUTH_SIMULATE_VERIFICATION;
    if (configured != null) {
      return configured === 'true';
    }
    return !this.emailService.isConfigured;
  }

  private configuredSimulationCode(): string {
    return process.env.AUTH_SIMULATED_CODE?.trim() || '0000';
  }
}
