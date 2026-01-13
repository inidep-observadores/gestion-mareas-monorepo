import * as dotenv from 'dotenv';
import * as path from 'path';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as fs from 'fs';

// Cargar .env por defecto
dotenv.config();

function expandEnv(str: string | undefined): string | undefined {
    if (!str) return str;
    return str.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '');
}

// Si no hay DATABASE_URL o contiene variables sin expandir, intentar cargar .env.develop
if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}

process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);

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
            const mareas2025 = await prisma.marea.findMany({
                where: { anioMarea: 2025 },
                select: { id: true }
            });
            const mareaIds = mareas2025.map((m) => m.id);

            if (mareaIds.length > 0) {
                await prisma.muestraDetalleTalla.deleteMany({
                    where: { muestra: { lance: { etapa: { mareaId: { in: mareaIds } } } } }
                });
                await prisma.submuestra.deleteMany({
                    where: { muestra: { lance: { etapa: { mareaId: { in: mareaIds } } } } }
                });
                await prisma.muestra.deleteMany({
                    where: { lance: { etapa: { mareaId: { in: mareaIds } } } }
                });
                await prisma.captura.deleteMany({
                    where: { lance: { etapa: { mareaId: { in: mareaIds } } } }
                });
                await prisma.lance.deleteMany({
                    where: { etapa: { mareaId: { in: mareaIds } } }
                });
                await prisma.mareaEtapaObservador.deleteMany({
                    where: { etapa: { mareaId: { in: mareaIds } } }
                });
                await prisma.mareaArchivo.deleteMany({
                    where: { mareaId: { in: mareaIds } }
                });
                await prisma.mareaMovimiento.deleteMany({
                    where: { mareaId: { in: mareaIds } }
                });
                await prisma.produccion.deleteMany({
                    where: { mareaId: { in: mareaIds } }
                });
                await prisma.mareaEtapa.deleteMany({
                    where: { mareaId: { in: mareaIds } }
                });
            }

            // El esquema no tiene cascade; borramos en orden de dependencias
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

    const safeDate = (d: string | Date | null | undefined) => {
        if (!d) return null;
        if (d instanceof Date) return isNaN(d.getTime()) ? null : d;

        // ISO strings (ya parseadas en JSONL)
        if (/^\d{4}-\d{2}-\d{2}T/.test(d)) {
            const isoDate = new Date(d);
            return isNaN(isoDate.getTime()) ? null : isoDate;
        }

        // Try parsing DD/MM/YYYY manual (formato original CSV)
        if (d.includes('/')) {
            const parts = d.split('/');
            if (parts.length === 3) {
                const day = parseInt(parts[0], 10);
                const month = parseInt(parts[1], 10) - 1; // JS months are 0-indexed
                let year = parseInt(parts[2], 10);
                if (year < 100) year += 2000; // Handle 2-digit years
                const date = new Date(Date.UTC(year, month, day, 3, 0, 0)); // UTC-3 -> +3h
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

    const fechaCorteProtocolizada = new Date(Date.UTC(2025, 9, 31, 0, 0, 0));
    const fechaCorteParaProtocolizar = new Date(Date.UTC(2025, 10, 30, 0, 0, 0));

    const obtenerFechaFinalizacion = (etapasData: any[]) => {
        if (!etapasData || etapasData.length === 0) return null;

        const fechasArribo = etapasData
            .map((et) => safeDate(et.fecha_arribo))
            .filter((f): f is Date => Boolean(f));

        if (fechasArribo.length === 0) return null;

        const maxTimestamp = Math.max(...fechasArribo.map(f => f.getTime()));
        return new Date(maxTimestamp);
    };

    const resolverEstado = (estadoRaw: string, fechaFinalizacion: Date | null) => {
        const estadoNormalizado = normalize(estadoRaw);
        const estadoSinEspacios = normalize(estadoRaw, true);

        if (estadoSinEspacios.includes('alaespera')) {
            return estados.find(e => e.codigo === 'DESIGNADA');
        }

        if (estadoNormalizado.includes('cancelada') || estadoSinEspacios.includes('sinpesca')) {
            return estados.find(e => e.codigo === 'CANCELADA');
        }

        if (fechaFinalizacion) {
            if (fechaFinalizacion.getTime() < fechaCorteProtocolizada.getTime()) {
                return estados.find(e => e.codigo === 'PROTOCOLIZADA');
            }

            if (fechaFinalizacion.getTime() < fechaCorteParaProtocolizar.getTime()) {
                return estados.find(e => e.codigo === 'PARA_PROTOCOLIZAR');
            }

            return estados.find(e => e.codigo === 'ESPERANDO_ENTREGA');
        }

        return estados.find(e => e.codigo === 'EN_EJECUCION');
    };

    const adminUser = await prisma.user.findFirst({ where: { roles: { has: 'admin' } } });

    console.log(`Procesando ${records.length} registros...`);

    for (const data of records) {
        const {
            nroMarea,
            buqueName,
            obsName,
            especieStr,
            estadoStr,
            zarpadaEstimada,
            fechaZarpadaEstimada,
            empresa,
            etapas,
            diasEstimados,
            diasZonaAustral
        } = data;

        const buque = getBuque(buqueName);
        const observador = getObservador(obsName);
        const pesqueria = mapPesqueria(especieStr);
        const fechaFinalizacion = obtenerFechaFinalizacion(etapas || []);
        const estadoActual = resolverEstado(estadoStr, fechaFinalizacion);

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
                        fechaZarpadaEstimada: safeDate(fechaZarpadaEstimada) ?? safeDate(zarpadaEstimada),
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
                                    puertoZarpadaId: buque.puertoBaseId || null,
                                    puertoArriboId: buque.puertoBaseId || null,
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
                                puertoZarpadaId: buque.puertoBaseId || null,
                                puertoArriboId: buque.puertoBaseId || null,
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
