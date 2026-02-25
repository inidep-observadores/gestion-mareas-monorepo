
import * as nodemailer from 'nodemailer';
import * as dotenv from 'dotenv';
import { join } from 'path';

// Cargar .env desde el directorio de trabajo actual (raíz del backend)
// Esto funciona tanto en desarrollo (ts-node) como en producción (node dist/...)
dotenv.config({ path: join(process.cwd(), '.env') });

async function testSMTP() {
    console.log('--- Iniciando Prueba de Diagnóstico SMTP (Versión Compilable) ---');

    const config = {
        host: process.env.SMTP_HOST,
        port: parseInt(process.env.SMTP_PORT || '465'),
        secure: process.env.SMTP_SECURE === 'true',
        auth: {
            user: process.env.SMTP_USER,
            pass: process.env.SMTP_PASS,
        },
        debug: true, // Habilitar logs detallados de nodemailer
        logger: true, // Mostrar el flujo de comunicación en la consola
    };

    console.log(`Configuración cargada:`);
    console.log(`- Host: ${config.host}`);
    console.log(`- Port: ${config.port}`);
    console.log(`- Secure: ${config.secure}`);
    console.log(`- User: ${config.auth.user}`);
    console.log(`- Pass: ${config.auth.pass ? '********' : 'NO DEFINIDO'}`);
    console.log('--------------------------------------------');

    const transporter = nodemailer.createTransport(config);

    try {
        console.log('Verificando conexión con el servidor...');
        await transporter.verify();
        console.log('✅ Conexión establecida y autenticada correctamente.');

        console.log('Enviando email de prueba...');
        const info = await transporter.sendMail({
            from: process.env.SMTP_FROM,
            to: "danieldt2000@hotmail.com",
            subject: 'Prueba de Diagnóstico Sistema SIGMA',
            text: 'Este es un correo de prueba enviado por la utilidad de diagnóstico SMTP compilada.',
            html: '<b>Este es un correo de prueba</b> enviado por la utilidad de diagnóstico SMTP compilada.',
        });

        console.log('✅ Email enviado con éxito!');
        console.log('ID del mensaje:', info.messageId);

    } catch (error: any) {
        console.error('\n❌ ERROR DETECTADO:');
        console.error('Mensaje:', error.message);
        console.error('Código:', error.code);
        console.error('Comando:', error.command);

        if (error.message.includes('Invalid login') || error.message.includes('Username and Password not accepted')) {
            console.log('\n💡 SUGERENCIA:');
            console.log('Parece un problema de credenciales de Gmail.');
            console.log('1. Asegúrate de estar usando una "Contraseña de Aplicación" de Google, no tu contraseña normal.');
            console.log('2. La Verificación en Dos Pasos debe estar activa para generar Contraseñas de Aplicación.');
            console.log('3. Revisa si la cuenta tiene restricciones de seguridad o si Gmail bloqueó el acceso desde esta IP.');
        }
    }
}

testSMTP().catch(err => {
    console.error('Error fatal en el script:', err);
});
