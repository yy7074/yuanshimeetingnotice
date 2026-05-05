import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    configService: ConfigService,
    private authService: AuthService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET') || 'default-secret',
    });
  }

  async validate(payload: {
    sub: string;
    email: string;
    role: string;
    tv?: number;
  }) {
    const user = await this.authService.validateUser(payload.sub);
    if (!user) {
      throw new UnauthorizedException();
    }
    if (!user.isActive) {
      throw new UnauthorizedException('Account is disabled');
    }
    const currentVersion = user.tokenVersion ?? 0;
    const tokenVersion = payload.tv ?? 0;
    if (tokenVersion !== currentVersion) {
      throw new UnauthorizedException('Token has been revoked');
    }
    return user;
  }
}
