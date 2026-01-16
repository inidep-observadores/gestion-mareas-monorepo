import { Injectable, Logger } from '@nestjs/common';
import MDBReader from 'mdb-reader';

export interface ExternalRecord {
    Id: number;
    CodObs: number;
    Buque: string;
    Especie: string;
    Flota: string;
    Fecha_Zarpada: string; // dd/mm/yyyy
    Fecha_Arribo: string;  // dd/mm/yyyy
    DiasNavegados: number;
    NroMarea: string;      // nnn/yyyy o CI
    Validada: string;      // VERDADERO/FALSO
    SinEtapas: string;     // VERDADERO/FALSO
    NroInformeDni?: string;
    Comentarios?: string;
    Prospeccion: string;   // FALSO/VERDADERO
    InicioProspeccion?: string;
    FinProspeccion?: string;
    NroEtapa: number;
    FechaInicioCI?: string;
    FechaFinCI?: string;
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

            // Intentamos obtener la tabla. El usuario no especificó el nombre, 
            // pero usualmente hay una tabla principal o podemos listar las tablas.
            const tables = reader.getTableNames();
            this.logger.log(`Tablas encontradas en el archivo Access: ${tables.join(', ')}`);

            // Asumimos que la tabla se llama 'Mareas' o similar. 
            // Si hay varias, intentamos encontrar la que tenga más registros o una sugerida.
            // Por ahora usamos la primera tabla que no sea del sistema.
            const targetTable = tables.find(t => !t.startsWith('MSys')) || tables[0];

            if (!targetTable) {
                throw new Error('No se encontraron tablas procesables en el archivo Access.');
            }

            this.logger.log(`Leyendo tabla: ${targetTable}`);
            const table = reader.getTable(targetTable);
            const data = table.getData();

            return data as unknown as ExternalRecord[];
        } catch (error) {
            this.logger.error(`Error al leer archivo Access: ${error.message}`);
            throw new Error(`Error al procesar el archivo .accdb: ${error.message}`);
        }
    }

    /**
     * Helper para parsear fechas en formato dd/mm/yyyy a objeto Date
     */
    parseDate(dateStr: string): Date | null {
        if (!dateStr || dateStr.trim() === '') return null;

        // El formato es dd/mm/yyyy según el CSV de referencia
        const parts = dateStr.split('/');
        if (parts.length !== 3) return null;

        const day = parseInt(parts[0], 10);
        const month = parseInt(parts[1], 10) - 1; // 0-indexed
        const year = parseInt(parts[2], 10);

        const date = new Date(year, month, day);

        // Validar si es una fecha válida
        return isNaN(date.getTime()) ? null : date;
    }
}
