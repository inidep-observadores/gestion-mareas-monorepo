import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config();
if (!process.env.DATABASE_URL) {
  console.log('Loading .env.develop...');
  dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as bcrypt from 'bcrypt';
import { Pool } from 'pg';
import * as fs from 'fs';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Seeding database...');

  // Limpiar datos existentes respetando restricciones de integridad
  await prisma.muestraDetalleTalla.deleteMany();
  await prisma.submuestra.deleteMany();
  await prisma.muestra.deleteMany();
  await prisma.captura.deleteMany();
  await prisma.lance.deleteMany();
  await prisma.mareaEtapaObservador.deleteMany();
  await prisma.mareaEtapa.deleteMany();
  await prisma.mareaArchivo.deleteMany();
  await prisma.mareaMovimiento.deleteMany();
  await prisma.produccion.deleteMany();
  await prisma.marea.deleteMany();

  await prisma.productImage.deleteMany();
  await prisma.product.deleteMany();
  await prisma.observadorPesqueria.deleteMany();
  await prisma.buque.deleteMany();
  await prisma.artePesca.deleteMany();
  await prisma.observador.deleteMany();
  await prisma.puerto.deleteMany();
  await prisma.pesqueria.deleteMany();
  await prisma.especie.deleteMany();
  await prisma.tipoFlota.deleteMany();
  await prisma.errorLog.deleteMany();
  await prisma.transicionEstado.deleteMany();
  await prisma.estadoMarea.deleteMany();
  await prisma.passwordResetToken.deleteMany();
  await prisma.user.deleteMany();

  const estadosMareaData = [
    { codigo: 'DESIGNADA', nombre: 'Designada', categoria: 'PENDIENTE', orden: 1, esInicial: true, esFinal: false, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: false, mostrarEnPanel: true },
    { codigo: 'EN_EJECUCION', nombre: 'En ejecución', categoria: 'PENDIENTE', orden: 2, esInicial: false, esFinal: false, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: false, mostrarEnPanel: true },
    { codigo: 'ESPERANDO_ENTREGA', nombre: 'Esperando entrega de datos', categoria: 'PENDIENTE', orden: 3, esInicial: false, esFinal: false, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: false, mostrarEnPanel: true },
    { codigo: 'ENTREGADA_RECIBIDA', nombre: 'Entregada / Recibida', categoria: 'PENDIENTE', orden: 4, esInicial: false, esFinal: false, permiteCargaArchivos: true, permiteCorreccion: false, permiteInforme: false, mostrarEnPanel: true },
    { codigo: 'VERIFICACION_INICIAL', nombre: 'Verificación inicial', categoria: 'EN_CURSO', orden: 5, esInicial: false, esFinal: false, permiteCargaArchivos: true, permiteCorreccion: false, permiteInforme: false, mostrarEnPanel: true },
    { codigo: 'EN_CORRECCION', nombre: 'En corrección interna', categoria: 'EN_CURSO', orden: 6, esInicial: false, esFinal: false, permiteCargaArchivos: true, permiteCorreccion: true, permiteInforme: false, mostrarEnPanel: true },
    { codigo: 'DELEGADA_EXTERNA', nombre: 'Delegada / En espera externa', categoria: 'EN_CURSO', orden: 7, esInicial: false, esFinal: false, permiteCargaArchivos: true, permiteCorreccion: false, permiteInforme: false, mostrarEnPanel: false },
    { codigo: 'PENDIENTE_DE_INFORME', nombre: 'Pendiente de informe', categoria: 'EN_CURSO', orden: 8, esInicial: false, esFinal: false, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: true, mostrarEnPanel: true },
    { codigo: 'ESPERANDO_REVISION', nombre: 'Esperando revisión de informe', categoria: 'EN_CURSO', orden: 9, esInicial: false, esFinal: false, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: true, mostrarEnPanel: false },
    { codigo: 'PARA_PROTOCOLIZAR', nombre: 'Para protocolizar', categoria: 'EN_CURSO', orden: 10, esInicial: false, esFinal: false, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: true, mostrarEnPanel: false },
    { codigo: 'ESPERANDO_PROTOCOLIZACION', nombre: 'Esperando protocolización', categoria: 'EN_CURSO', orden: 11, esInicial: false, esFinal: false, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: true, mostrarEnPanel: false },
    { codigo: 'PROTOCOLIZADA', nombre: 'Protocolizada / Finalizada', categoria: 'COMPLETADO', orden: 12, esInicial: false, esFinal: true, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: true, mostrarEnPanel: false },
    { codigo: 'CANCELADA', nombre: 'Cancelada / Desestimada', categoria: 'CANCELADO', orden: 13, esInicial: false, esFinal: true, permiteCargaArchivos: false, permiteCorreccion: false, permiteInforme: false, mostrarEnPanel: false }
  ];

  console.log('Seeding EstadosMarea...');
  // Usamos create en lugar de createMany para obtener los IDs si es necesario, 
  // o simplemente los consultamos después.
  for (const data of estadosMareaData) {
    await prisma.estadoMarea.create({ data });
  }
  console.log('EstadosMarea seeded successfully!');

  // --- SEMILLAS PARA TRANSICIONES DE ESTADOS ---
  console.log('Seeding Transiciones...');
  const allEstados = await prisma.estadoMarea.findMany();
  const getEstadoId = (codigo: string) => allEstados.find(e => e.codigo === codigo)?.id;

  const transicionesData = [
    { from: 'DESIGNADA', to: 'EN_EJECUCION', action: 'REGISTRAR_INICIO', label: 'Registrar Inicio', btn: 'primary' },
    { from: 'EN_EJECUCION', to: 'ESPERANDO_ENTREGA', action: 'REGISTRAR_ARRIBO', label: 'Confirmar Arribo', btn: 'primary' },
    { from: 'ESPERANDO_ENTREGA', to: 'ENTREGADA_RECIBIDA', action: 'RECIBIR_DATOS', label: 'Recibir Archivos', btn: 'primary' },
    { from: 'ENTREGADA_RECIBIDA', to: 'VERIFICACION_INICIAL', action: 'INICIAR_VERIFICACION', label: 'Iniciar Verificación', btn: 'primary' },
    { from: 'VERIFICACION_INICIAL', to: 'EN_CORRECCION', action: 'ABRIR_CORRECCION', label: 'Abrir Corrección', btn: 'secondary' },
    { from: 'VERIFICACION_INICIAL', to: 'PENDIENTE_DE_INFORME', action: 'PASAR_A_INFORME', label: 'Pasar a Informe', btn: 'primary' },
    { from: 'EN_CORRECCION', to: 'PENDIENTE_DE_INFORME', action: 'FINALIZAR_CORRECCION', label: 'Finalizar Corrección', btn: 'primary' },
    { from: 'EN_CORRECCION', to: 'DELEGADA_EXTERNA', action: 'DELEGAR_EXTERNA', label: 'Derivar a Proyecto', btn: 'secondary' },
    { from: 'DELEGADA_EXTERNA', to: 'EN_CORRECCION', action: 'RETORNAR_CORRECCION', label: 'Devolución Externa', btn: 'primary' },
    { from: 'PENDIENTE_DE_INFORME', to: 'ESPERANDO_REVISION', action: 'ENVIAR_A_REVISION', label: 'Enviar a Revisión', btn: 'primary' },
    { from: 'ESPERANDO_REVISION', to: 'PARA_PROTOCOLIZAR', action: 'APROBAR_INFORME', label: 'Aprobar Informe', btn: 'primary' },
    { from: 'ESPERANDO_REVISION', to: 'PENDIENTE_DE_INFORME', action: 'RECHAZAR_INFORME', label: 'Observaciones en Informe', btn: 'secondary' },
    { from: 'PARA_PROTOCOLIZAR', to: 'ESPERANDO_PROTOCOLIZACION', action: 'INICIAR_TRAMITE', label: 'Iniciar Protocolización', btn: 'primary' },
    { from: 'ESPERANDO_PROTOCOLIZACION', to: 'PROTOCOLIZADA', action: 'FINALIZAR_PROTOCOLIZACION', label: 'Finalizar Protocolización', btn: 'primary' },
  ];

  for (const t of transicionesData) {
    const fromId = getEstadoId(t.from);
    const toId = getEstadoId(t.to);
    if (fromId && toId) {
      await prisma.transicionEstado.create({
        data: {
          estadoOrigenId: fromId,
          estadoDestinoId: toId,
          accion: t.action,
          etiqueta: t.label,
          claseBoton: t.btn,
          activo: true
        }
      });
    }
  }
  console.log('Transiciones seeded successfully!');

  const password = await bcrypt.hash('Obs123', 10);

  const usersData = [
    {
      email: 'admin@obs.com',
      fullName: 'Administrador Sistema',
      password: password,
      roles: ['admin'],
    },
    {
      email: 'coordinador@obs.com',
      fullName: 'Coordinador Operativo',
      password: password,
      roles: ['coordinador'],
    },
    {
      email: 'tecnico@obs.com',
      fullName: 'Técnico de Datos',
      password: password,
      roles: ['tecnico_datos'],
    },
    {
      email: 'asistente@obs.com',
      fullName: 'Asistente Administrativo',
      password: password,
      roles: ['asistente_administrativo'],
    },
  ];

  for (const userData of usersData) {
    const user = await prisma.user.create({
      data: userData,
    });
    console.log(`Created user: ${user.email} with roles: ${user.roles.join(', ')}`);
  }

  // Seeding Observadores
  const jsonlPath = path.join(__dirname, 'data/observadores.jsonl');
  if (fs.existsSync(jsonlPath)) {
    const observadoresData = fs.readFileSync(jsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${observadoresData.length} observadores...`);

    // Using createMany for better performance
    await prisma.observador.createMany({
      data: observadoresData,
    });

    console.log('Observadores seeded successfully!');
  } else {
    console.warn('observadores.jsonl not found, skipping observadores seeding.');
  }

  // Seeding Puertos
  const puertosJsonlPath = path.join(__dirname, 'data/puertos.jsonl');
  if (fs.existsSync(puertosJsonlPath)) {
    const puertosData = fs.readFileSync(puertosJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${puertosData.length} puertos...`);

    for (const puerto of puertosData) {
      try {
        await prisma.puerto.create({
          data: puerto,
        });
      } catch (error: any) {
        console.error(`Error creating puerto: ${puerto.nombre}`);
        console.error(error.message || error);
        throw error;
      }
    }

    console.log('Puertos seeded successfully!');
  } else {
    console.warn('puertos.jsonl not found, skipping puertos seeding.');
  }

  // Seeding Pesquerías
  const pesqueriasJsonlPath = path.join(__dirname, 'data/pesquerias.jsonl');
  if (fs.existsSync(pesqueriasJsonlPath)) {
    const pesqueriasData = fs.readFileSync(pesqueriasJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${pesqueriasData.length} pesquerías...`);
    await prisma.pesqueria.createMany({ data: pesqueriasData });
    console.log('Pesquerías seeded successfully!');
  }

  // Seeding Especies
  const especiesJsonlPath = path.join(__dirname, 'data/especies.jsonl');
  if (fs.existsSync(especiesJsonlPath)) {
    const especiesData = fs.readFileSync(especiesJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${especiesData.length} especies...`);
    await prisma.especie.createMany({ data: especiesData });
    console.log('Especies seeded successfully!');
  }

  // Seeding Tipos de Flota
  const tiposFlotaJsonlPath = path.join(__dirname, 'data/tipos_flota.jsonl');
  if (fs.existsSync(tiposFlotaJsonlPath)) {
    const tiposFlotaData = fs.readFileSync(tiposFlotaJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${tiposFlotaData.length} tipos de flota...`);
    await prisma.tipoFlota.createMany({ data: tiposFlotaData });
    console.log('Tipos de flota seeded successfully!');
  }

  // Seeding Artes de Pesca from JSONL
  const artesJsonlPath = path.join(__dirname, 'data/artes_pesca.jsonl');
  if (fs.existsSync(artesJsonlPath)) {
    const artesData = fs.readFileSync(artesJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${artesData.length} artes de pesca...`);
    await prisma.artePesca.createMany({ data: artesData });
    console.log('Artes de Pesca seeded successfully!');
  }

  // Seeding Buques from JSONL
  const buquesJsonlPath = path.join(__dirname, 'data/buques.jsonl');
  if (fs.existsSync(buquesJsonlPath)) {
    console.log('Seeding Buques from JSONL...');
    const buquesData = fs.readFileSync(buquesJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    // Get all linked data for referencing
    const puertos = await prisma.puerto.findMany();
    const tiposFlota = await prisma.tipoFlota.findMany();
    const artesPesca = await prisma.artePesca.findMany();
    const pesquerias = await prisma.pesqueria.findMany();

    const getPesqueriaId = (flotaCodigo: string | null) => {
      if (!flotaCodigo) return null;
      let pesqueriaCodigo = '';

      switch (flotaCodigo) {
        case 'POTERO': pesqueriaCodigo = 'CALAMAR'; break;
        case 'TANGONERO': pesqueriaCodigo = 'LANGOSTINO'; break;
        case 'CENTOLLERO': pesqueriaCodigo = 'CENTOLLA'; break;
        case 'VIEIRERO': pesqueriaCodigo = 'VIEIRA'; break;
        case 'CONGELADOR_MERLUCERO':
        case 'SURIMERO':
        case 'FRESQUERO':
          pesqueriaCodigo = 'MERLUZA_COMUN'; break;
        case 'CONGELADOR_AUSTRAL': pesqueriaCodigo = 'AUSTRALES'; break;
        case 'PALANGRERO': pesqueriaCodigo = 'MERLUZA_NEGRA'; break;
        default: return null;
      }

      return pesquerias.find(p => p.codigo === pesqueriaCodigo)?.id || null;
    };

    const getPuertoId = (localidad: string) => {
      const loc = (localidad || '').toLowerCase().trim();
      if (!loc) return null;
      if (loc.includes('buenos aires')) return puertos.find(p => p.nombre.toLowerCase().includes('buenos aires'))?.id;
      if (loc.includes('madryn')) return puertos.find(p => p.nombre.toLowerCase().includes('madryn'))?.id;
      if (loc.includes('deseado')) return puertos.find(p => p.nombre.toLowerCase().includes('deseado'))?.id;
      if (loc.includes('san julian') || loc.includes('san julián')) return puertos.find(p => p.nombre.toLowerCase().includes('san julian'))?.id;
      if (loc.includes('rawson') || loc.includes('trelew')) return puertos.find(p => p.nombre.toLowerCase().includes('rawson'))?.id;
      if (loc.includes('comodoro') || loc.includes('rivadavia')) return puertos.find(p => p.nombre.toLowerCase().includes('comod'))?.id;
      if (loc.includes('ushuaia') || loc.includes('punta arenas')) return puertos.find(p => p.nombre.toLowerCase().includes('ushuaia'))?.id;

      const found = puertos.find(p => p.nombre.toLowerCase().includes(loc));
      return found?.id || null;
    };

    console.log(`Loading ${buquesData.length} buques...`);
    for (const buqueRaw of buquesData) {
      try {
        const { tipoFlotaCodigo, arteHabitualCodigo, empresaLocalidad, ...rest } = buqueRaw;

        const tpId = tiposFlota.find(tf => tf.codigo === tipoFlotaCodigo)?.id || null;

        await prisma.buque.create({
          data: {
            ...rest,
            empresaLocalidad,
            tipoFlotaId: tpId,
            arteHabitualId: artesPesca.find(ap => ap.codigoNumerico === arteHabitualCodigo)?.id || null,
            pesqueriaHabitualId: getPesqueriaId(tipoFlotaCodigo),
            puertoBaseId: getPuertoId(empresaLocalidad),
          }
        });
      } catch (error: any) {
        console.error(`Error creating buque: ${buqueRaw.nombreBuque} (Mat: ${buqueRaw.matricula})`);
        console.error(error.message || error);
      }
    }
    console.log('Buques seeding process completed!');
  }

  console.log('Seeding completed successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
