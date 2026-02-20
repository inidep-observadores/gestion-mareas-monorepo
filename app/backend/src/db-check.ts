
import { Client } from 'pg';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({ path: path.join(__dirname, '../.env') });

async function check() {
    const client = new Client({
        connectionString: process.env.DATABASE_URL
    });
    try {
        await client.connect();
        const res = await client.query("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'");
        const tables = res.rows.map(r => r.table_name);
        console.log('¿Existe zarpadas_arribos_pna?', tables.includes('zarpadas_arribos_pna'));
        console.log('¿Existe pna_zarpadas_arribos?', tables.includes('pna_zarpadas_arribos'));

        const migrations = await client.query("SELECT migration_name FROM _prisma_migrations");
        console.log('Applied migrations count:', migrations.rows.length);
        console.log('Last migration:', migrations.rows[migrations.rows.length - 1]?.migration_name);
    } catch (e) {
        console.error(e);
    } finally {
        await client.end();
    }
}

check();
