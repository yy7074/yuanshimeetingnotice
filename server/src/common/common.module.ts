import { Module, Global } from '@nestjs/common';
import { EmailService } from './email.service';
import { PushService } from './push.service';
import { UploadController } from './upload.controller';
import { HealthController } from './health.controller';

@Global()
@Module({
  providers: [EmailService, PushService],
  controllers: [UploadController, HealthController],
  exports: [EmailService, PushService],
})
export class CommonModule {}
