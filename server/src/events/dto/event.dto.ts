import { IsString, IsOptional, IsDateString, IsBoolean, IsNumber, IsEnum, IsArray } from 'class-validator';
import { ApiProperty, PartialType } from '@nestjs/swagger';
import { EventStatus } from '../entities/event.entity';

export class CreateEventDto {
  @ApiProperty() @IsString() titleEn: string;
  @ApiProperty() @IsString() titleZh: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() descriptionEn?: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() descriptionZh?: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() locationEn?: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() locationZh?: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() imageUrl?: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() bannerUrl?: string;
  @ApiProperty() @IsDateString() startDate: string;
  @ApiProperty() @IsDateString() endDate: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() organizerEn?: string;
  @ApiProperty({ required: false }) @IsOptional() @IsString() organizerZh?: string;
  @ApiProperty({ required: false }) @IsOptional() @IsArray() tags?: string[];
  @ApiProperty({ required: false }) @IsOptional() @IsBoolean() isFeatured?: boolean;
  @ApiProperty({ required: false }) @IsOptional() @IsNumber() maxAttendees?: number;
  @ApiProperty({ required: false, enum: EventStatus }) @IsOptional() @IsEnum(EventStatus) status?: EventStatus;
}

export class UpdateEventDto extends PartialType(CreateEventDto) {}
