import { NestFactory } from '@nestjs/core';
import { Logger, ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  const isProduction = process.env.NODE_ENV === 'production';
  const logger = new Logger('Bootstrap');
  const corsOrigin = process.env.CORS_ORIGIN;
  const originList = (corsOrigin || '')
    .split(',')
    .map((value) => value.trim())
    .filter(Boolean);
  const wildcardRequested = !corsOrigin || corsOrigin === '*';

  // In production, refuse wildcard/unset CORS — explicit allowlist required.
  if (isProduction && (wildcardRequested || originList.length === 0)) {
    logger.error(
      'CORS_ORIGIN must be set to an explicit allowlist in production. Refusing to start.',
    );
    process.exit(1);
  }

  const allowAnyOrigin = !isProduction && wildcardRequested;

  // CORS
  app.enableCors({
    origin: allowAnyOrigin ? true : originList,
    credentials: !allowAnyOrigin,
  });

  // Block direct access to the protected materials subdirectory. Materials
  // must be fetched via the authenticated endpoint (materials/:id/file).
  app.use('/uploads/materials', (_req, res) => {
    res.status(403).json({
      statusCode: 403,
      error: 'Forbidden',
      message:
        'Protected material. Use GET /api/v1/events/:eventId/materials/:id/file with Bearer token.',
    });
  });
  app.useStaticAssets(join(process.cwd(), 'uploads'), { prefix: '/uploads/' });
  app.useStaticAssets(join(process.cwd(), 'assets'), { prefix: '/assets/' });

  // Global exception filter
  app.useGlobalFilters(new AllExceptionsFilter());

  // Global prefix
  app.setGlobalPrefix(process.env.API_PREFIX || 'api/v1');

  // Validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  // Swagger
  const config = new DocumentBuilder()
    .setTitle('Conference API')
    .setDescription(
      [
        '会议管理系统接口文档。',
        '所有示例均为真实请求/响应格式，可直接按相同结构调用。',
        '除登录、发送验证码等公开接口外，其余需要在 Authorization 中传 Bearer Token。',
      ].join('\n'),
    )
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document, {
    customSiteTitle: 'Conference API Docs',
    swaggerOptions: {
      docExpansion: 'list',
      defaultModelsExpandDepth: -1,
      displayRequestDuration: true,
      filter: true,
      tryItOutEnabled: true,
    },
    customCss: `
      .swagger-ui .topbar { display: none; }
      .swagger-ui .scheme-container { box-shadow: none; padding: 12px 0; }
      .swagger-ui .info { margin: 20px 0; }
      .swagger-ui .info .title { font-size: 28px; font-weight: 700; }
      .swagger-ui .info .title small,
      .swagger-ui .info .link,
      .swagger-ui .info svg,
      .swagger-ui .opblock-summary svg,
      .swagger-ui .authorization__btn svg,
      .swagger-ui .btn.authorize svg,
      .swagger-ui .model-toggle::after {
        display: none !important;
      }
      .swagger-ui .opblock-summary-control { padding-left: 12px; }
      .swagger-ui .opblock-tag { border-bottom: 1px solid #e5e7eb; margin: 0; }
      .swagger-ui .responses-inner h4,
      .swagger-ui .responses-inner h5,
      .swagger-ui .opblock-description-wrapper p,
      .swagger-ui .opblock-external-docs-wrapper p,
      .swagger-ui .opblock-title_normal p {
        font-size: 14px;
      }
      .swagger-ui .markdown p,
      .swagger-ui .markdown pre,
      .swagger-ui .renderedMarkdown p {
        margin: 0 0 10px;
      }
      .swagger-ui .parameter__name,
      .swagger-ui .response-col_status {
        font-weight: 600;
      }
    `,
  });

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`Server running on port ${port}`);
  console.log(`API docs at /api/docs`);
}
bootstrap();
