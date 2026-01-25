"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const common_1 = require("@nestjs/common");
const app_module_1 = require("./app.module");
const cookieParser = require("cookie-parser");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    const logger = new common_1.Logger('Bootstrap');
    console.log('>>> BACKEND STARTING - Build ID: ' + new Date().toISOString());
    app.setGlobalPrefix('api');
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
    }));
    app.use(cookieParser());
    const frontendUrl = process.env.FRONTEND_URL;
    const rawOrigins = [
        'http://localhost:5173',
        'http://127.0.0.1:5173',
        'http://localhost:5174',
        'http://127.0.0.1:5174',
        'https://mareas-obs.netlify.app',
    ];
    if (frontendUrl) {
        frontendUrl.split(',').forEach(url => {
            const trimmed = url.trim();
            if (trimmed)
                rawOrigins.push(trimmed);
        });
    }
    const cleanOrigins = [...new Set(rawOrigins.map(url => url.replace(/\/$/, '')))];
    logger.log(`CORS enabled for origins: ${cleanOrigins.join(', ')}`);
    app.enableCors({
        origin: cleanOrigins,
        credentials: true,
        methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
        allowedHeaders: 'Content-Type, Accept, Authorization',
    });
    await app.listen(process.env.PORT || 3000);
    logger.log(`App running on port ${process.env.PORT || 3000}`);
}
bootstrap().catch(err => {
    console.error('CRITICAL ERROR DURING BOOTSTRAP:', err);
    process.exit(1);
});
//# sourceMappingURL=main.js.map