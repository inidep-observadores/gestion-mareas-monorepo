import * as dotenv from 'dotenv';
import * as path from 'path';
import * as fs from 'fs';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as bcrypt from 'bcrypt';

dotenv.config();

function expandEnv(str: string | undefined): string | undefined {
  if (!str) return str;
  return str.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '');
}

// Cargar .env.develop si DATABASE_URL no está definido o tiene variables sin expandir
if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
  dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}

process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('--- Iniciando Seed Mínimo (Usuarios y Catálogos) ---');

  // 1. Limpieza de seguridad (Respetando restricciones de integridad)
  console.log('Limpiando tablas...');
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

  // 2. Usuarios
  console.log('Creando usuarios básicos...');
  const password = await bcrypt.hash('Obs123', 10);
  const usersData = [
    { email: 'admin@obs.com', fullName: 'Administrador Sistema', password: password, roles: ['admin'] },
    { email: 'tecnico@obs.com', fullName: 'Técnico de Datos', password: password, roles: ['tecnico_datos'] },
    { email: 'danieldt2000@hotmail.com', fullName: 'Daniel Di Tullio', password: password, roles: ['tecnico_datos'] },
  ];

  for (const userData of usersData) {
    await prisma.user.create({ data: userData });
  }
  console.log(`Usuarios creados: ${usersData.length}`);

  // 3. Estados de Marea
  console.log('Cargando Estados de Marea...');
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

  for (const data of estadosMareaData) {
    await prisma.estadoMarea.create({ data });
  }

  // 4. Transiciones
  console.log('Cargando Transiciones...');
  const allEstados = await prisma.estadoMarea.findMany();
  const getEstadoId = (codigo: string) => allEstados.find(e => e.codigo === codigo)?.id;

  const transicionesData = [
    { from: 'DESIGNADA', to: 'EN_EJECUCION', action: 'REGISTRAR_INICIO', label: 'Registrar Inicio', btn: 'primary' },
    { from: 'EN_EJECUCION', to: 'ESPERANDO_ENTREGA', action: 'REGISTRAR_ARRIBO', label: 'Confirmar Arribo', btn: 'primary' },
    { from: 'ESPERANDO_ENTREGA', to: 'ENTREGADA_RECIBIDA', action: 'RECIBIR_DATOS', label: 'Recibir Archivos de Marea', btn: 'primary' },
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

  // 5. Catálogos desde JSONL
  const catalogs = [
    { name: 'Puertos', file: 'puertos.jsonl', model: prisma.puerto },
    { name: 'Pesquerías', file: 'pesquerias.jsonl', model: prisma.pesqueria },
    { name: 'Especies', file: 'especies.jsonl', model: prisma.especie },
    { name: 'Tipos de Flota', file: 'tipos_flota.jsonl', model: prisma.tipoFlota },
    { name: 'Artes de Pesca', file: 'artes_pesca.jsonl', model: prisma.artePesca },
  ];

  for (const catalog of catalogs) {
    const jsonlPath = path.join(__dirname, 'data', catalog.file);
    if (fs.existsSync(jsonlPath)) {
      console.log(`Cargando catálogo: ${catalog.name}...`);
      const data = fs.readFileSync(jsonlPath, 'utf8')
        .split('\n')
        .filter(line => line.trim())
        .map(line => JSON.parse(line));
      
      if ('createMany' in catalog.model) {
        await (catalog.model as any).createMany({ data });
      } else {
        for (const item of data) {
          await (catalog.model as any).create({ data: item });
        }
      }
    } else {
      console.warn(`Archivo no encontrado para ${catalog.name}: ${jsonlPath}`);
    }
  }

  console.log('--- Seed Mínimo Completado con Éxito ---');
}

main()
  .catch((e) => {
    console.error('Error en Seed Mínimo:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
