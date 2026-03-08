
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as dotenv from 'dotenv';
import { join } from 'path';
import { DateTime } from 'luxon';
import * as fs from 'fs';

// Cargar variables de entorno desde la raíz del backend
const envPath = join(process.cwd(), '.env');
dotenv.config({ path: envPath });

async function validatePna2025() {
    console.log('--- Iniciando Validación de Mareas vs PNA (Año 2025) ---');
    console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'DEFINIDA' : 'NO DEFINIDA');

    if (!process.env.DATABASE_URL) {
        console.error('❌ Error: DATABASE_URL no está definida en el entorno.');
        process.exit(1);
    }

    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    const prisma = new PrismaClient({ adapter });

    try {
        console.log('Verificando conexión a base de datos via Adapter...');
        await prisma.$connect();
        console.log('✅ Conexión establecida.');
    } catch (dbError) {
        console.error('❌ Error al conectar con la base de datos:', dbError);
        process.exit(1);
    }

    const TIMEZONE = process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires';
    let mareas: any[] = [];

    // 1. Obtener todas las mareas del 2025 con sus etapas y puertos
    try {
        mareas = await prisma.marea.findMany({
            where: {
                anioMarea: 2025,
                activo: true
            },
            include: {
                buque: true,
                etapas: {
                    orderBy: { nroEtapa: 'asc' },
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true
                    }
                }
            }
        });
        console.log(`Se encontraron ${mareas.length} mareas para procesar.`);
    } catch (queryError) {
        console.error('❌ Error al ejecutar la consulta principal:', queryError);
        process.exit(1);
    }

    const reportRows: string[] = [];
    // Encabezado del CSV
    reportRows.push('Tipo Marea;Año;Número;Buque;Matricula;MBPC;Etapa;Tipo;Fecha Sistema;Fecha PNA;Puerto Sistema;Puerto PNA;Resultado;Diferencia (Min);Comentarios');

    let processedCount = 0;

    for (const marea of mareas) {
        processedCount++;
        if (processedCount % 50 === 0) console.log(`Procesando marea ${processedCount}/${mareas.length}...`);

        for (const etapa of marea.etapas) {
            // Validar Zarpada
            if (etapa.fechaZarpada) {
                const result = await validateEvent(prisma, marea, etapa, 'ZARPADA', etapa.fechaZarpada, etapa.puertoZarpada, TIMEZONE);
                reportRows.push(formatCsvRow(marea, etapa, 'ZARPADA', etapa.fechaZarpada, etapa.puertoZarpada, result));
            }

            // Validar Arribo
            if (etapa.fechaArribo) {
                const result = await validateEvent(prisma, marea, etapa, 'ARRIBO', etapa.fechaArribo, etapa.puertoArribo, TIMEZONE);
                reportRows.push(formatCsvRow(marea, etapa, 'ARRIBO', etapa.fechaArribo, etapa.puertoArribo, result));
            }
        }
    }

    // Guardar reporte
    const outputDir = join(process.cwd(), 'outputs');
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

    const fileName = `validacion_pna_2025_${DateTime.now().toFormat('yyyyMMdd_HHmm')}.csv`;
    const outputPath = join(outputDir, fileName);

    // Usar UTF-8 con BOM (\ufeff) para que Excel lo reconozca automáticamente y muestre bien los acentos
    const contentWithBOM = '\ufeff' + reportRows.join('\n');
    fs.writeFileSync(outputPath, contentWithBOM, 'utf8');

    console.log('--------------------------------------------');
    console.log(`✅ Validación finalizada.`);
    console.log(`Reporte generado en: ${outputPath}`);

    await prisma.$disconnect();
    await pool.end();
}

