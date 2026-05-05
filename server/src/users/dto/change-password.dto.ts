import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class ChangePasswordDto {
  @ApiProperty({ example: 'OldPassw0rd123' })
  @IsString()
  currentPassword: string;

  @ApiProperty({ example: 'NewPassw0rd456' })
  @IsString()
  @MinLength(8)
  newPassword: string;
}
