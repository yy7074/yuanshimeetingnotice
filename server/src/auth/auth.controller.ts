import {
  Controller,
  Post,
  Body,
  Get,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiBody,
  ApiOkResponse,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { AuthService } from './auth.service';
import {
  RegisterDto,
  LoginDto,
  ForgotPasswordDto,
  ResetPasswordDto,
} from './dto/register.dto';
import { JwtAuthGuard } from './jwt-auth.guard';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('send-code')
  @Throttle({
    short: { limit: 2, ttl: 60_000 },
    long: { limit: 20, ttl: 3_600_000 },
  })
  @ApiOperation({ summary: 'Send verification code to email' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['email'],
      properties: {
        email: { type: 'string', format: 'email', example: 'attendee@apscvir.org' },
      },
    },
  })
  @ApiOkResponse({
    description: 'Verification code has been sent',
    schema: {
      example: {
        message: 'Verification code sent.',
        code: '0000',
        simulated: true,
      },
    },
  })
  sendCode(@Body('email') email: string) {
    return this.authService.sendVerificationCode(email);
  }

  @Post('register')
  @Throttle({ short: { limit: 5, ttl: 60_000 } })
  @ApiOperation({ summary: 'Register with email + verification code' })
  @ApiBody({
    schema: {
      type: 'object',
      required: ['email', 'password', 'code'],
      properties: {
        email: { type: 'string', format: 'email', example: 'attendee@apscvir.org' },
        password: { type: 'string', example: 'Passw0rd123' },
        code: { type: 'string', example: '0000' },
        nameEn: { type: 'string', example: 'Dr. Alice Chen' },
        nameZh: { type: 'string', example: '陈爱丽' },
      },
    },
  })
  @ApiOkResponse({
    description: 'Registration succeeded',
    schema: {
      example: {
        user: {
          id: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
          email: 'attendee@apscvir.org',
          nameEn: 'Dr. Alice Chen',
          nameZh: '陈爱丽',
          titleEn: '',
          titleZh: '',
          organizationEn: '',
          organizationZh: '',
          avatarUrl: '',
          role: 'attendee',
          isActive: true,
          pushEnabled: true,
          language: 'zh',
          fcmToken: null,
          createdAt: '2026-04-15T10:30:00.000Z',
          updatedAt: '2026-04-15T10:30:00.000Z',
        },
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.example',
      },
    },
  })
  register(@Body() dto: RegisterDto & { code: string }) {
    if (dto.code) {
      return this.authService.registerWithCode(dto);
    }
    return this.authService.register(dto);
  }

  @Post('login')
  @Throttle({
    short: { limit: 10, ttl: 60_000 },
    long: { limit: 60, ttl: 3_600_000 },
  })
  @ApiOperation({ summary: 'Login with email and password' })
  @ApiOkResponse({
    description: 'Login succeeded',
    schema: {
      example: {
        user: {
          id: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
          email: 'attendee@apscvir.org',
          role: 'attendee',
          language: 'zh',
          pushEnabled: true,
        },
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.example',
      },
    },
  })
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('forgot-password')
  @Throttle({
    short: { limit: 2, ttl: 60_000 },
    long: { limit: 10, ttl: 3_600_000 },
  })
  @ApiOperation({ summary: 'Request password reset code' })
  @ApiOkResponse({
    description: 'Reset code request accepted',
    schema: {
      example: {
        message: 'Verification code sent.',
        code: '0000',
        simulated: true,
      },
    },
  })
  forgotPassword(@Body() dto: ForgotPasswordDto) {
    return this.authService.forgotPassword(dto);
  }

  @Post('reset-password')
  @Throttle({ short: { limit: 5, ttl: 60_000 } })
  @ApiOperation({ summary: 'Reset password with verification code' })
  @ApiOkResponse({
    description: 'Password has been reset',
    schema: {
      example: {
        message: 'Password reset successfully.',
      },
    },
  })
  resetPassword(@Body() dto: ResetPasswordDto) {
    return this.authService.resetPassword(dto);
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get current user profile' })
  @ApiOkResponse({
    description: 'Current user profile',
    schema: {
      example: {
        id: '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
        email: 'attendee@apscvir.org',
        nameEn: 'Dr. Alice Chen',
        nameZh: '陈爱丽',
        role: 'attendee',
        pushEnabled: true,
        language: 'zh',
      },
    },
  })
  getProfile(@Request() req) {
    const { password, ...user } = req.user;
    return user;
  }
}
