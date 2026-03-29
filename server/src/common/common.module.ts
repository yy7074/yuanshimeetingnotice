import { Module, Global } from '@nestjs/common';
import { EmailService } from './email.service';
import { PushService } from './push.service';
import { UploadController } from './upload.controller';

@Global()
@Module({
  providers: [EmailService, PushService],
  controllers: [UploadController],
  exports: [EmailService, PushService],
})
export class CommonModule {}
