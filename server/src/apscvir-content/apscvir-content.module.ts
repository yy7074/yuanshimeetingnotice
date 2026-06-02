import { Module } from '@nestjs/common';
import { ApscvirContentController } from './apscvir-content.controller';
import { ApscvirContentService } from './apscvir-content.service';

@Module({
  controllers: [ApscvirContentController],
  providers: [ApscvirContentService],
  exports: [ApscvirContentService],
})
export class ApscvirContentModule {}
