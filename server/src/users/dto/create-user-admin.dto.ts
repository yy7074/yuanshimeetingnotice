import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEmail,
  IsIn,
  IsOptional,
  IsString,
  MinLength,
} from 'class-validator';
import { UserRole } from '../entities/user.entity';

export class CreateUserAdminDto {
  @ApiProperty({ example: 'attendee@apscvir.org' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'Welcome2026!' })
  @IsString()
  @MinLength(8)
  password: string;

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

  @ApiPropertyOptional({ enum: UserRole, example: UserRole.ATTENDEE })
  @IsOptional()
  @IsIn(Object.values(UserRole))
  role?: UserRole;

  @ApiPropertyOptional({ example: 'zh', enum: ['zh', 'en'] })
  @IsOptional()
  @IsIn(['zh', 'en'])
  language?: string;

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean()
  pushEnabled?: boolean;
}
