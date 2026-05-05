import { ApiProperty } from '@nestjs/swagger';
import { ArrayMinSize, IsArray, IsEnum, IsString } from 'class-validator';
import { UserRole } from '../entities/user.entity';

export class BatchUpdateUserRoleDto {
  @ApiProperty({
    example: [
      '2fc4f2ff-f9b3-4f7e-83d7-1b4c632f4ea1',
      '4060d1a4-b2a2-4098-86c9-36f2c41dbd2b',
    ],
  })
  @IsArray()
  @ArrayMinSize(1)
  @IsString({ each: true })
  userIds: string[];

  @ApiProperty({
    enum: UserRole,
    example: UserRole.SPEAKER,
  })
  @IsEnum(UserRole)
  role: UserRole;
}
