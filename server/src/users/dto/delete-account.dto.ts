import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class DeleteAccountDto {
  @ApiProperty({ example: 'CurrentPassw0rd123' })
  @IsString()
  @MinLength(8)
  password: string;
}
