require('dotenv').config();
const { ImapFlow } = require('imapflow');

async function listEmails() {
    // Leer el límite desde los argumentos de la línea de comandos (ej: node test-imap-list.js 5) o por defecto 10
    const args = process.argv.slice(2);
    let limit = 10;
    if (args.length > 0) {
        const parsedLimit = parseInt(args[0], 10);
        if (!isNaN(parsedLimit) && parsedLimit > 0) {
            limit = parsedLimit;
        }
    }

    console.log('Variables de entorno cargadas:');
    console.log('- IMAP_HOST:', process.env.IMAP_HOST || 'imap.gmail.com');
    console.log('- IMAP_PORT:', process.env.IMAP_PORT || '993');
    console.log('- IMAP_USER:', process.env.IMAP_USER || 'No definido');
    console.log(`- Límite de emails a listar: ${limit}`);

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

        console.log('Abriendo INBOX...');
        const lock = await client.getMailboxLock('INBOX');
        try {
            const totalMessages = client.mailbox.exists;
            console.log(`Bandeja INBOX abierta. Total de mensajes: ${totalMessages}`);

            if (totalMessages === 0) {
                console.log('No hay mensajes en la bandeja de entrada.');
                return;
            }

            // Calculamos el rango de los últimos N correos
            const startSeq = Math.max(1, totalMessages - limit + 1);
            const range = `${startSeq}:${totalMessages}`;

            console.log(`\nBuscando los últimos ${limit} correos (rango de secuencia: ${range})...\n`);
            console.log('====================================================================================================');
            console.log('       UID       | ADJUNTOS |   FLAGS / ETIQUETAS             |   ASUNTO');
            console.log('====================================================================================================');

            const messages = [];
            // Solicitamos { uid: true, flags: true, envelope: true, bodyStructure: true } para ver la estructura sin descargar el contenido completo
            for await (const message of client.fetch({ seq: range }, { uid: true, flags: true, envelope: true, bodyStructure: true })) {
                messages.push(message);
            }

            // Los ordenamos de más reciente a más antiguo
            messages.reverse();

            for (const msg of messages) {
                const uidStr = String(msg.uid).padEnd(15);
                
                // Contar adjuntos en la estructura del cuerpo (bodyStructure)
                let attachmentCount = 0;
                if (msg.bodyStructure && msg.bodyStructure.childNodes) {
                    // Contamos las partes que tienen disposición 'attachment'
                    const checkParts = (part) => {
                        if (part.disposition && part.disposition.toLowerCase() === 'attachment') {
                            attachmentCount++;
                        }
                        if (part.childNodes && part.childNodes.length > 0) {
                            part.childNodes.forEach(checkParts);
                        }
                    };
                    checkParts(msg.bodyStructure);
                }

                const attachmentsStr = String(attachmentCount).padEnd(8);
                const flagsList = Array.from(msg.flags || []);
                const flagsStr = (flagsList.length > 0 ? flagsList.join(', ') : 'Ninguna').padEnd(30);
                const subject = msg.envelope.subject || '(Sin Asunto)';
                console.log(` ${uidStr} | ${attachmentsStr} | ${flagsStr} | ${subject}`);
            }
            console.log('====================================================================================================');

        } finally {
            lock.release();
            console.log('\nBuzón desbloqueado.');
        }

    } catch (error) {
        console.error('\n❌ ERROR EN LA CONEXIÓN O FLUJO IMAP:');
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

listEmails().catch(console.error);
