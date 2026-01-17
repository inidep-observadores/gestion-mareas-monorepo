import * as dotenv from 'dotenv';
import * as path from 'path';
import * as fs from 'fs';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import MDBReader from 'mdb-reader';

dotenv.config();

function expandEnv(str: string | undefined): string | undefined {
    if (!str) return str;
    return str.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '');
}

// Cargar configuración de base de datos
const envFile = path.join(process.cwd(), '.env.develop');
if (fs.existsSync(envFile)) {
    dotenv.config({ path: envFile });
}

process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);

async function main() {
    const logDir = path.join(__dirname, 'logs');
    if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
    }
    const logPath = path.join(logDir, 'full-migration-access.log');
    const logStream = fs.createWriteStream(logPath, { flags: 'w' });

    const log = (msg: string) => {
        const timestamp = new Date().toISOString();
        const formattedMsg = `[${timestamp}] ${msg}`;
        console.log(formattedMsg);
        logStream.write(formattedMsg + '\n');
    };

    log('--- Iniciando Migración Masiva de Mareas desde Access ---');

    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    const prisma = new PrismaClient({ adapter });

    const accessPath = path.join(process.cwd(), 'old_data', 'MareasAipBD.accdb');

    if (!fs.existsSync(accessPath)) {
        log(`Error: No se encontró el archivo Access en ${accessPath}`);
        return;
    }

    try {
        // 0. Limpieza de tablas para inicio limpio
        log('Limpiando tablas de marea para inicio limpio...');
        await prisma.mareaEtapaObservador.deleteMany();
        await prisma.mareaEtapa.deleteMany();
        await prisma.marea.deleteMany();

        // 1. Cargar Catálogos necesarios para mapeo
        const buques = await prisma.buque.findMany();
        const estados = await prisma.estadoMarea.findMany();
        const observadores = await prisma.observador.findMany();

        const getEstadoId = (codigo: string) => estados.find(e => e.codigo === codigo)?.id;
        const idEstadoProtocolizada = getEstadoId('PROTOCOLIZADA');
        const idEstadoEnEjecucion = getEstadoId('EN_EJECUCION');

        // Buscar observador genérico (9999) - El campo codigoInterno es Int
        const fallbackObservador = observadores.find(o => o.codigoInterno === 9999);

        if (!idEstadoProtocolizada || !idEstadoEnEjecucion) {
            throw new Error('No se encontraron los estados de marea necesarios (PROTOCOLIZADA, EN_EJECUCION)');
        }

        // 2. Leer archivo Access
        const buffer = fs.readFileSync(accessPath);
        const reader = new MDBReader(buffer);
        const table = reader.getTable('Mareas');
        const data = table.getData();

        log(`Leídos ${data.length} registros de la tabla Mareas.`);

        // 3. Agrupar por Marea (Anio, Nro, Buque)
        const mareasMap = new Map<string, any[]>();

        for (const row of data) {
            let rawNroMarea = ((row.NroMarea as string) || '').trim();

            // Normalizar formato nnn/aaaa para evitar duplicados como "03/2026" y "3/2026"
            if (rawNroMarea !== 'CI') {
                const parts = rawNroMarea.split('/');
                if (parts.length === 2) {
                    const n = parseInt(parts[0], 10);
                    const a = parseInt(parts[1], 10);
                    if (!isNaN(n) && !isNaN(a)) {
                        rawNroMarea = `${n}/${a}`;
                    }
                }
            }

            const buqueNombre = (row.Buque as string)?.trim().toUpperCase();

            if (!buqueNombre) continue;

            const groupKey = `${rawNroMarea}|${buqueNombre}`;
            if (!mareasMap.has(groupKey)) {
                mareasMap.set(groupKey, []);
            }
            mareasMap.get(groupKey)!.push(row);
        }

        log(`Agrupadas en ${mareasMap.size} mareas potenciales.`);

        let mareaCreatedCount = 0;
        let etapaCreatedCount = 0;
        let skippedMareas = 0;

        // Mapa para correlativos CI
        const ciCounters = new Map<number, number>();

        for (const [key, rows] of mareasMap.entries()) {
            try {
                // Seleccionar etapas únicas por nroEtapa para evitar Unique Constraint
                const stagesMap = new Map<number, any>();
                rows.forEach(r => {
                    const n = r.NroEtapa || 1;
                    if (!stagesMap.has(n)) {
                        stagesMap.set(n, r);
                    } else {
                        // Si hay duplicados de etapa, preferimos la que tenga fecha de arribo
                        if (!stagesMap.get(n).Fecha_Arribo && r.Fecha_Arribo) {
                            stagesMap.set(n, r);
                        }
                    }
                });

                const uniqueRows = Array.from(stagesMap.values());
                uniqueRows.sort((a, b) => (a.NroEtapa || 0) - (b.NroEtapa || 0));

                const firstRow = uniqueRows[0];
                const lastRow = uniqueRows[uniqueRows.length - 1];
                const rawNroMarea = key.split('|')[0];
                const buqueNombre = key.split('|')[1];

                // Buscar Buque
                const buque = buques.find(b => b.nombreBuque.toUpperCase() === buqueNombre);
                if (!buque) {
                    log(`[SKIP] Buque no encontrado: ${buqueNombre} (Marea: ${rawNroMarea})`);
                    skippedMareas++;
                    continue;
                }

                // Buscar Observador - Cast a Number para comparación con codigoInterno (Int)
                const codObsAccess = firstRow.CodObs;
                let observador = observadores.find(o => o.codigoInterno === Number(codObsAccess));

                if (!observador) {
                    if (fallbackObservador) {
                        log(`[INFO] Observador ${codObsAccess} no encontrado, usando fallback 9999 (Buque: ${buqueNombre}, Marea: ${rawNroMarea})`);
                        observador = fallbackObservador;
                    } else {
                        log(`[SKIP] Observador no encontrado: ${codObsAccess} y no hay fallback 9999 (Buque: ${buqueNombre}, Marea: ${rawNroMarea})`);
                        skippedMareas++;
                        continue;
                    }
                }

                // Parsear Identificador de Marea
                let nroMarea: number;
                let anioMarea: number;
                let tipoMarea: string;

                if (rawNroMarea === 'CI') {
                    tipoMarea = 'CI';
                    const fechaZarpada = firstRow.Fecha_Zarpada ? new Date(firstRow.Fecha_Zarpada) : new Date();
                    anioMarea = fechaZarpada.getFullYear();

                    const currentCount = (ciCounters.get(anioMarea) || 0) + 1;
                    nroMarea = currentCount;
                    ciCounters.set(anioMarea, currentCount);
                } else {
                    const parts = rawNroMarea.split('/');
                    if (parts.length === 2) {
                        nroMarea = parseInt(parts[0], 10);
                        anioMarea = parseInt(parts[1], 10);
                        tipoMarea = 'COMERCIAL';
                    } else {
                        log(`[SKIP] Formato de NroMarea inválido: ${rawNroMarea} (Buque: ${buqueNombre})`);
                        skippedMareas++;
                        continue;
                    }
                }

                // Determinar Estado y Fechas
                const hasAllArribos = uniqueRows.every(r => !!r.Fecha_Arribo);
                const estadoId = hasAllArribos ? idEstadoProtocolizada : idEstadoEnEjecucion;
                const fechaInicioObs = firstRow.Fecha_Zarpada ? new Date(firstRow.Fecha_Zarpada) : null;
                const fechaFinObs = (hasAllArribos && lastRow.Fecha_Arribo) ? new Date(lastRow.Fecha_Arribo) : null;

                // Insertar Marea
                await (prisma.marea as any).create({
                    data: {
                        anioMarea,
                        nroMarea,
                        tipoMarea,
                        buqueId: buque.id,
                        observadorPrincipalId: observador.id,
                        estadoActualId: estadoId,
                        artePrincipalId: buque.arteHabitualId,
                        diasEstimados: buque.diasMareaEstimada,
                        fechaInicioObservador: fechaInicioObs,
                        fechaFinObservador: fechaFinObs,
                        activo: true,
                        etapas: {
                            create: uniqueRows.map(r => ({
                                nroEtapa: r.NroEtapa || 1,
                                fechaZarpada: r.Fecha_Zarpada ? new Date(r.Fecha_Zarpada) : null,
                                fechaArribo: r.Fecha_Arribo ? new Date(r.Fecha_Arribo) : null,
                                tipoEtapa: 'PESCA',
                                pesqueriaId: buque.pesqueriaHabitualId,
                                puertoZarpadaId: buque.puertoBaseId,
                                puertoArriboId: buque.puertoBaseId,
                            }))
                        }
                    }
                });

                mareaCreatedCount++;
                etapaCreatedCount += uniqueRows.length;
                log(`[OK] Marea Creada: ${tipoMarea} ${nroMarea}/${anioMarea} - Buque: ${buqueNombre}`);

            } catch (err) {
                log(`[ERROR] Error procesando clave ${key}: ${err.message}`);
            }
        }

        log('\n--- Resumen de Migración ---');
        log(`Mareas creadas: ${mareaCreatedCount}`);
        log(`Etapas creadas: ${etapaCreatedCount}`);
        log(`Mareas omitidas: ${skippedMareas}`);
        log(`Log guardado en: ${logPath}`);

    } catch (error) {
        log(`Error fatal: ${error.message}`);
        if (error.stack) log(error.stack);
    } finally {
        await prisma.$disconnect();
        await pool.end();
        logStream.end();
    }
}

main();
