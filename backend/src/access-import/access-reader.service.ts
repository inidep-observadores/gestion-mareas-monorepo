import { Injectable, Logger } from '@nestjs/common';
import MDBReader from 'mdb-reader';

export interface ExternalRecord {
    Id: number;
    CodObs: number;
    Buque: string;
    Especie: string;
    Flota: string;
    Fecha_Zarpada: Date | string;
    Fecha_Arribo: Date | string;
    DiasNavegados: number;
    NroMarea: string;      // nnn/yyyy o CI
    Validada: boolean;
    SinEtapas: boolean;
    NroInformeDni?: string;
    Comentarios?: string;
    Prospeccion: boolean;
    InicioProspeccion?: Date | string;
    FinProspeccion?: Date | string;
    NroEtapa: number;
    FechaInicioCI?: Date | string;
    FechaFinCI?: Date | string;
}

@Injectable()
export class AccessReaderService {
    private readonly logger = new Logger(AccessReaderService.name);

    /**
     * Lee un archivo .accdb desde un Buffer y devuelve los registros de la tabla principal.
     */
    async readAccessFile(buffer: Buffer): Promise<ExternalRecord[]> {
        try {
            const reader = new MDBReader(buffer);

            const tables = reader.getTableNames();
            this.logger.log(`Tablas encontradas en el archivo Access: ${tables.join(', ')}`);

            // Priorizamos la tabla 'Mareas' si existe, sino buscamos la primera no-sistema
            const targetTable = tables.find(t => t === 'Mareas') ||
                tables.find(t => !t.startsWith('MSys')) ||
                tables[0];

            if (!targetTable) {
                throw new Error('No se encontraron tablas procesables en el archivo Access.');
            }

            this.logger.log(`Leyendo tabla de novedades: ${targetTable}`);
            const table = reader.getTable(targetTable);
            const data = table.getData();

            return data as unknown as ExternalRecord[];
        } catch (error) {
            this.logger.error(`Error al leer archivo Access: ${error.message}`);
            throw new Error(`Error al procesar el archivo .accdb: ${error.message}`);
        }
    }

    /**
     * Helper para parsear fechas que pueden venir como Date o string
     */
    parseDate(value: Date | string | null | undefined): Date | null {
        if (!value) return null;

        // Si ya es un objeto Date (lo que suele entregar mdb-reader)
        if (value instanceof Date) {
            return isNaN(value.getTime()) ? null : value;
        }

        // Si es un string con formato ISO (ej: devuelto por JSON.stringify)
        if (typeof value === 'string' && value.includes('T')) {
            const date = new Date(value);
            return isNaN(date.getTime()) ? null : date;
        }

        // Si es un string con formato dd/mm/yyyy
        if (typeof value === 'string' && value.includes('/')) {
            const parts = value.split('/');
            if (parts.length === 3) {
                const day = parseInt(parts[0], 10);
                const month = parseInt(parts[1], 10) - 1;
                const year = parseInt(parts[2], 10);
                const date = new Date(year, month, day);
                return isNaN(date.getTime()) ? null : date;
            }
        }

        return null;
    }
}
