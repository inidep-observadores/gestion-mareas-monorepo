const { Client } = require('pg');
const client = new Client({ connectionString: 'postgresql://postgres:MySecr3tPassWord%40as2@localhost:5435/MareasDB' });
async function run() {
  await client.connect();
  console.log('Deleting from _prisma_migrations...');
  await client.query("DELETE FROM _prisma_migrations WHERE migration_name = '20260624000000_novedades_updates';");
  console.log('Done!');
  await client.end();
}
run();
