import { Controller, Get, Post, Param, UploadedFile, UseInterceptors, BadRequestException, Res } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { diskStorage, memoryStorage } from 'multer';
import { FilesService } from './files.service';
import { DriveStorageService } from './drive-storage.service';

import { fileFilter, fileNamer } from './helpers';


@Controller('files')
export class FilesController {
    constructor(
        private readonly filesService: FilesService,
        private readonly configService: ConfigService,
        private readonly driveStorageService: DriveStorageService,
    ) { }

  @Get('product/:imageName')
  findProductImage(
    @Res() res: Response,
    @Param('imageName') imageName: string
  ) {

    const path = this.filesService.getStaticProductImage(imageName);

    res.sendFile(path);
  }

  @Get('users/:imageName')
  findUserImage(
    @Res() res: Response,
    @Param('imageName') imageName: string
  ) {

    const path = this.filesService.getStaticUserImage(imageName);

    res.sendFile(path);
  }

  @Post('product')
  @UseInterceptors(FileInterceptor('file', {
    fileFilter: fileFilter,
    storage: diskStorage({
      destination: './static/products',
      filename: fileNamer
    })
  }))
  uploadProductImage(
    @UploadedFile() file: Express.Multer.File,
  ) {

    if (!file) {
      throw new BadRequestException('Make sure that the file is an image');
    }

    const secureUrl = `${this.configService.get('HOST_API')}/files/product/${file.filename}`;

    return { secureUrl };
  }

    @Post('user')
    @UseInterceptors(FileInterceptor('file', {
        fileFilter: fileFilter,
        storage: diskStorage({
            destination: './static/users',
            filename: fileNamer
        })
    }))
    uploadUserImage(
        @UploadedFile() file: Express.Multer.File,
    ) {
        if (!file) {
            throw new BadRequestException('Make sure that the file is an image');
        }

        const secureUrl = `/api/files/users/${file.filename}`;
        return { secureUrl };
    }

    @Post('novedad/drive')
    @UseInterceptors(FileInterceptor('file', {
        storage: memoryStorage(),
        fileFilter: (req, file, cb) => {
            if (file.mimetype.startsWith('image/') || file.mimetype === 'application/pdf') {
                cb(null, true);
            } else {
                cb(new BadRequestException('Solo se permiten imágenes y archivos PDF'), false);
            }
        }
    }))
    async uploadNovedadFile(
        @UploadedFile() file: Express.Multer.File,
    ) {
        if (!file) {
            throw new BadRequestException('El archivo es requerido');
        }

        const result = await this.driveStorageService.uploadFile(
            file.originalname,
            file.mimetype,
            file.buffer
        );

        return { 
            secureUrl: result.webViewLink,
            driveFileId: result.fileId,
            originalName: file.originalname,
            mimetype: file.mimetype
        };
    }

    @Get('observadores/:imageName')
    findObservadorImage(
        @Res() res: Response,
        @Param('imageName') imageName: string,
    ) {
        const path = this.filesService.getObservadorImage(imageName);
        res.sendFile(path);
    }

    @Post('observador')
    @UseInterceptors(FileInterceptor('file', {
        storage: memoryStorage(),
        fileFilter: (req, file, cb) => {
            if (!file.mimetype.startsWith('image/')) {
                return cb(new BadRequestException('Solo se permiten archivos de imagen (JPG, PNG, WebP)'), false);
            }
            cb(null, true);
        },
        limits: {
            fileSize: 10 * 1024 * 1024, // 10MB límite máximo de subida antes de comprimir
        },
    }))
    async uploadObservadorImage(
        @UploadedFile() file: Express.Multer.File,
    ) {
        if (!file) {
            throw new BadRequestException('Debe proporcionar un archivo de imagen');
        }

        const fileName = await this.filesService.saveAndResizeObservadorImage(file.buffer);
        const secureUrl = `/api/files/observadores/${fileName}`;

        return { secureUrl };
    }
}
