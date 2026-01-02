import * as dotenv from 'dotenv';
import * as path from 'path';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as fs from 'fs';

// Cargar .env por defecto
dotenv.config();
// Si no hay DATABASE_URL, intentar cargar .env.develop
if (!process.env.DATABASE_URL) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

const DRY_RUN = process.env.DRY_RUN === 'true';

async function main() {
    console.log(`--- Marea JSONL Seed Process (2025) [DRY_RUN: ${DRY_RUN}] ---`);

    const jsonlPath = path.join(__dirname, 'data', 'mareas_2025.jsonl');
    if (!fs.existsSync(jsonlPath)) {
        console.error(`JSONL not found at ${jsonlPath}`);
        return;
    }

    const content = fs.readFileSync(jsonlPath, 'utf8');
    const records = content.split('\n').filter(l => l.trim()).map(l => JSON.parse(l));

    // Catalogos para matching
    const [buques, observadores, pesquerias, estados] = await Promise.all([
        prisma.buque.findMany(),
        prisma.observador.findMany(),
        prisma.pesqueria.findMany(),
        prisma.estadoMarea.findMany()
    ]);

    // Cleanup existing 2025 mareas to avoid duplicates
    if (!DRY_RUN) {
        console.log('Cleaning up existing 2025 mareas...');
        try {
            // Delete mareas (Cascade should handle related records if configured, otherwise this might fail)
            // We'll trust the schema has Cascade delete for now as per previous interactions
            await prisma.marea.deleteMany({ where: { anioMarea: 2025 } });
            console.log('Cleanup successful.');
        } catch (e) {
            console.error('Error cleaning up mareas (check cascade settings):', e);
        }
    }

    // Stats
    const stats = {
        total: records.length,
        success: 0,
        failed: 0,
        buqueNotFound: [] as string[],
        obsNotFound: [] as string[]
    };

    const normalize = (str: string, removeSpaces = false) => {
        if (!str) return '';
        const n = str.toLowerCase()
            .trim()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "") // remove accents
            .replace(/[^a-z0-9\s]/g, ""); // remove other chars but keep spaces

        return removeSpaces ? n.replace(/\s+/g, "") : n;
    };

    const safeDate = (d: string | null | undefined) => {
        if (!d) return null;

        // Try parsing DD/MM/YYYY manually first
        if (d.includes('/')) {
            const parts = d.split('/');
            if (parts.length === 3) {
                const day = parseInt(parts[0], 10);
                const month = parseInt(parts[1], 10) - 1; // JS months are 0-indexed
                let year = parseInt(parts[2], 10);
                if (year < 100) year += 2000; // Handle 2-digit years

                const date = new Date(year, month, day);
                return isNaN(date.getTime()) ? null : date;
            }
        }

        const date = new Date(d);
        return isNaN(date.getTime()) ? null : date;
    };

    const getBuque = (name: string) => {
        const normName = normalize(name, true);

        // Intento 1: Match exacto
        let found = buques.find(b => normalize(b.nombreBuque, true) === normName);
        if (found) return found;

        // Intento 2: Contenido
        found = buques.find(b => {
            const normB = normalize(b.nombreBuque, true);
            return normName.startsWith(normB) || normB.startsWith(normName);
        });

        // Casos especiales cableados
        if (!found && normName.includes('atlanticexpres')) {
            return buques.find(b => normalize(b.nombreBuque, true).includes('atlanticexpress'));
        }

        return found;
    };

    const getObservador = (name: string) => {
        if (!name) return null;
        const inputParts = normalize(name).split(/\s+/).filter(p => p.length > 2);

        return observadores.find(o => {
            const nomParts = normalize(o.nombre).split(/\s+/).filter(p => p.length > 2);
            const apeParts = normalize(o.apellido).split(/\s+/).filter(p => p.length > 2);

            // Debe tener el apellido y al menos un nombre
            const hasApellido = apeParts.every(ap => inputParts.some(ip => ip.includes(ap) || ap.includes(ip)));
            const hasNombre = nomParts.some(np => inputParts.some(ip => ip.includes(np) || np.includes(ip)));

            return hasApellido && hasNombre;
        });
    };

    const mapPesqueria = (especie: string) => {
        const esp = normalize(especie);
        if (esp.includes('austral')) return pesquerias.find(p => p.codigo === 'AUSTRALES');
        if (esp.includes('merluzanegra')) return pesquerias.find(p => p.codigo === 'MERLUZA_NEGRA');
        if (esp.includes('merluza')) return pesquerias.find(p => p.codigo === 'MERLUZA_COMUN');
        if (esp.includes('centolla')) return pesquerias.find(p => p.codigo === 'CENTOLLA');
        if (esp.includes('calamar')) return pesquerias.find(p => p.codigo === 'CALAMAR');
        if (esp.includes('vieira')) return pesquerias.find(p => p.codigo === 'VIEIRA');
        if (esp.includes('langostino')) return pesquerias.find(p => p.codigo === 'LANGOSTINO');
        return null;
    };

    const mapEstado = (estadoRaw: string) => {
        const est = normalize(estadoRaw);
        if (est.includes('realizada') || est.includes('terminada') || est.includes('protocolizada')) return estados.find(e => e.codigo === 'PROTOCOLIZADA');
        if (est.includes('navegando') || est.includes('ejecucion')) return estados.find(e => e.codigo === 'EN_EJECUCION');
        if (est.includes('espera') || est.includes('designada')) return estados.find(e => e.codigo === 'DESIGNADA');
        if (est.includes('cancelada') || est.includes('sinpesca')) return estados.find(e => e.codigo === 'CANCELADA');
        return estados.find(e => e.codigo === 'DESIGNADA');
    };

    const adminUser = await prisma.user.findFirst({ where: { roles: { has: 'admin' } } });

    console.log(`Procesando ${records.length} registros...`);

    for (const data of records) {
        const { nroMarea, buqueName, obsName, especieStr, estadoStr, zarpadaEstimada, empresa, etapas, diasEstimados, diasZonaAustral } = data;

        const buque = getBuque(buqueName);
        const observador = getObservador(obsName);
        const pesqueria = mapPesqueria(especieStr);
        const estadoActual = mapEstado(estadoStr);

        if (!buque) {
            console.warn(`[Marea ${nroMarea}] Buque no encontrado: ${buqueName}`);
            stats.buqueNotFound.push(buqueName);
            stats.failed++;
            continue;
        }

        if (!observador && obsName) {
            stats.obsNotFound.push(obsName);
        }

        if (DRY_RUN) {
            console.log(`[DRY] Marea ${nroMarea}: ${buque.nombreBuque} - ${obsName || 'SIN OBS'} - Estado: ${estadoActual?.codigo} - Etapas: ${etapas.length}`);
            stats.success++;
            continue;
        }

        try {
            await prisma.$transaction(async (tx) => {
                const marea = await tx.marea.create({
                    data: {
                        anioMarea: 2025,
                        nroMarea,
                        buqueId: buque.id,
                        estadoActualId: estadoActual?.id || estados.find(e => e.codigo === 'DESIGNADA')!.id,
                        tipoMarea: 'MC',
                        observaciones: `Importada de JSONL. Empresa: ${empresa}. Especie: ${especieStr}`,
                        fechaZarpadaEstimada: safeDate(zarpadaEstimada),
                        diasEstimados,
                        diasZonaAustral,
                    }
                });

                // Movimiento inicial
                await tx.mareaMovimiento.create({
                    data: {
                        mareaId: marea.id,
                        fechaHora: new Date(),
                        usuarioId: adminUser?.id,
                        tipoEvento: 'CREACION',
                        estadoHastaId: marea.estadoActualId,
                        detalle: 'Marea importada de seguimiento 2025 (JSONL)'
                    }
                });

                // Etapas Logic
                // 1. Si está CANCELADA, no procesar etapas
                if (estadoActual?.codigo !== 'CANCELADA') {
                    if (etapas && etapas.length > 0) {
                        // Caso A: Etapas explícitas
                        for (const etap of etapas) {
                            let fechaArribo = safeDate(etap.fecha_arribo);
                            // Si está en ejecución y es la última, quizás no tenga arribo real.
                            // Pero respetamos lo que venga en el JSONL si existe.
                            if (estadoActual?.codigo === 'EN_EJECUCION' && etap.nroEtapa === etapas.length && !fechaArribo) {
                                fechaArribo = null;
                            }

                            const etapa = await tx.mareaEtapa.create({
                                data: {
                                    mareaId: marea.id,
                                    nroEtapa: etap.nroEtapa,
                                    pesqueriaId: pesqueria?.id,
                                    tipoEtapa: 'COMERCIAL',
                                    fechaZarpada: safeDate(etap.fecha_zarpada),
                                    fechaArribo: fechaArribo,
                                    observaciones: `Etapa ${etap.nroEtapa} importada`
                                }
                            });

                            if (observador) {
                                await (tx as any).mareaEtapaObservador.create({
                                    data: {
                                        etapaId: etapa.id,
                                        observadorId: observador.id,
                                        rol: 'PRINCIPAL',
                                        esDesignado: true
                                    }
                                });
                            }
                        }
                    } else if (safeDate(zarpadaEstimada)) {
                        // Caso B: No hay etapas explícitas pero hay fecha de zarpada y NO está cancelada
                        // Creamos una etapa por defecto
                        const etapa = await tx.mareaEtapa.create({
                            data: {
                                mareaId: marea.id,
                                nroEtapa: 1,
                                pesqueriaId: pesqueria?.id,
                                tipoEtapa: 'COMERCIAL',
                                fechaZarpada: safeDate(zarpadaEstimada),
                                fechaArribo: null, // Asumimos abierta si no hay datos
                                observaciones: 'Etapa generada automáticamente (sin desglose)'
                            }
                        });

                        if (observador) {
                            await (tx as any).mareaEtapaObservador.create({
                                data: {
                                    etapaId: etapa.id,
                                    observadorId: observador.id,
                                    rol: 'PRINCIPAL',
                                    esDesignado: true
                                }
                            });
                        }
                    }
                }
            });
            stats.success++;
        } catch (error: any) {
            console.error(`Error procesando marea ${nroMarea}: ${error.message}`);
            stats.failed++;
        }
    }

    console.log('\n--- Resumen de Proceso ---');
    console.log(`Total registros: ${stats.total}`);
    console.log(`Procesados con éxito: ${stats.success}`);
    console.log(`Fallidos: ${stats.failed}`);

    if (stats.buqueNotFound.length > 0) {
        console.log(`Buques no encontrados: ${[...new Set(stats.buqueNotFound)].join(', ')}`);
    }

    if (stats.obsNotFound.length > 0) {
        console.log(`Observadores no encontrados (${[...new Set(stats.obsNotFound)].length}): ${[...new Set(stats.obsNotFound)].slice(0, 10).join(', ')}...`);
    }

    console.log('--- Seed completed ---');
}

main()
    .catch(console.error)
    .finally(async () => {
        await prisma.$disconnect();
    });
