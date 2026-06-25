import { google } from 'googleapis';
import * as readline from 'readline';
import { config } from 'dotenv';

config();

// Script para generar un REFRESH TOKEN de Google OAuth2.
// Para esto, primero debes crear un "ID de cliente OAuth 2.0" (Aplicación web) en Google Cloud.
// Configura los "Orígenes de JavaScript autorizados" y las "URI de redireccionamiento autorizados" con: http://localhost:3000

const CLIENT_ID = process.env.GOOGLE_CLIENT_ID;
const CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET;
const REDIRECT_URI = 'http://localhost:3000'; // Debe coincidir exactamente con la consola de Google Cloud

if (!CLIENT_ID || !CLIENT_SECRET) {
    console.error("❌ Faltan GOOGLE_CLIENT_ID o GOOGLE_CLIENT_SECRET en el .env");
    console.log("Ve a Google Cloud -> Credentials -> Create Credentials -> OAuth client ID");
    process.exit(1);
}

const oauth2Client = new google.auth.OAuth2(CLIENT_ID, CLIENT_SECRET, REDIRECT_URI);

const SCOPES = ['https://www.googleapis.com/auth/drive.file'];

const authUrl = oauth2Client.generateAuthUrl({
    access_type: 'offline', // Importante para obtener el refresh_token
    prompt: 'consent',      // Obliga a mostrar la pantalla de consentimiento
    scope: SCOPES,
});

console.log('====================================================');
console.log('🔗 Abre la siguiente URL en tu navegador:');
console.log('\n' + authUrl + '\n');
console.log('====================================================');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

console.log('1. Inicia sesión con la cuenta oficinaobservadores@gmail.com');
console.log('2. Acepta los permisos.');
console.log('3. Serás redirigido a una página de error en localhost:3000 (es normal).');
console.log('4. Copia el parámetro "code=" de la URL (sin el "&scope=...").');
console.log('   Ejemplo de URL: http://localhost:3000/?code=4/0AX4Xf...&scope=...');
console.log('   Solo copia: 4/0AX4Xf...');

rl.question('\nPega el código (code) aquí: ', async (code) => {
    try {
        const { tokens } = await oauth2Client.getToken(code);
        console.log('\n✅ ¡ÉXITO! Copia este REFRESH TOKEN en tu archivo .env:');
        console.log(`\nGOOGLE_REFRESH_TOKEN="${tokens.refresh_token}"\n`);
        console.log('¡Con esto listo, el backend podrá subir archivos a Drive usando la cuota real de la cuenta!');
    } catch (error) {
        console.error('❌ Error obteniendo el token:', error.message);
    }
    rl.close();
});
