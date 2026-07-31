import { google } from 'googleapis';
import * as dotenv from 'dotenv';
import { join } from 'path';
import * as http from 'http';
import * as url from 'url';

// Cargar .env
dotenv.config({ path: join(process.cwd(), '.env') });

const PORT = 3000;
const REDIRECT_URI = `http://localhost:${PORT}/oauth2callback`;

async function generateDriveToken() {
    const clientId = process.env.GOOGLE_CLIENT_ID;
    const clientSecret = process.env.GOOGLE_CLIENT_SECRET;

    if (!clientId || !clientSecret) {
        console.error('❌ Error: Falta GOOGLE_CLIENT_ID o GOOGLE_CLIENT_SECRET en el archivo .env');
        return;
    }

    // Configurar cliente de OAuth2 con el redirect a localhost
    const oauth2Client = new google.auth.OAuth2(
        clientId,
        clientSecret,
        REDIRECT_URI
    );

    const scopes = [
        'https://www.googleapis.com/auth/drive.file'
    ];

    const authUrl = oauth2Client.generateAuthUrl({
        access_type: 'offline',
        prompt: 'consent',
        scope: scopes,
    });

    console.log('\n======================================================');
    console.log('🔗 AUTORIZACIÓN DE GOOGLE DRIVE REQUERIDA');
    console.log('======================================================\n');
    
    // Iniciar un pequeño servidor local para atrapar el código de redirección
    const server = http.createServer(async (req, res) => {
        try {
            if (req.url && req.url.startsWith('/oauth2callback')) {
                const qs = new url.URL(req.url, `http://localhost:${PORT}`).searchParams;
                const code = qs.get('code');

                if (code) {
                    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
                    res.end('<h1>✅ Autorización Exitosa</h1><p>Puedes cerrar esta pestaña y volver a la terminal.</p><script>window.close()</script>');
                    
                    server.close();
                    
                    console.log('\n✅ Código recibido. Obteniendo token desde Google...\n');
                    const { tokens } = await oauth2Client.getToken(code);
                    
                    if (tokens.refresh_token) {
                        console.log('Este es tu nuevo Refresh Token. Cópialo y pégalo en tu archivo .env en la variable GOOGLE_REFRESH_TOKEN:\n');
                        console.log('\x1b[32m%s\x1b[0m', tokens.refresh_token); // Verde
                    } else {
                        console.log('⚠️ Google autorizó la app, pero NO devolvió un Refresh Token.');
                        console.log('Ve a tu cuenta de Google -> Seguridad -> Revoca el acceso de esta app y vuelve a intentar.');
                    }
                    
                    process.exit(0);
                } else {
                    res.writeHead(400, { 'Content-Type': 'text/html; charset=utf-8' });
                    res.end('<h1>❌ Error</h1><p>No se recibió el código de autorización.</p>');
                    server.close();
                    process.exit(1);
                }
            }
        } catch (error: any) {
            console.error('\n❌ Error intercambiando el código:', error.message);
            res.writeHead(500, { 'Content-Type': 'text/html; charset=utf-8' });
            res.end('<h1>❌ Error interno</h1>');
            server.close();
            process.exit(1);
        }
    });

    server.listen(PORT, () => {
        console.log('1. Ve a la consola de Google Cloud (GCP).');
        console.log('2. Ve a "API y Servicios" -> "Credenciales" -> Busca el OAuth 2.0 Client ID que estás usando.');
        console.log(`3. En "Orígenes de JavaScript autorizados", asegúrate de tener: http://localhost:${PORT}`);
        console.log(`4. En "URI de redireccionamiento autorizados", agrega esta URL EXACTA: ${REDIRECT_URI}`);
        console.log('5. Guarda los cambios.\n');
        console.log('6. AHORA abre la siguiente URL en tu navegador:');
        console.log('\n', authUrl, '\n');
        console.log('Esperando autenticación...\n(Presiona Ctrl+C para cancelar)');
    });
}

generateDriveToken().catch(console.error);
