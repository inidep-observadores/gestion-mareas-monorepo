// Cargar variables de entorno desde .env
require('dotenv').config();

/** @type {import('prisma/config').Config} */
module.exports = {
    schema: 'prisma/schema.prisma',
    migrations: {
        path: 'prisma/migrations',
        seed: 'ts-node prisma/seed-static.ts',
    },
    datasource: {
        // Si DATABASE_URL tiene placeholders como ${DB_USERNAME}, los reemplazamos manualmente
        // o construimos la URL si no existe.
        url: process.env.DATABASE_URL
            ? process.env.DATABASE_URL.trim().replace(/^["']|["']$/g, '').replace(/\${(\w+)}/g, (_, v) => process.env[v] || '')
            : `postgresql://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@${process.env.DB_HOST || 'db'}:${process.env.DB_PORT || '5432'}/${process.env.DB_NAME || 'mareas_db'}?schema=public`,
    },
};
