require('dotenv').config();
const { ImapFlow } = require('imapflow');

async function testConnection() {
    console.log('Variables de entorno cargadas:');
    console.log('- IMAP_HOST:', process.env.IMAP_HOST);
    console.log('- IMAP_PORT:', process.env.IMAP_PORT);
    console.log('- SMTP_USER:', process.env.SMTP_USER);
    // No logueamos la contraseña completa por seguridad
    console.log('- SMTP_PASS:', process.env.SMTP_PASS ? '***' + process.env.SMTP_PASS.slice(-3) : 'UNDEFINED');

    const client = new ImapFlow({
        host: process.env.IMAP_HOST || 'imap.gmail.com',
        port: parseInt(process.env.IMAP_PORT || '993', 10),
        secure: true,
        auth: {
            user: process.env.SMTP_USER || '',
            pass: process.env.SMTP_PASS || '',
        },
        logger: false // Poner en true si queremos ver toda la traza de IMAP
    });

    try {
        console.log('\nIntentando conectar al servidor IMAP...');
        await client.connect();
        console.log('¡Conexión IMAP exitosa!');
        
        // Intentar obtener el status de la bandeja de entrada
        const lock = await client.getMailboxLock('INBOX');
        try {
            console.log(`Bandeja INBOX abierta exitosamente.`);
            console.log(`Total de mensajes: ${client.mailbox.exists}`);
        } finally {
            lock.release();
        }

    } catch (error) {
        console.error('\n❌ ERROR AL CONECTAR IMAP:');
        console.error(error);
    } finally {
        if (client && client.usable) {
            await client.logout();
            console.log('\nDesconectado exitosamente.');
        } else {
            client.close();
            console.log('\nConexión forzada a cerrarse.');
        }
    }
}

testConnection().catch(console.error);
