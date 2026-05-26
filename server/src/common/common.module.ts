import { Module, Global } from '@nestjs/common';
import { EmailService } from './email.service';
import { PushService } from './push.service';
import { UploadController } from './upload.controller';
import { HealthController } from './health.controller';
import { HomeBannersController } from './home-banners.controller';
import { HomeBannersService } from './home-banners.service';

@Global()
@Module({
  providers: [EmailService, PushService, HomeBannersService],
  controllers: [UploadController, HealthController, HomeBannersController],
  exports: [EmailService, PushService, HomeBannersService],
})
export class CommonModule {}
