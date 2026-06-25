import { config } from 'dotenv';
import { ImapFlow } from 'imapflow';
import { google } from 'googleapis';
import { Readable } from 'stream';
import * as fs from 'fs';

// Cargar variables de entorno
config();

async function testIntegration() {
    console.log("=== INICIANDO PRUEBA DE INTEGRACIÓN REAL ===");
    
    const imapUser = process.env.IMAP_USER;
    const imapPass = process.env.IMAP_PASSWORD;
    const imapHost = process.env.IMAP_HOST || 'imap.gmail.com';
    const driveFolderId = process.env.GOOGLE_DRIVE_FOLDER_ID;
    const googleCreds = process.env.GOOGLE_APPLICATION_CREDENTIALS;

    if (!imapUser || !imapPass) {
        console.error("❌ Faltan credenciales IMAP (IMAP_USER, IMAP_PASSWORD) en .env");
        return;
    }

    // 1. PRUEBA IMAP
    console.log(`\n📧 1. Conectando a IMAP (${imapHost}) con usuario ${imapUser}...`);
    const client = new ImapFlow({
        host: imapHost,
        port: 993,
        secure: true,
        auth: { user: imapUser, pass: imapPass },
        logger: false
    });

    try {
        await client.connect();
        console.log("✅ Conexión IMAP exitosa.");
        
        const mailbox = await client.mailboxOpen('INBOX');
        console.log(`Buzón INBOX abierto. Total de correos: ${mailbox.exists}`);
        
        await client.logout();
    } catch (e) {
        console.error("❌ Error de conexión IMAP:", e.message);
        console.log("⚠️ Asegúrate de tener 'Contraseñas de aplicación' habilitado en Gmail si usas 2FA, o acceso IMAP activado.");
    }

    // 2. PRUEBA GOOGLE DRIVE
    console.log(`\n☁️ 2. Conectando a Google Drive API mediante OAuth2...`);
    const clientId = process.env.GOOGLE_CLIENT_ID;
    const clientSecret = process.env.GOOGLE_CLIENT_SECRET;
    const refreshToken = process.env.GOOGLE_REFRESH_TOKEN;

    if (!clientId || !clientSecret || !refreshToken) {
        console.error("❌ Faltan credenciales OAuth2 (GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, GOOGLE_REFRESH_TOKEN) en .env.");
        return;
    }

    try {
        const oauth2Client = new google.auth.OAuth2(clientId, clientSecret);
        oauth2Client.setCredentials({ refresh_token: refreshToken });
        
        const drive = google.drive({ version: 'v3', auth: oauth2Client });

        // Crear un archivo de texto simple para probar la subida
        const buffer = Buffer.from('Archivo de prueba generado por la prueba de integración de Antigravity SIGMA.');
        const bufferStream = new Readable();
        bufferStream.push(buffer);
        bufferStream.push(null);

        console.log("Subiendo archivo de prueba a Drive...");
        const response = await drive.files.create({
            requestBody: {
                name: `prueba_integracion_${Date.now()}.txt`,
                parents: driveFolderId ? [driveFolderId] : undefined,
            },
            media: {
                mimeType: 'text/plain',
                body: bufferStream,
            },
            fields: 'id, webViewLink',
        });

        console.log(`✅ Archivo subido exitosamente a Drive!`);
        console.log(`ID del archivo: ${response.data.id}`);
        console.log(`Enlace temporal (WebViewLink): ${response.data.webViewLink}`);

    } catch (e) {
        console.error("❌ Error conectando o subiendo a Google Drive:", e.message);
        console.log("⚠️ Verifica que la cuenta de servicio (Service Account) tenga permisos de Editor en la carpeta compartida.");
    }
    
    console.log("\n=== PRUEBA DE INTEGRACIÓN FINALIZADA ===");
}

testIntegration();
