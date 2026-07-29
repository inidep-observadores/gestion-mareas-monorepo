import { google } from 'googleapis';
import * as dotenv from 'dotenv';
import { join } from 'path';

// Cargar .env desde el directorio de trabajo actual
dotenv.config({ path: join(process.cwd(), '.env') });

async function testGoogleDrive() {
    console.log('--- Iniciando Prueba de Conexión a Google Drive ---');

    const clientId = process.env.GOOGLE_CLIENT_ID;
    const clientSecret = process.env.GOOGLE_CLIENT_SECRET;
    const refreshToken = process.env.GOOGLE_REFRESH_TOKEN;
    const folderId = process.env.GOOGLE_DRIVE_FOLDER_ID;

    if (!clientId || !clientSecret || !refreshToken) {
        console.error('❌ Faltan credenciales en el archivo .env');
        console.log(`CLIENT_ID: ${clientId ? 'OK' : 'FALTA'}`);
        console.log(`CLIENT_SECRET: ${clientSecret ? 'OK' : 'FALTA'}`);
        console.log(`REFRESH_TOKEN: ${refreshToken ? 'OK' : 'FALTA'}`);
        return;
    }

    try {
        console.log('1. Autenticando con OAuth2...');
        const oauth2Client = new google.auth.OAuth2(clientId, clientSecret);
        oauth2Client.setCredentials({ refresh_token: refreshToken });

        const driveClient = google.drive({ version: 'v3', auth: oauth2Client });

        console.log('2. Conectando y listando información de la cuenta (About)...');
        const about = await driveClient.about.get({ fields: 'user' });
        console.log(`✅ Conectado exitosamente como: ${about.data.user?.emailAddress}`);

        console.log(`3. Intentando subir un archivo de prueba a la carpeta ID: ${folderId || 'Raíz'}...`);
        
        const { PassThrough } = require('stream');
        const bufferStream = new PassThrough();
        bufferStream.end(Buffer.from('Este es un archivo de prueba generado por el script de diagnostico. Puede ser eliminado.'));

        const response = await driveClient.files.create({
            requestBody: {
                name: `test-diagnostico-${Date.now()}.txt`,
                parents: folderId ? [folderId] : undefined,
            },
            media: {
                mimeType: 'text/plain',
                body: bufferStream,
            },
            fields: 'id, webViewLink, name',
        });

        console.log('✅ Archivo creado exitosamente.');
        console.log(`- Nombre: ${response.data.name}`);
        console.log(`- ID: ${response.data.id}`);
        console.log(`- Link: ${response.data.webViewLink}`);

        console.log('4. Intentando limpiar (borrar) el archivo de prueba...');
        if (response.data.id) {
            await driveClient.files.delete({ fileId: response.data.id });
            console.log('✅ Archivo de prueba borrado exitosamente.');
        }

        console.log('\n🎉 TODAS LAS PRUEBAS PASARON CORRECTAMENTE.');

    } catch (error: any) {
        console.error('\n❌ ERROR DETECTADO:');
        console.error('Mensaje:', error.message);
        
        if (error.response && error.response.data) {
            console.error('Detalles de Google API:', JSON.stringify(error.response.data, null, 2));
        }

        console.log('\n💡 POSIBLES CAUSAS:');
        console.log('1. El Refresh Token expiró (suele pasar si la app en Google Cloud está en estado "Testing" y pasaron 7 días).');
        console.log('2. El usuario revocó el acceso a la app.');
        console.log('3. La aplicación de Google Cloud fue borrada o modificada.');
        console.log('4. Falta habilitar Google Drive API en GCP.');
    }
}

testGoogleDrive().catch(console.error);
