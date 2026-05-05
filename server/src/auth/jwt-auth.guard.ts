import { ExecutionContext, Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { PasswordChangeRequiredGuard } from '../common/guards/password-change-required.guard';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  private readonly passwordGuard = new PasswordChangeRequiredGuard();

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const authed = (await super.canActivate(context)) as boolean;
    if (!authed) return false;
    return this.passwordGuard.canActivate(context);
  }
}
