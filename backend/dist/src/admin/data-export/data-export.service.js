"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var DataExportService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataExportService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../prisma/prisma.service");
const config_1 = require("@nestjs/config");
const fs = require("fs");
const path = require("path");
const archiver = require("archiver");
const AdmZip = require("adm-zip");
let DataExportService = DataExportService_1 = class DataExportService {
    constructor(prisma, configService) {
        this.prisma = prisma;
        this.configService = configService;
        this.logger = new common_1.Logger(DataExportService_1.name);
        const backupRoot = this.configService.get('BACKUP_PATH') || './backups';
        this.exportPath = path.join(path.dirname(backupRoot), 'data-exports');
        if (!fs.existsSync(this.exportPath)) {
            fs.mkdirSync(this.exportPath, { recursive: true });
        }
    }
    async generateExport() {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
        const zipFilename = `EXPORT-${timestamp}.zip`;
        const zipPath = path.join(this.exportPath, zipFilename);
        const output = fs.createWriteStream(zipPath);
        const archive = archiver('zip', { zlib: { level: 9 } });
        this.logger.log(`Starting data export: ${zipFilename}`);
        return new Promise((resolve, reject) => {
            output.on('close', () => {
                this.logger.log(`Export completed: ${archive.pointer()} total bytes`);
                resolve({
                    filename: zipFilename,
                    size: archive.pointer(),
                    path: zipPath
                });
            });
            archive.on('error', (err) => {
                this.logger.error(`Export failed: ${err.message}`);
                reject(new common_1.InternalServerErrorException('Data export failed'));
            });
            archive.pipe(output);
            this.appendDataToArchive(archive).catch(reject);
        });
    }
    async listExports() {
        try {
            if (!fs.existsSync(this.exportPath))
                return [];
            const files = fs.readdirSync(this.exportPath);
            return files
                .filter(f => f.startsWith('EXPORT-') && f.endsWith('.zip'))
                .map(f => {
                const stats = fs.statSync(path.join(this.exportPath, f));
                return {
                    filename: f,
                    size: stats.size,
                    createdAt: stats.birthtime,
                };
            })
                .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
        }
        catch (error) {
            this.logger.error(`Listing exports failed: ${error.message}`);
            throw new common_1.InternalServerErrorException('Failed to list exports');
        }
    }
    async getExportFilePath(filename) {
        const safeFilename = path.basename(filename);
        const filePath = path.join(this.exportPath, safeFilename);
        if (!fs.existsSync(filePath)) {
            throw new common_1.NotFoundException('Export file not found');
        }
        return filePath;
    }
    async appendDataToArchive(archive) {
        archive.append(JSON.stringify({ info: "Export started", date: new Date(), version: "1.0" }), { name: 'metadata.json' });
        await this.exportCatalogs(archive);
        await this.exportBuques(archive);
        await this.exportMareas(archive);
        await archive.finalize();
    }
    async exportCatalogs(archive) {
        this.logger.log('Exporting catalogs...');
        const especies = await this.prisma.especie.findMany();
        let especiesJsonl = '';
        especies.forEach(e => especiesJsonl += JSON.stringify(e) + '\n');
        archive.append(especiesJsonl, { name: 'especies.jsonl' });
        const puertos = await this.prisma.puerto.findMany();
        let puertosJsonl = '';
        puertos.forEach(p => puertosJsonl += JSON.stringify(p) + '\n');
        archive.append(puertosJsonl, { name: 'puertos.jsonl' });
        const tiposFlota = await this.prisma.tipoFlota.findMany();
        let tfJsonl = '';
        tiposFlota.forEach(t => tfJsonl += JSON.stringify(t) + '\n');
        archive.append(tfJsonl, { name: 'tipos_flota.jsonl' });
        const artes = await this.prisma.artePesca.findMany();
        let artesJsonl = '';
        artes.forEach(a => artesJsonl += JSON.stringify(a) + '\n');
        archive.append(artesJsonl, { name: 'artes_pesca.jsonl' });
        const estados = await this.prisma.estadoMarea.findMany();
        let estadosJsonl = '';
        estados.forEach(e => estadosJsonl += JSON.stringify(e) + '\n');
        archive.append(estadosJsonl, { name: 'marea_estados.jsonl' });
        const transiciones = await this.prisma.transicionEstado.findMany({
            include: { estadoOrigen: true, estadoDestino: true }
        });
        let transJsonl = '';
        transiciones.forEach(t => {
            const exportData = {
                ...t,
                estadoOrigenCodigo: t.estadoOrigen.codigo,
                estadoDestinoCodigo: t.estadoDestino.codigo,
                id: undefined,
                estadoOrigenId: undefined,
                estadoDestinoId: undefined,
                estadoOrigen: undefined,
                estadoDestino: undefined
            };
            transJsonl += JSON.stringify(exportData) + '\n';
        });
        archive.append(transJsonl, { name: 'marea_transiciones.jsonl' });
        const observadores = await this.prisma.observador.findMany();
        let obsJsonl = '';
        observadores.forEach(o => obsJsonl += JSON.stringify(o) + '\n');
        archive.append(obsJsonl, { name: 'observadores.jsonl' });
        const pesquerias = await this.prisma.pesqueria.findMany();
        let pesqJsonl = '';
        pesquerias.forEach(p => pesqJsonl += JSON.stringify(p) + '\n');
        archive.append(pesqJsonl, { name: 'pesquerias.jsonl' });
    }
    async exportBuques(archive) {
        this.logger.log('Exporting buques...');
        const buques = await this.prisma.buque.findMany({
            include: {
                tipoFlota: true,
                puertoBase: true,
                arteHabitual: true,
                pesqueriaHabitual: true
            }
        });
        let buquesJsonl = '';
        buques.forEach(b => {
            const exportData = {
                ...b,
                tipoFlotaCodigo: b.tipoFlota?.codigo,
                puertoBaseCodigo: b.puertoBase?.codigoInterno || b.puertoBase?.nombre,
                arteHabitualCodigo: b.arteHabitual?.codigoNumerico,
                pesqueriaHabitualCodigo: b.pesqueriaHabitual?.codigo,
                tipoFlotaId: undefined,
                puertoBaseId: undefined,
                arteHabitualId: undefined,
                pesqueriaHabitualId: undefined,
                tipoFlota: undefined,
                puertoBase: undefined,
                arteHabitual: undefined,
                pesqueriaHabitual: undefined
            };
            buquesJsonl += JSON.stringify(exportData) + '\n';
        });
        archive.append(buquesJsonl, { name: 'buques.jsonl' });
    }
    async exportMareas(archive) {
        this.logger.log('Exporting mareas (Deep Export)...');
        const users = await this.prisma.user.findMany();
        const userMap = new Map(users.map(u => [u.id, u.email]));
        const allEstados = await this.prisma.estadoMarea.findMany();
        const estadoMap = new Map(allEstados.map(e => [e.id, e.codigo]));
        const mareas = await this.prisma.marea.findMany({
            include: {
                buque: true,
                artePrincipal: true,
                estadoActual: true,
                etapas: {
                    include: {
                        puertoZarpada: true,
                        puertoArribo: true,
                        pesqueria: true,
                        lances: {
                            include: {
                                capturas: { include: { especie: true } },
                                muestras: {
                                    include: {
                                        especie: true,
                                        submuestras: true,
                                        detallesTalla: true
                                    }
                                }
                            }
                        },
                        observadores: {
                            include: { observador: true }
                        }
                    }
                },
                movimientos: {
                    include: { estadoDesde: true, estadoHasta: true }
                },
                producciones: {
                    include: { especie: true }
                },
                archivos: true
            }
        });
        let mareasJsonl = '';
        for (const m of mareas) {
            const mareaExport = {
                ...m,
                buqueMatricula: m.buque.matricula,
                artePrincipalCodigo: m.artePrincipal?.codigoNumerico,
                estadoActualCodigo: m.estadoActual.codigo,
                etapas: m.etapas.map(etapa => ({
                    ...etapa,
                    puertoZarpadaCodigo: etapa.puertoZarpada?.codigoInterno || etapa.puertoZarpada?.nombre,
                    puertoArriboCodigo: etapa.puertoArribo?.codigoInterno || etapa.puertoArribo?.nombre,
                    pesqueriaCodigo: etapa.pesqueria?.codigo,
                    observadores: etapa.observadores.map(obs => ({
                        ...obs,
                        observadorCodigo: obs.observador.codigoInterno,
                        id: undefined,
                        observadorId: undefined,
                        observador: undefined,
                        etapaId: undefined
                    })),
                    lances: etapa.lances.map(lance => ({
                        ...lance,
                        capturas: lance.capturas.map(captura => ({
                            ...captura,
                            especieCodigo: captura.especie.codigo,
                            id: undefined,
                            especieId: undefined,
                            especie: undefined,
                            lanceId: undefined
                        })),
                        muestras: lance.muestras.map(muestra => ({
                            ...muestra,
                            especieCodigo: muestra.especie.codigo,
                            submuestras: muestra.submuestras.map(sm => ({
                                ...sm,
                                id: undefined,
                                muestraId: undefined
                            })),
                            detallesTalla: muestra.detallesTalla.map(dt => ({
                                ...dt,
                                id: undefined,
                                muestraId: undefined
                            })),
                            id: undefined,
                            especieId: undefined,
                            especie: undefined,
                            lanceId: undefined
                        })),
                        id: undefined,
                        etapaId: undefined
                    })),
                    id: undefined,
                    puertoZarpadaId: undefined,
                    puertoArriboId: undefined,
                    pesqueriaId: undefined,
                    mareaId: undefined,
                    puertoZarpada: undefined,
                    puertoArribo: undefined,
                    pesqueria: undefined
                })),
                movimientos: m.movimientos.map(mov => ({
                    ...mov,
                    usuarioEmail: mov.usuarioId ? userMap.get(mov.usuarioId) : null,
                    estadoDesdeCodigo: mov.estadoDesdeId ? estadoMap.get(mov.estadoDesdeId) : null,
                    estadoHastaCodigo: mov.estadoHastaId ? estadoMap.get(mov.estadoHastaId) : null,
                    id: undefined,
                    usuarioId: undefined,
                    estadoDesdeId: undefined,
                    estadoHastaId: undefined,
                    mareaId: undefined,
                    estadoDesde: undefined,
                    estadoHasta: undefined
                })),
                producciones: m.producciones.map(prod => ({
                    ...prod,
                    especieCodigo: prod.especie.codigo,
                    id: undefined,
                    especieId: undefined,
                    mareaId: undefined,
                    especie: undefined
                })),
                archivos: m.archivos.map(arch => ({
                    ...arch,
                    usuarioSubioEmail: arch.usuarioSubioId ? userMap.get(arch.usuarioSubioId) : null,
                    id: undefined,
                    mareaId: undefined,
                    movimientoOrigenId: undefined,
                    usuarioSubioId: undefined
                })),
                id: undefined,
                buqueId: undefined,
                artePrincipalId: undefined,
                estadoActualId: undefined,
                buque: undefined,
                artePrincipal: undefined,
                estadoActual: undefined
            };
            mareasJsonl += JSON.stringify(mareaExport) + '\n';
        }
        archive.append(mareasJsonl, { name: 'mareas.jsonl' });
    }
    async importData(filePath) {
        this.logger.log(`Starting import from: ${filePath}`);
        if (!fs.existsSync(filePath)) {
            throw new common_1.NotFoundException('File not found');
        }
        const zip = new AdmZip(filePath);
        const zipEntries = zip.getEntries();
        const metadataEntry = zipEntries.find(entry => entry.entryName === 'metadata.json');
        if (!metadataEntry) {
            throw new common_1.BadRequestException('Invalid archive: metadata.json missing');
        }
        await this.importCatalogs(zip);
        await this.importBuques(zip);
        await this.importMareas(zip);
        return { message: 'Import processed successfully' };
    }
    async importCatalogs(zip) {
        this.logger.log('Importing catalogs...');
        const readJsonl = (name) => {
            const entry = zip.getEntry(name);
            if (!entry)
                return [];
            return zip.readAsText(entry).split('\n').filter(l => l.trim()).map(l => JSON.parse(l));
        };
        const especies = readJsonl('especies.jsonl');
        for (const e of especies) {
            await this.prisma.especie.upsert({
                where: { codigo: e.codigo },
                update: { ...e, id: undefined },
                create: { ...e, id: undefined }
            });
        }
        const puertos = readJsonl('puertos.jsonl');
        for (const p of puertos) {
            if (p.codigoInterno) {
                await this.prisma.puerto.upsert({
                    where: { codigoInterno: p.codigoInterno },
                    update: { ...p, id: undefined },
                    create: { ...p, id: undefined }
                });
            }
            else {
                const existing = await this.prisma.puerto.findFirst({ where: { nombre: p.nombre } });
                if (existing) {
                    await this.prisma.puerto.update({ where: { id: existing.id }, data: { ...p, id: undefined } });
                }
                else {
                    await this.prisma.puerto.create({ data: { ...p, id: undefined } });
                }
            }
        }
        const tipos = readJsonl('tipos_flota.jsonl');
        for (const t of tipos) {
            await this.prisma.tipoFlota.upsert({
                where: { codigo: t.codigo },
                update: { ...t, id: undefined },
                create: { ...t, id: undefined }
            });
        }
        const artes = readJsonl('artes_pesca.jsonl');
        for (const a of artes) {
            await this.prisma.artePesca.upsert({
                where: { codigoNumerico: a.codigoNumerico },
                update: { ...a, id: undefined },
                create: { ...a, id: undefined }
            });
        }
        const estados = readJsonl('marea_estados.jsonl');
        for (const e of estados) {
            await this.prisma.estadoMarea.upsert({
                where: { codigo: e.codigo },
                update: { ...e, id: undefined },
                create: { ...e, id: undefined }
            });
        }
        const observadores = readJsonl('observadores.jsonl');
        for (const o of observadores) {
            await this.prisma.observador.upsert({
                where: { codigoInterno: o.codigoInterno },
                update: { ...o, id: undefined },
                create: { ...o, id: undefined }
            });
        }
        const pesquerias = readJsonl('pesquerias.jsonl');
        for (const p of pesquerias) {
            await this.prisma.pesqueria.upsert({
                where: { codigo: p.codigo },
                update: { ...p, id: undefined },
                create: { ...p, id: undefined }
            });
        }
        const transiciones = readJsonl('marea_transiciones.jsonl');
        for (const t of transiciones) {
            const origen = await this.prisma.estadoMarea.findUnique({ where: { codigo: t.estadoOrigenCodigo } });
            const destino = await this.prisma.estadoMarea.findUnique({ where: { codigo: t.estadoDestinoCodigo } });
            if (origen && destino) {
                await this.prisma.transicionEstado.upsert({
                    where: {
                        estadoOrigenId_estadoDestinoId_accion: {
                            estadoOrigenId: origen.id,
                            estadoDestinoId: destino.id,
                            accion: t.accion
                        }
                    },
                    update: {
                        ...t,
                        id: undefined,
                        estadoOrigenCodigo: undefined,
                        estadoDestinoCodigo: undefined,
                        estadoOrigenId: origen.id,
                        estadoDestinoId: destino.id
                    },
                    create: {
                        ...t,
                        id: undefined,
                        estadoOrigenCodigo: undefined,
                        estadoDestinoCodigo: undefined,
                        estadoOrigenId: origen.id,
                        estadoDestinoId: destino.id
                    }
                });
            }
        }
    }
    async importBuques(zip) {
        this.logger.log('Importing buques...');
        const entry = zip.getEntry('buques.jsonl');
        if (!entry)
            return;
        const buques = zip.readAsText(entry).split('\n').filter(l => l.trim()).map(l => JSON.parse(l));
        const tiposFlota = await this.prisma.tipoFlota.findMany();
        const tipoMap = new Map(tiposFlota.map(t => [t.codigo, t.id]));
        const puertos = await this.prisma.puerto.findMany();
        const puertoCodeMap = new Map(puertos.filter(p => p.codigoInterno).map(p => [p.codigoInterno, p.id]));
        const puertoNameMap = new Map(puertos.map(p => [p.nombre, p.id]));
        const artes = await this.prisma.artePesca.findMany();
        const arteMap = new Map(artes.map(a => [a.codigoNumerico, a.id]));
        const pesquerias = await this.prisma.pesqueria.findMany();
        const pesqMap = new Map(pesquerias.map(p => [p.codigo, p.id]));
        for (const b of buques) {
            const tipoFlotaId = b.tipoFlotaCodigo ? tipoMap.get(b.tipoFlotaCodigo) : null;
            let puertoBaseId = null;
            if (b.puertoBaseCodigo) {
                puertoBaseId = puertoCodeMap.get(b.puertoBaseCodigo);
                if (!puertoBaseId)
                    puertoBaseId = puertoNameMap.get(b.puertoBaseCodigo);
            }
            const arteHabitualId = b.arteHabitualCodigo ? arteMap.get(b.arteHabitualCodigo) : null;
            const pesqueriaHabitualId = b.pesqueriaHabitualCodigo ? pesqMap.get(b.pesqueriaHabitualCodigo) : null;
            const buqueData = {
                matricula: b.matricula,
                nombreBuque: b.nombreBuque || b.nombre,
                senalDistintiva: b.senalDistintiva,
                codigoINIDEP: b.codigoINIDEP,
                activo: b.activo,
                esloraM: b.esloraM || b.eslora,
                manga: b.manga,
                puntal: b.puntal,
                potenciaHp: b.potenciaHp || b.potencia,
                capacidadBodega: b.capacidadBodega,
                anioConstruccion: b.anioConstruccion,
                shipistId: b.shipistId,
                observaciones: b.observaciones,
                tipoFlotaId,
                puertoBaseId,
                arteHabitualId,
                pesqueriaHabitualId
            };
            await this.prisma.buque.upsert({
                where: { matricula: b.matricula },
                update: buqueData,
                create: buqueData
            });
        }
    }
    async importMareas(zip) {
        this.logger.log('Importing mareas...');
        const entry = zip.getEntry('mareas.jsonl');
        if (!entry)
            return;
        const mareas = zip.readAsText(entry).split('\n').filter(l => l.trim()).map(l => JSON.parse(l));
        const estados = await this.prisma.estadoMarea.findMany();
        const estadoMap = new Map(estados.map(e => [e.codigo, e.id]));
        const artes = await this.prisma.artePesca.findMany();
        const arteMap = new Map(artes.map(a => [a.codigoNumerico, a.id]));
        const buques = await this.prisma.buque.findMany();
        const buqueMap = new Map(buques.map(b => [b.matricula, b.id]));
        const especies = await this.prisma.especie.findMany();
        const especieMap = new Map(especies.map(e => [e.codigo, e.id]));
        const puertos = await this.prisma.puerto.findMany();
        const puertoCodeMap = new Map(puertos.filter(p => p.codigoInterno).map(p => [p.codigoInterno, p.id]));
        const puertoNameMap = new Map(puertos.map(p => [p.nombre, p.id]));
        const pesquerias = await this.prisma.pesqueria.findMany();
        const pesqMap = new Map(pesquerias.map(p => [p.codigo, p.id]));
        const observadores = await this.prisma.observador.findMany();
        const obCodeMap = new Map(observadores.filter(o => o.codigoInterno).map(o => [o.codigoInterno, o.id]));
        const users = await this.prisma.user.findMany();
        const userMap = new Map(users.map(u => [u.email, u.id]));
        for (const m of mareas) {
            const buqueId = buqueMap.get(m.buqueMatricula);
            if (!buqueId) {
                this.logger.warn(`Skipping Marea for missing Buque: ${m.buqueMatricula}`);
                continue;
            }
            const exists = await this.prisma.marea.findUnique({
                where: {
                    identificadorMarea: {
                        anioMarea: m.anioMarea,
                        nroMarea: m.nroMarea,
                        buqueId: buqueId,
                        tipoMarea: m.tipoMarea || 'MC'
                    }
                }
            });
            if (exists) {
                this.logger.log(`Skipping existing Marea ${m.anioMarea}-${m.nroMarea} for Buque ${m.buqueMatricula}`);
                continue;
            }
            const mareaData = {
                anioMarea: m.anioMarea,
                nroMarea: m.nroMarea,
                tipoMarea: m.tipoMarea || 'MC',
                fechaZarpadaEstimada: m.fechaZarpadaEstimada ? new Date(m.fechaZarpadaEstimada) : null,
                fechaInicioObservador: m.fechaInicioObservador ? new Date(m.fechaInicioObservador) : null,
                fechaFinObservador: m.fechaFinObservador ? new Date(m.fechaFinObservador) : null,
                diasZonaAustral: m.diasZonaAustral,
                tipoCalculoZonaAustral: m.tipoCalculoZonaAustral,
                nroProtocolizacion: m.nroProtocolizacion,
                anioProtocolizacion: m.anioProtocolizacion,
                fechaProtocolizacion: m.fechaProtocolizacion ? new Date(m.fechaProtocolizacion) : null,
                observaciones: m.observaciones,
                activo: m.activo,
                diasEstimados: m.diasEstimados,
                buque: { connect: { id: buqueId } },
                estadoActual: { connect: { id: estadoMap.get(m.estadoActualCodigo) || estadoMap.get('INI') } },
                artePrincipal: m.artePrincipalCodigo ? { connect: { id: arteMap.get(m.artePrincipalCodigo) } } : undefined,
                etapas: {
                    create: m.etapas?.map((et) => ({
                        nroEtapa: et.nroEtapa || 1,
                        tipoEtapa: et.tipoEtapa || 'PESCA',
                        fechaZarpada: et.fechaZarpada ? new Date(et.fechaZarpada) : undefined,
                        fechaArribo: et.fechaArribo ? new Date(et.fechaArribo) : undefined,
                        observaciones: et.observaciones,
                        puertoZarpada: et.puertoZarpadaCodigo ? { connect: { id: puertoCodeMap.get(et.puertoZarpadaCodigo) || puertoNameMap.get(et.puertoZarpadaCodigo) } } : undefined,
                        puertoArribo: et.puertoArriboCodigo ? { connect: { id: puertoCodeMap.get(et.puertoArriboCodigo) || puertoNameMap.get(et.puertoArriboCodigo) } } : undefined,
                        pesqueria: et.pesqueriaCodigo ? { connect: { id: pesqMap.get(et.pesqueriaCodigo) } } : undefined,
                        lances: {
                            create: et.lances?.map((l) => ({
                                numeroLance: l.numeroLance,
                                fecha: l.fecha ? new Date(l.fecha) : new Date(),
                                codArtePesca: l.codArtePesca || m.artePrincipalCodigo || 1,
                                tipoArtePesca: l.tipoArtePesca,
                                horaInicio: l.horaInicio,
                                latInicio: l.latInicio,
                                longInicio: l.longInicio,
                                profInicio: l.profInicio,
                                horaFinal: l.horaFinal,
                                latFinal: l.latFinal,
                                longFinal: l.longFinal,
                                profFinal: l.profFinal,
                                rumbo: l.rumbo,
                                distanciaRed: l.distanciaRed,
                                velocidadArrastre: l.velocidadArrastre,
                                tiempoRed: l.tiempoRed,
                                estacionGral: l.estacionGral,
                                calador: l.calador,
                                fondoMin: l.fondoMin,
                                fondoMax: l.fondoMax,
                                tamiz: l.tamiz,
                                areaBarrida: l.areaBarrida,
                                capturaTotalKg: l.capturaTotalKg,
                                descarteTotalKg: l.descarteTotalKg,
                                observacionesLance: l.observacionesLance,
                                mus: l.mus,
                                fuenteDato: l.fuenteDato,
                                capturas: {
                                    create: l.capturas?.map((c) => ({
                                        kgCaptura: c.kgCaptura || c.pesoKgs || 0,
                                        kgDescarte: c.kgDescarte || 0,
                                        observacionesCaptura: c.observacionesCaptura,
                                        indiceOriginal: c.indiceOriginal || 0,
                                        especie: { connect: { id: especieMap.get(c.especieCodigo) } }
                                    }))
                                },
                                muestras: {
                                    create: l.muestras?.map((mu) => ({
                                        tipoMuestra: mu.tipoMuestra,
                                        pesoMuestraKg: mu.pesoMuestraKg,
                                        factPonderacion: mu.factPonderacion,
                                        unidadLargo: mu.unidadLargo || 'MM',
                                        primeraTalla: mu.primeraTalla,
                                        ultimaTalla: mu.ultimaTalla,
                                        intervaloMm: mu.intervaloMm,
                                        totalMediciones: mu.totalMediciones,
                                        observaciones: mu.observaciones,
                                        especie: { connect: { id: especieMap.get(mu.especieCodigo) } },
                                        submuestras: {
                                            create: mu.submuestras?.map((sm) => ({
                                                ...sm,
                                                id: undefined,
                                                muestraId: undefined
                                            }))
                                        },
                                        detallesTalla: {
                                            create: mu.detallesTalla?.map((dt) => ({
                                                ...dt,
                                                id: undefined,
                                                muestraId: undefined
                                            }))
                                        }
                                    }))
                                }
                            }))
                        },
                        observadores: {
                            create: et.observadores?.map((eo) => ({
                                rol: eo.rol,
                                esDesignado: eo.esDesignado !== undefined ? eo.esDesignado : true,
                                observador: { connect: { id: obCodeMap.get(eo.observadorCodigo) } }
                            })).filter((o) => o.observador?.connect?.id)
                        }
                    }))
                },
                movimientos: {
                    create: m.movimientos?.map((mov) => ({
                        fechaHora: new Date(mov.fechaHora || mov.fecha),
                        tipoEvento: mov.tipoEvento || 'CAMBIO_ESTADO',
                        usuario: userMap.get(mov.usuarioEmail) ? { connect: { id: userMap.get(mov.usuarioEmail) } } : undefined,
                        estadoDesde: mov.estadoDesdeCodigo ? { connect: { id: estadoMap.get(mov.estadoDesdeCodigo) } } : undefined,
                        estadoHasta: mov.estadoHastaCodigo ? { connect: { id: estadoMap.get(mov.estadoHastaCodigo) } } : undefined,
                        detalle: mov.detalle || mov.comentario,
                        cantidadMuestrasOtolitos: mov.cantidadMuestrasOtolitos
                    }))
                },
                producciones: {
                    create: m.producciones?.map((p) => ({
                        fecha: new Date(p.fecha),
                        producto: p.producto,
                        categoria: p.categoria,
                        factorConversion: p.factorConversion,
                        kgProduccion: p.kgProduccion || 0,
                        operarios: p.operarios,
                        especie: { connect: { id: especieMap.get(p.especieCodigo) } }
                    }))
                },
                archivos: {
                    create: m.archivos?.map((a) => ({
                        tipoArchivo: a.tipoArchivo || 'GENERAL',
                        formato: a.formato,
                        version: a.version,
                        rutaArchivo: a.rutaArchivo,
                        tamanoBytes: a.tamanoBytes,
                        descripcion: a.descripcion,
                        usuarioSubio: a.usuarioSubioEmail ? { connect: { id: userMap.get(a.usuarioSubioEmail) } } : undefined
                    }))
                }
            };
            await this.prisma.marea.create({
                data: mareaData
            });
        }
    }
};
exports.DataExportService = DataExportService;
exports.DataExportService = DataExportService = DataExportService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        config_1.ConfigService])
], DataExportService);
//# sourceMappingURL=data-export.service.js.map