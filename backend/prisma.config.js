// Cargar variables de entorno desde .env
require('dotenv').config();

/** @type {import('prisma/config').Config} */
module.exports = {
    schema: 'prisma/schema.prisma',
    migrations: {
        path: 'prisma/migrations',
    },
    datasource: {
        // Si DATABASE_URL tiene placeholders como ${DB_USERNAME}, los reemplazamos manualmente
        // o construimos la URL si no existe.
        url: process.env.DATABASE_URL 
            ? process.env.DATABASE_URL.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '')
            : `postgresql://${process.env.DB_USERNAME}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}?schema=public`,
    },
};
