import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import * as path from 'path';
import * as fs from 'fs';
import * as os from 'os';
import { DBFFile, FieldDescriptor } from 'dbffile';

@Injectable()
export class VesselExportService {
    private readonly logger = new Logger(VesselExportService.name);

    constructor(private prisma: PrismaService) { }

    /**
     * Exporta el catálogo de buques a un buffer en formato DBF.
     * Sigue la estructura definida en docs/buques_struct.txt
     */
    async exportToDbf(): Promise<Buffer> {
        this.logger.log('Iniciando exportación de buques a DBF...');

        // 1. Obtener datos de buques con relaciones necesarias
        const buques = await this.prisma.buque.findMany({
            include: {
                tipoFlota: true,
                puertoBase: true,
            },
            where: {
                activo: true,
            },
            orderBy: {
                nombreBuque: 'asc',
            },
        });

        // 2. Definir campos según buques_struct.txt
        const fields: FieldDescriptor[] = [
            { name: 'MATR_BQE', type: 'C', size: 7 },
            { name: 'COOP_COD', type: 'C', size: 5 },
            { name: 'BARCO', type: 'C', size: 20 },
            { name: 'NBRE_BQE', type: 'C', size: 28 },
            { name: 'RIP', type: 'C', size: 4 },
            { name: 'TIPO_BQE', type: 'C', size: 2 },
            { name: 'NRO_ARM', type: 'C', size: 4 },
            { name: 'ESLORA_BQE', type: 'N', size: 8, decimalPlaces: 2 },
            { name: 'MANGA_BQE', type: 'N', size: 6, decimalPlaces: 2 },
            { name: 'PUNTAL_BQE', type: 'N', size: 6, decimalPlaces: 2 },
            { name: 'TN_REG_NET', type: 'N', size: 8, decimalPlaces: 0 },
            { name: 'TN_REG_BTO', type: 'N', size: 5, decimalPlaces: 0 },
            { name: 'BODEGA_BQE', type: 'N', size: 5, decimalPlaces: 0 },
            { name: 'POTENC_BQE', type: 'N', size: 5, decimalPlaces: 0 },
            { name: 'CO_PAI_CON', type: 'C', size: 3 },
            { name: 'ANO_CONSTR', type: 'N', size: 4, decimalPlaces: 0 },
            { name: 'CO_PTO_BAS', type: 'C', size: 4 },
            { name: 'NRO_EXP', type: 'C', size: 10 },
            { name: 'PER_DEFINI', type: 'C', size: 1 },
            { name: 'FE_OTO_VEN', type: 'D', size: 8 },
            { name: 'NORMA_LEGA', type: 'C', size: 59 },
            { name: 'CO_ESP_PER', type: 'C', size: 1 },
            { name: 'TRIP_BQE', type: 'N', size: 3, decimalPlaces: 0 },
            { name: 'ANO_INC', type: 'N', size: 4, decimalPlaces: 0 },
            { name: 'FE_ACTUALI', type: 'D', size: 8 },
        ];

        // 3. Crear archivo temporal
        const tempPath = path.join(os.tmpdir(), `buques_${Date.now()}.dbf`);

        try {
            const dbf = await DBFFile.create(tempPath, fields, { encoding: 'cp850' });

            // 4. Mapear registros
            const records = buques.map(b => {
                // Lógica de Tipo Buque: 2 dígitos
                // Dígito 1: Estrato (TipoFlota.codigo_numerico / 10)
                // Dígito 2: Proceso (TipoFlota.codigo_numerico % 10)
                // Usamos directamente el codigo_numerico si ya sigue la convención
                const tipoBqe = b.tipoFlota?.codigo_numerico 
                    ? String(b.tipoFlota.codigo_numerico).padStart(2, '0') 
                    : '';

                return {
                    MATR_BQE: b.matricula?.substring(0, 7) || '',
                    COOP_COD: '', // Duda: Sin valor por ahora
                    BARCO: b.nombreBuque?.substring(0, 20).toUpperCase() || '',
                    NBRE_BQE: b.nombreBuque?.substring(0, 28).toUpperCase() || '',
                    RIP: '', // Duda: Sin valor por ahora
                    TIPO_BQE: tipoBqe,
                    NRO_ARM: '', // Duda: Sin valor por ahora
                    ESLORA_BQE: b.esloraM ? Number(b.esloraM) : 0,
                    MANGA_BQE: 0, // No disponible en el modelo actual
                    PUNTAL_BQE: b.puntal ? Number(b.puntal) : 0,
                    TN_REG_NET: b.arqueoNeto ? Number(b.arqueoNeto) : 0,
                    TN_REG_BTO: b.arqueoTotal ? Number(b.arqueoTotal) : 0,
                    BODEGA_BQE: 0, // No disponible en el modelo actual
                    POTENC_BQE: b.potenciaHp || 0,
                    CO_PAI_CON: 'ARG', // Por defecto Argentina
                    ANO_CONSTR: b.anioConstruccion || 0,
                    CO_PTO_BAS: b.puertoBase?.codigoInterno?.substring(0, 4) || '',
                    NRO_EXP: b.mmsi?.substring(0, 10) || '', // Se usa mmsi para este campo legado
                    PER_DEFINI: '', // No disponible en el modelo actual
                    FE_OTO_VEN: null,
                    NORMA_LEGA: '',
                    CO_ESP_PER: '',
                    TRIP_BQE: b.dotacionMinima || 0,
                    ANO_INC: 0,
                    FE_ACTUALI: new Date(),
                };
            });

            // 5. Escribir registros
            await dbf.appendRecords(records);

            // 6. Leer archivo a buffer
            const buffer = fs.readFileSync(tempPath);
            return buffer;

        } catch (error) {
            this.logger.error('Error generando DBF de buques', error);
            throw error;
        } finally {
            // 7. Limpiar archivo temporal
            if (fs.existsSync(tempPath)) {
                fs.unlinkSync(tempPath);
            }
        }
    }
}
