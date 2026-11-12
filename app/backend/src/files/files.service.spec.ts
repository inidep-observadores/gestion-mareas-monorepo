import { Test, TestingModule } from '@nestjs/testing';
import { FilesService } from './files.service';
// eslint-disable-next-line @typescript-eslint/no-require-imports
const sharp = require('sharp');
import * as fs from 'fs';

describe('FilesService - Observador Photo Resize', () => {
    let service: FilesService;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [FilesService],
        }).compile();

        service = module.get<FilesService>(FilesService);
    });

    it('debe redimensionar y guardar una imagen a 400x400 en formato jpg', async () => {
        // Crear una imagen de prueba en memoria de 800x600 usando sharp
        const testImageBuffer = await sharp({
            create: {
                width: 800,
                height: 600,
                channels: 3,
                background: { r: 255, g: 0, b: 0 }
            }
        })
        .png()
        .toBuffer();

        const fileName = await service.saveAndResizeObservadorImage(testImageBuffer);
        expect(fileName).toBeDefined();
        expect(fileName.endsWith('.jpg')).toBe(true);

        const filePath = service.getObservadorImage(fileName);
        expect(fs.existsSync(filePath)).toBe(true);

        // Verificar dimensiones finales con sharp metadata
        const metadata = await sharp(filePath).metadata();
        expect(metadata.width).toBe(400);
        expect(metadata.height).toBe(400);
        expect(metadata.format).toBe('jpeg');

        // Limpiar archivo de prueba generado
        fs.unlinkSync(filePath);
    }, 30000);
});
