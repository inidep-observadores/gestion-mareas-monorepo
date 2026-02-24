require('dotenv').config();
const { Client } = require('pg');
const client = new Client({ connectionString: process.env.DATABASE_URL });

async function main() {
  try {
    await client.connect();
    await client.query(`UPDATE "public"."estados_marea" SET "mostrar_en_panel" = true WHERE "codigo" = 'A_REASIGNAR';`);
    console.log("Updated DB");
  } catch (err) {
    console.error(err);
  } finally {
    await client.end();
  }
}
main();
