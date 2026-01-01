import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import 'dotenv/config';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

const estadosMarea = [
    {
        codigo: 'DESIGNADA',
        nombre: 'Designada',
        categoria: 'PENDIENTE',
        orden: 1,
        esInicial: true,
        esFinal: false,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: false
    },
    {
        codigo: 'EN_EJECUCION',
        nombre: 'En ejecución',
        categoria: 'PENDIENTE',
        orden: 2,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: false
    },
    {
        codigo: 'ESPERANDO_ENTREGA',
        nombre: 'Esperando entrega de datos',
        categoria: 'PENDIENTE',
        orden: 3,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: false
    },
    {
        codigo: 'ENTREGADA_RECIBIDA',
        nombre: 'Entregada / Recibida',
        categoria: 'PENDIENTE',
        orden: 4,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: true,
        permite_correccion: false,
        permite_informe: false
    },
    {
        codigo: 'VERIFICACION_INICIAL',
        nombre: 'Verificación inicial',
        categoria: 'EN_CURSO',
        orden: 5,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: true,
        permite_correccion: false,
        permite_informe: false
    },
    {
        codigo: 'EN_CORRECCION',
        nombre: 'En corrección interna',
        categoria: 'EN_CURSO',
        orden: 6,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: true,
        permite_correccion: true,
        permite_informe: false
    },
    {
        codigo: 'DELEGADA_EXTERNA',
        nombre: 'Delegada / En espera externa',
        categoria: 'EN_CURSO',
        orden: 7,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: true,
        permite_correccion: false,
        permite_informe: false
    },
    {
        codigo: 'PENDIENTE_DE_INFORME',
        nombre: 'Pendiente de informe',
        categoria: 'EN_CURSO',
        orden: 8,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: true
    },
    {
        codigo: 'ESPERANDO_REVISION',
        nombre: 'Esperando revisión de informe',
        categoria: 'EN_CURSO',
        orden: 9,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: true
    },
    {
        codigo: 'PARA_PROTOCOLIZAR',
        nombre: 'Para protocolizar',
        categoria: 'EN_CURSO',
        orden: 10,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: true
    },
    {
        codigo: 'ESPERANDO_PROTOCOLIZACION',
        nombre: 'Esperando protocolización',
        categoria: 'EN_CURSO',
        orden: 11,
        esInicial: false,
        esFinal: false,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: true
    },
    {
        codigo: 'PROTOCOLIZADA',
        nombre: 'Protocolizada / Finalizada',
        categoria: 'COMPLETADO',
        orden: 12,
        esInicial: false,
        esFinal: true,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: true
    },
    {
        codigo: 'CANCELADA',
        nombre: 'Cancelada / Desestimada',
        categoria: 'CANCELADO',
        orden: 13,
        esInicial: false,
        esFinal: true,
        permite_carga_archivos: false,
        permite_correccion: false,
        permite_informe: false
    }
];

async function seed() {
    console.log('Seeding EstadosMarea...');
    for (const estado of estadosMarea) {
        const { permite_carga_archivos, permite_correccion, permite_informe, ...rest } = estado;
        await prisma.estadoMarea.upsert({
            where: { codigo: estado.codigo },
            update: {
                ...rest,
                permiteCargaArchivos: permite_carga_archivos,
                permiteCorreccion: permite_correccion,
                permiteInforme: permite_informe
            },
            create: {
                ...rest,
                permiteCargaArchivos: permite_carga_archivos,
                permiteCorreccion: permite_correccion,
                permiteInforme: permite_informe
            }
        });
    }
    console.log('EstadosMarea seeded successfully.');
}

seed()
    .catch(e => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
