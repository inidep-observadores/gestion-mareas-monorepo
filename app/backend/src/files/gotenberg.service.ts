import { Injectable, Logger, HttpException, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import * as FormData from 'form-data';

@Injectable()
export class GotenbergService {
    private readonly logger = new Logger(GotenbergService.name);
    private readonly gotenbergUrl: string;

    constructor(private configService: ConfigService) {
        this.gotenbergUrl = this.configService.get<string>('GOTENBERG_URL') || 'http://gotenberg:3000';
    }

    /**
     * Convierte una cadena HTML a un documento PDF usando Gotenberg
     * @param htmlContent Contenido HTML a convertir
     * @returns Buffer con el PDF generado
     */
    async convertHtmlToPdf(htmlContent: string): Promise<Buffer> {
        try {
            const formData = new FormData();
            
            // Gotenberg requiere que el archivo principal se llame index.html
            formData.append('files', Buffer.from(htmlContent, 'utf-8'), {
                filename: 'index.html',
                contentType: 'text/html'
            });

            // Ajustes de página opcionales (A4 por defecto, márgenes)
            formData.append('marginTop', '0.5');
            formData.append('marginBottom', '0.5');
            formData.append('marginLeft', '0.5');
            formData.append('marginRight', '0.5');

            this.logger.debug(`Enviando solicitud de conversión a ${this.gotenbergUrl}/forms/chromium/convert/html`);
            
            const response = await axios.post(`${this.gotenbergUrl}/forms/chromium/convert/html`, formData, {
                headers: {
                    ...formData.getHeaders(),
                },
                responseType: 'arraybuffer', // Para recibir el PDF como buffer
                timeout: 30000 // 30 segundos de timeout
            });

            return Buffer.from(response.data);
        } catch (error: any) {
            this.logger.error(`Error convirtiendo HTML a PDF con Gotenberg: ${error.message}`);
            throw new HttpException('No se pudo generar el documento PDF desde el contenido original', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