async function validateEvent(prisma: any, marea: any, etapa: any, type: string, systemDate: Date, systemPort: any, tz: string) {
    const windowStart = DateTime.fromJSDate(systemDate).minus({ hours: 48 }).toJSDate();
    const windowEnd = DateTime.fromJSDate(systemDate).plus({ hours: 48 }).toJSDate();

    // Buscar en el histórico de PNA
    // Normalización de identificadores para evitar problemas con ceros a la izquierda
    const normalizeId = (id: string | null | undefined) => id ? id.trim().replace(/^0+/, '') : null;
    const mbpcNormalized = normalizeId(marea.buque.idMbpc);
    const matriculaNormalized = normalizeId(marea.buque.matricula);

    const buqueCriteria: any = {
        OR: [
            mbpcNormalized ? { idBuqueMbpc: { in: [marea.buque.idMbpc, mbpcNormalized].filter((v, i, a) => v && a.indexOf(v) === i) } } : undefined,
            matriculaNormalized ? { matricula: { in: [marea.buque.matricula, matriculaNormalized].filter((v, i, a) => v && a.indexOf(v) === i) } } : undefined
        ].filter(Boolean)
    };

    const pnaMatches = await prisma.pnaZarpadaArribo.findMany({
        where: {
            ...buqueCriteria,
            estado: type,
            fecha: { gte: windowStart, lte: windowEnd }
        }
    });

    if (pnaMatches.length === 0) {
        return { status: 'NOT_FOUND', pnaDate: null, pnaPortName: null, diffMin: null, comments: 'No se encontró registro en ventana de +/- 48h' };
    }

    // Seleccionar el registro más cercano temporalmente al sistema
    const pnaMatch = pnaMatches.reduce((prev: any, curr: any) => {
        const prevDiff = Math.abs(systemDate.getTime() - prev.fecha.getTime());
        const currDiff = Math.abs(systemDate.getTime() - curr.fecha.getTime());
        return currDiff < prevDiff ? curr : prev;
    });

    const diffMillis = Math.abs(systemDate.getTime() - pnaMatch.fecha.getTime());
    const diffMin = Math.round(diffMillis / (1000 * 60));

    let portStatus = 'MATCH';
    const pnaPortName = pnaMatch.nombreCostera;
    const systemPortName = systemPort?.nombre || 'S/D';

    const normalize = (s: string) => s.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").trim();

    if (systemPort && !normalize(systemPortName).includes(normalize(pnaPortName)) && !normalize(pnaPortName).includes(normalize(systemPortName))) {
        portStatus = 'PORT_DIFF';
    }

    let status = 'MATCH';
    const systemDateKey = DateTime.fromJSDate(systemDate).setZone(tz).toFormat('yyyy-MM-dd');
    const pnaDateKey = DateTime.fromJSDate(pnaMatch.fecha).setZone(tz).toFormat('yyyy-MM-dd');

    if (portStatus === 'PORT_DIFF') {
        status = 'PORT_DIFF';
    } else if (systemDateKey !== pnaDateKey) {
        status = 'DATE_DIFF';
    }

    return {
        status,
        pnaDate: pnaMatch.fecha,
        pnaPortName,
        diffMin,
        comments: pnaMatch.observaciones || ''
    };
}

function formatCsvRow(marea: any, etapa: any, type: string, systemDate: Date, systemPort: any, result: any) {
    const formatDate = (d: Date | null) => d ? DateTime.fromJSDate(d).toFormat('dd/MM/yyyy HH:mm') : 'N/A';

    const row = [
        marea.tipoMarea,
        marea.anioMarea,
        marea.nroMarea,
        marea.buque.nombreBuque,
        marea.buque.matricula,
        marea.buque.idMbpc || 'N/A',
        etapa.nroEtapa,
        type,
        formatDate(systemDate),
        formatDate(result.pnaDate),
        systemPort?.nombre || 'N/A',
        result.pnaPortName || 'N/A',
        result.status,
        result.diffMin ?? '',
        (result.comments || '').replace(/;/g, ',').replace(/\n/g, ' ')
    ];

    return row.join(';');
}

validatePna2025().catch(err => {
    console.error('Error fatal en el script de validación:', err);
    process.exit(1);
});
