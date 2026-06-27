require('dotenv').config();
const { ImapFlow } = require('imapflow');

async function testLabeling() {
    console.log('Variables de entorno cargadas:');
    console.log('- IMAP_HOST:', process.env.IMAP_HOST || 'imap.gmail.com');
    console.log('- IMAP_PORT:', process.env.IMAP_PORT || '993');
    console.log('- IMAP_USER:', process.env.IMAP_USER || 'No definido');

    const client = new ImapFlow({
        host: process.env.IMAP_HOST || 'imap.gmail.com',
        port: parseInt(process.env.IMAP_PORT || '993', 10),
        secure: true,
        auth: {
            user: process.env.IMAP_USER || '',
            pass: process.env.IMAP_PASSWORD || process.env.IMAP_PASS || '',
        },
        logger: false
    });

    try {
        console.log('\nConectando al servidor IMAP...');
        await client.connect();
        console.log('¡Conexión IMAP exitosa!');

        // Abrimos la bandeja de entrada en modo lectura/escritura (por defecto readOnly es false)
        console.log('Abriendo INBOX...');
        const lock = await client.getMailboxLock('INBOX');
        try {
            console.log(`Bandeja INBOX abierta. Total de mensajes: ${client.mailbox.exists}`);

            if (client.mailbox.exists === 0) {
                console.log('No hay mensajes en la bandeja de entrada para probar.');
                return;
            }

            // Buscar el último correo
            console.log('Buscando el último correo en el buzón...');
            let lastMessage = null;
            for await (const message of client.fetch({ seq: `${client.mailbox.exists}` }, { uid: true, envelope: true })) {
                lastMessage = message;
            }

            if (!lastMessage) {
                console.log('No se pudo recuperar el último mensaje.');
                return;
            }

            console.log(`\nÚltimo mensaje encontrado:`);
            console.log(`- UID: ${lastMessage.uid}`);
            console.log(`- Asunto: ${lastMessage.envelope.subject}`);
            console.log(`- Flags actuales:`, Array.from(lastMessage.flags || []));

            // Intentamos agregar el flag personalizado 'Procesado_SIGMA'
            const tagToApply = 'Procesado_SIGMA';
            console.log(`\nIntentando agregar la etiqueta (flag) '${tagToApply}' al correo con UID ${lastMessage.uid}...`);
            try {
                const result = await client.messageFlagsAdd({ uid: `${lastMessage.uid}` }, [tagToApply], { uid: true });
                console.log('\n==================================================');
                console.log('RESULTADO DEL PROCESO DE ETIQUETADO:');
                console.log(`- Asunto del email etiquetado: "${lastMessage.envelope.subject}"`);
                console.log(`- UID del email: ${lastMessage.uid}`);
                console.log(`- ¿Operación exitosa?: ${result ? 'SÍ' : 'NO'}`);
                console.log('==================================================');

                // Volvemos a buscar el mensaje para ver si realmente se aplicó
                console.log('\nVerificando si la etiqueta se guardó en el servidor...');
                let updatedMessage = null;
                for await (const message of client.fetch({ uid: `${lastMessage.uid}` }, { flags: true }, { uid: true })) {
                    updatedMessage = message;
                }
                if (updatedMessage) {
                    const currentFlags = Array.from(updatedMessage.flags || []);
                    console.log('Flags actuales en el servidor:', currentFlags);
                    if (currentFlags.includes(tagToApply)) {
                        console.log(`✅ CONFIRMADO: La etiqueta '${tagToApply}' se encuentra en los flags del servidor.`);
                    } else {
                        console.log(`❌ ERROR: La etiqueta '${tagToApply}' NO se encuentra en los flags del servidor.`);
                    }
                }
            } catch (labelError) {
                console.log('\n==================================================');
                console.log('RESULTADO DEL PROCESO DE ETIQUETADO: FALLIDO');
                console.log(`- Asunto del email: "${lastMessage.envelope.subject}"`);
                console.log(`- UID del email: ${lastMessage.uid}`);
                console.log('==================================================');
                console.error('\n❌ ERROR al intentar aplicar la etiqueta:');
                console.error(labelError);
                if (labelError.response && labelError.response.humanReadable) {
                    console.error('Mensaje legible del servidor:', labelError.response.humanReadable);
                }
            }

        } finally {
            lock.release();
            console.log('Buzón desbloqueado.');
        }

    } catch (error) {
        console.error('\n❌ ERROR GENERAL EN LA CONEXIÓN O FLUJO IMAP:');
        console.error(error);
    } finally {
        if (client && client.usable) {
            await client.logout();
            console.log('Desconectado exitosamente del servidor IMAP.');
        } else if (client) {
            client.close();
            console.log('Conexión IMAP cerrada.');
        }
    }
}

testLabeling().catch(console.error);
