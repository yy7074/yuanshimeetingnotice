import {
  Controller,
  Post,
  Query,
  UseInterceptors,
  UploadedFile,
  UseGuards,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiConsumes,
  ApiQuery,
} from '@nestjs/swagger';
import { diskStorage } from 'multer';
import { extname, join } from 'path';
import { v4 as uuidv4 } from 'uuid';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { existsSync, mkdirSync } from 'fs';

const uploadRoot = join(process.cwd(), 'uploads');
const materialsDir = join(uploadRoot, 'materials');
if (!existsSync(uploadRoot)) mkdirSync(uploadRoot, { recursive: true });
if (!existsSync(materialsDir)) mkdirSync(materialsDir, { recursive: true });

@ApiTags('Upload')
@Controller('upload')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class UploadController {
  @Post('file')
  @ApiOperation({ summary: 'Upload a file' })
  @ApiConsumes('multipart/form-data')
  @ApiQuery({
    name: 'target',
    required: false,
    enum: ['public', 'material'],
    description:
      "Use 'material' for protected downloads (served via authenticated endpoint). Defaults to 'public'.",
  })
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: (req, file, cb) => {
          const target =
            (req.query?.target as string | undefined) === 'material'
              ? materialsDir
              : uploadRoot;
          cb(null, target);
        },
        filename: (req, file, cb) => {
          const uniqueName = `${uuidv4()}${extname(file.originalname)}`;
          cb(null, uniqueName);
        },
      }),
      limits: { fileSize: 500 * 1024 * 1024 }, // 500MB
      fileFilter: (req, file, cb) => {
        const allowed = /\.(pdf|pptx?|docx?|xlsx?|csv|png|jpe?g|gif|webp)$/i;
        if (!allowed.test(extname(file.originalname))) {
          return cb(new BadRequestException('File type not allowed'), false);
        }
        cb(null, true);
      },
    }),
  )
  uploadFile(
    @UploadedFile() file: Express.Multer.File,
    @Query('target') target?: string,
  ) {
    if (!file) throw new BadRequestException('No file uploaded');
    const isMaterial = target === 'material';
    return {
      // For materials, persist this identifier as Material.fileUrl. The client
      // must fetch via GET /api/v1/materials/:id/file (auth + permission).
      url: isMaterial
        ? `uploads/materials/${file.filename}`
        : `/uploads/${file.filename}`,
      filename: file.filename,
      storage: isMaterial ? 'material' : 'public',
      originalName: file.originalname,
      size: file.size,
      mimetype: file.mimetype,
    };
  }
}
