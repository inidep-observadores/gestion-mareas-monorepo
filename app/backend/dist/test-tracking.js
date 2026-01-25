"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const app_module_1 = require("./src/app.module");
const tracking_service_1 = require("./src/mareas/tracking.service");
const fs = require("fs");
const path = require("path");
async function bootstrap() {
    const app = await core_1.NestFactory.createApplicationContext(app_module_1.AppModule);
    const trackingService = app.get(tracking_service_1.TrackingService);
    const csvPath = path.join(__dirname, 'old_data', 'tack_miss_tide.csv');
    console.log(`Leyendo archivo: ${csvPath}`);
    if (!fs.existsSync(csvPath)) {
        console.error('El archivo no existe.');
        process.exit(1);
    }
    const fileBuffer = fs.readFileSync(csvPath);
    try {
        console.log('Iniciando importación...');
        const result = await trackingService.importTrackingData(fileBuffer);
        console.log('Resultado:', result);
    }
    catch (error) {
        console.error('Error durante la importación:', error);
    }
    finally {
        await app.close();
    }
}
bootstrap();
//# sourceMappingURL=test-tracking.js.map