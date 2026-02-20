
import { Client } from 'pg';
import * as dotenv from 'dotenv';
import * as path from 'path';
import * as fs from 'fs';

dotenv.config({ path: path.join(__dirname, '../.env') });

async function apply() {
    const client = new Client({
        connectionString: process.env.DATABASE_URL
    });
    try {
        await client.connect();
        const sql = fs.readFileSync(path.join(__dirname, '../prisma/manual_migration.sql'), 'utf8');
        console.log('Aplicando SQL manual...');
        await client.query(sql);
        console.log('SQL aplicado con éxito.');

        // Verificar
        const res = await client.query("SELECT count(*) FROM information_schema.tables WHERE table_name = 'pna_zarpadas_arribos'");
        console.log('¿Tabla creada?', res.rows[0].count === '1');
    } catch (e) {
        console.error('Error aplicando SQL:', e);
    } finally {
        await client.end();
    }
}

apply();
