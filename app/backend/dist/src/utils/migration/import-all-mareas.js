"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv = require("dotenv");
const path = require("path");
const fs = require("fs");
const client_1 = require("@prisma/client");
const mareas_constants_1 = require("../../mareas/mareas.constants");
const adapter_pg_1 = require("@prisma/adapter-pg");
const pg_1 = require("pg");
const mdb_reader_1 = require("mdb-reader");
dotenv.config();
function expandEnv(str) {
    if (!str)
        return str;
    return str.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '');
}
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
    const log = (msg) => {
        const timestamp = new Date().toISOString();
        const formattedMsg = `[${timestamp}] ${msg}`;
        console.log(formattedMsg);
        logStream.write(formattedMsg + '\n');
    };
    log('--- Iniciando Migración Masiva de Mareas desde Access ---');
    const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new adapter_pg_1.PrismaPg(pool);
    const prisma = new client_1.PrismaClient({ adapter });
    const accessPath = path.join(process.cwd(), 'old_data', 'MareasAipBD.accdb');
    if (!fs.existsSync(accessPath)) {
        log(`Error: No se encontró el archivo Access en ${accessPath}`);
        return;
    }
    try {
        log('Limpiando tablas de marea para inicio limpio...');
        await prisma.mareaEtapaObservador.deleteMany();
        await prisma.mareaEtapa.deleteMany();
        await prisma.marea.deleteMany();
        const buques = await prisma.buque.findMany();
        const estados = await prisma.estadoMarea.findMany();
        const observadores = await prisma.observador.findMany();
        const getEstadoId = (codigo) => estados.find(e => e.codigo === codigo)?.id;
        const idEstadoProtocolizada = getEstadoId('PROTOCOLIZADA');
        const idEstadoEnEjecucion = getEstadoId('EN_EJECUCION');
        const fallbackObservador = observadores.find(o => o.codigoInterno === 9999);
        if (!idEstadoProtocolizada || !idEstadoEnEjecucion) {
            throw new Error('No se encontraron los estados de marea necesarios (PROTOCOLIZADA, EN_EJECUCION)');
        }
        const buffer = fs.readFileSync(accessPath);
        const reader = new mdb_reader_1.default(buffer);
        const table = reader.getTable('Mareas');
        const data = table.getData();
        log(`Leídos ${data.length} registros de la tabla Mareas.`);
        const mareasMap = new Map();
        for (const row of data) {
            let rawNroMarea = (row.NroMarea || '').trim();
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
            const buqueNombre = row.Buque?.trim().toUpperCase();
            if (!buqueNombre)
                continue;
            const groupKey = `${rawNroMarea}|${buqueNombre}`;
            if (!mareasMap.has(groupKey)) {
                mareasMap.set(groupKey, []);
            }
            mareasMap.get(groupKey).push(row);
        }
        log(`Agrupadas en ${mareasMap.size} mareas potenciales.`);
        let mareaCreatedCount = 0;
        let etapaCreatedCount = 0;
        let skippedMareas = 0;
        const ciCounters = new Map();
        for (const [key, rows] of mareasMap.entries()) {
            try {
                const stagesMap = new Map();
                rows.forEach(r => {
                    const n = r.NroEtapa || 1;
                    if (!stagesMap.has(n)) {
                        stagesMap.set(n, r);
                    }
                    else {
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
                const buque = buques.find(b => b.nombreBuque.toUpperCase() === buqueNombre);
                if (!buque) {
                    log(`[SKIP] Buque no encontrado: ${buqueNombre} (Marea: ${rawNroMarea})`);
                    skippedMareas++;
                    continue;
                }
                const codObsAccess = firstRow.CodObs;
                let observador = observadores.find(o => o.codigoInterno === Number(codObsAccess));
                if (!observador) {
                    if (fallbackObservador) {
                        log(`[INFO] Observador ${codObsAccess} no encontrado, usando fallback 9999 (Buque: ${buqueNombre}, Marea: ${rawNroMarea})`);
                        observador = fallbackObservador;
                    }
                    else {
                        log(`[SKIP] Observador no encontrado: ${codObsAccess} y no hay fallback 9999 (Buque: ${buqueNombre}, Marea: ${rawNroMarea})`);
                        skippedMareas++;
                        continue;
                    }
                }
                let nroMarea;
                let anioMarea;
                let tipoMarea;
                if (rawNroMarea === 'CI') {
                    tipoMarea = mareas_constants_1.TipoMarea.CI;
                    const fechaZarpada = firstRow.Fecha_Zarpada ? new Date(firstRow.Fecha_Zarpada) : new Date();
                    anioMarea = fechaZarpada.getFullYear();
                    const currentCount = (ciCounters.get(anioMarea) || 0) + 1;
                    nroMarea = currentCount;
                    ciCounters.set(anioMarea, currentCount);
                }
                else {
                    const parts = rawNroMarea.split('/');
                    if (parts.length === 2) {
                        nroMarea = parseInt(parts[0], 10);
                        anioMarea = parseInt(parts[1], 10);
                        tipoMarea = mareas_constants_1.TipoMarea.MC;
                    }
                    else {
                        log(`[SKIP] Formato de NroMarea inválido: ${rawNroMarea} (Buque: ${buqueNombre})`);
                        skippedMareas++;
                        continue;
                    }
                }
                const hasAllArribos = uniqueRows.every(r => !!r.Fecha_Arribo);
                const estadoId = hasAllArribos ? idEstadoProtocolizada : idEstadoEnEjecucion;
                const fechaInicioObs = firstRow.Fecha_Zarpada ? new Date(firstRow.Fecha_Zarpada) : null;
                const fechaFinObs = (hasAllArribos && lastRow.Fecha_Arribo) ? new Date(lastRow.Fecha_Arribo) : null;
                await prisma.marea.create({
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
                                tipoEtapa: mareas_constants_1.TipoEtapa.MC,
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
            }
            catch (err) {
                log(`[ERROR] Error procesando clave ${key}: ${err.message}`);
            }
        }
        log('\n--- Resumen de Migración ---');
        log(`Mareas creadas: ${mareaCreatedCount}`);
        log(`Etapas creadas: ${etapaCreatedCount}`);
        log(`Mareas omitidas: ${skippedMareas}`);
        log(`Log guardado en: ${logPath}`);
    }
    catch (error) {
        log(`Error fatal: ${error.message}`);
        if (error.stack)
            log(error.stack);
    }
    finally {
        await prisma.$disconnect();
        await pool.end();
        logStream.end();
    }
}
main();
//# sourceMappingURL=import-all-mareas.js.map