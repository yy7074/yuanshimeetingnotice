import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { Request } from 'express';
import { User } from '../../users/entities/user.entity';

// Paths the user can still reach while mustChangePassword=true.
// Stripped of API_PREFIX in canonical matchers.
const ALLOWED = [
  { method: 'POST', path: /^\/users\/change-password\/?$/ },
  { method: 'GET', path: /^\/users\/me\/?$/ },
  { method: 'GET', path: /^\/auth\/profile\/?$/ },
  { method: 'POST', path: /^\/auth\/logout\/?$/ },
  { method: 'GET', path: /^\/health\/?$/ },
];

@Injectable()
export class PasswordChangeRequiredGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest<Request & { user?: User }>();
    const user = req.user;
    if (!user || !user.mustChangePassword) {
      return true;
    }
    const prefix = (process.env.API_PREFIX || 'api/v1').replace(/^\/+|\/+$/g, '');
    const fullPath = req.path || req.originalUrl || '';
    const stripped = fullPath
      .replace(new RegExp(`^/?${prefix}`), '')
      .split('?')[0];
    for (const rule of ALLOWED) {
      if (req.method === rule.method && rule.path.test(stripped)) {
        return true;
      }
    }
    throw new ForbiddenException({
      code: 'PASSWORD_CHANGE_REQUIRED',
      message: 'You must change your password before continuing.',
    });
  }
}
