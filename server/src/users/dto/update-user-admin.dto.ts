import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEmail,
  IsIn,
  IsOptional,
  IsString,
} from 'class-validator';

export class UpdateUserAdminDto {
  @ApiPropertyOptional({ example: 'attendee@apscvir.org' })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({ example: 'Dr. Alice Chen' })
  @IsOptional()
  @IsString()
  nameEn?: string;

  @ApiPropertyOptional({ example: '陈爱丽' })
  @IsOptional()
  @IsString()
  nameZh?: string;

  @ApiPropertyOptional({ example: 'Chief Physician' })
  @IsOptional()
  @IsString()
  titleEn?: string;

  @ApiPropertyOptional({ example: '主任医师' })
  @IsOptional()
  @IsString()
  titleZh?: string;

  @ApiPropertyOptional({ example: 'APSCVIR' })
  @IsOptional()
  @IsString()
  organizationEn?: string;

  @ApiPropertyOptional({ example: '亚太介入放射学会' })
  @IsOptional()
  @IsString()
  organizationZh?: string;

  @ApiPropertyOptional({ example: 'https://example.com/avatar.jpg' })
  @IsOptional()
  @IsString()
  avatarUrl?: string;

  @ApiPropertyOptional({ example: 'zh', enum: ['zh', 'en'] })
  @IsOptional()
  @IsIn(['zh', 'en'])
  language?: string;

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean()
  pushEnabled?: boolean;
}
