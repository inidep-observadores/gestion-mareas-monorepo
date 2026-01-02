import { Pool } from 'pg';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({ path: path.join(__dirname, '.env.develop') });

async function main() {
    console.log('Testing Raw PG Connection...');
    console.log('URL:', process.env.DATABASE_URL ? 'PRESENT' : 'MISSING');

    const pool = new Pool({
        connectionString: process.env.DATABASE_URL
    });

    try {
        const res = await pool.query('SELECT current_database(), now()');
        console.log('SUCCESS:', res.rows[0]);

        const buques = await pool.query('SELECT count(*) FROM buques');
        console.log('Buques count:', buques.rows[0].count);

        const dukat = await pool.query("SELECT * FROM buques WHERE nombre_buque ILIKE '%DUKAT%'");
        console.log('DUKAT found:', dukat.rows.length > 0 ? dukat.rows[0] : 'NOT FOUND');

        const mareas = await pool.query('SELECT count(*) FROM mareas');
        console.log('Mareas count:', mareas.rows[0].count);

        const tables = await pool.query("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'");
        console.log('Tables:', tables.rows.map(r => r.table_name).join(', '));

    } catch (e: any) {
        console.error('FAIL:', e.message);
    } finally {
        await pool.end();
    }
}

main();
