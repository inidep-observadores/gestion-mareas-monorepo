import { Injectable, Logger, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import * as FormData from 'form-data';

/**
 * Servicio encargado de la comunicación con Gotenberg para la conversión de documentos.
 */
@Injectable()
export class ConversionService {
    private readonly logger = new Logger(ConversionService.name);
    private readonly gotenbergUrl: string;

    constructor(private readonly configService: ConfigService) {
        // Por defecto intenta conectar al contenedor 'gotenberg' en la red de docker
        this.gotenbergUrl = this.configService.get<string>('GOTENBERG_URL', 'http://gotenberg:3000');
    }

    /**
     * Convierte un archivo Word (DOCX) a PDF utilizando Gotenberg.
     * @param info Origen del archivo (buffer) y nombre deseado
     * @returns Buffer con el contenido del PDF generado
     */
    async convertDocxToPdf(docxBuffer: Buffer, fileName: string): Promise<Buffer> {
        try {
            this.logger.log(`Iniciando conversión a PDF vía Gotenberg: ${fileName}`);

            const formData = new FormData();
            // Gotenberg espera el archivo con la clave 'files' para la conversión de LibreOffice
            formData.append('files', docxBuffer, {
                filename: fileName.endsWith('.docx') ? fileName : `${fileName}.docx`,
                contentType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            });

            const response = await axios.post(
                `${this.gotenbergUrl}/forms/libreoffice/convert`,
                formData,
                {
                    headers: {
                        ...formData.getHeaders(),
                    },
                    responseType: 'arraybuffer',
                    // Aumentar timeout para documentos grandes si fuera necesario
                    timeout: 30000, 
                },
            );

            this.logger.log(`Conversión completada exitosamente (${(response.data.byteLength / 1024).toFixed(1)} KB)`);
            return Buffer.from(response.data);

        } catch (error) {
            this.logger.error(`Error en la conversión a PDF: ${error.message}`);
            if (axios.isAxiosError(error) && error.response) {
                this.logger.error(`Respuesta de Gotenberg: ${error.response.status} - ${error.response.data.toString()}`);
            }
            throw new InternalServerErrorException('No se pudo generar el archivo PDF. El servicio de conversión no respondió correctamente.');
        }
    }
}
