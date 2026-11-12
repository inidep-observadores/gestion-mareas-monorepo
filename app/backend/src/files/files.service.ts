import { randomUUID } from 'crypto';
import { existsSync, mkdirSync } from 'fs';
import { join } from 'path';
// eslint-disable-next-line @typescript-eslint/no-require-imports
const sharp = require('sharp');

import { Injectable, BadRequestException } from '@nestjs/common';


@Injectable()
export class FilesService {

    getStaticProductImage(imageName: string) {

        const path = join(process.cwd(), 'static/products', imageName);

        if (!existsSync(path))
            throw new BadRequestException(`No product found with image ${imageName}`);

        return path;
    }

    getStaticUserImage(imageName: string) {

        const path = join(process.cwd(), 'static/users', imageName);

        if (!existsSync(path))
            throw new BadRequestException(`No user image found with name ${imageName}`);

        return path;
    }

    getStaticNovedadFile(fileName: string) {
        const path = join(process.cwd(), 'static/novedades', fileName);

        if (!existsSync(path))
            throw new BadRequestException(`No file found with name ${fileName}`);

        return path;
    }

    async saveAndResizeObservadorImage(fileBuffer: Buffer): Promise<string> {
        const uploadDir = join(process.cwd(), 'uploads/observadores');
        if (!existsSync(uploadDir)) {
            mkdirSync(uploadDir, { recursive: true });
        }

        const fileName = `${randomUUID()}.jpg`;
        const filePath = join(uploadDir, fileName);

        try {
            await sharp(fileBuffer)
                .rotate() // Respeta orientación EXIF si proviene de smartphone/cámara
                .resize(400, 400, {
                    fit: 'cover',
                    position: 'center',
                })
                .jpeg({
                    quality: 85,
                    mozjpeg: true,
                })
                .toFile(filePath);

            return fileName;
        } catch (error) {
            console.error('Error redimensionando imagen con sharp:', error);
            throw new BadRequestException('El archivo proporcionado no es una imagen válida o está dañado');
        }
    }

    getObservadorImage(imageName: string): string {
        const path = join(process.cwd(), 'uploads/observadores', imageName);

        if (!existsSync(path)) {
            throw new BadRequestException(`No se encontró la imagen del observador: ${imageName}`);
        }

        return path;
    }
}
