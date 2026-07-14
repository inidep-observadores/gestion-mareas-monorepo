import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ImapFlow } from 'imapflow';
import * as mailparser from 'mailparser';

@Injectable()
export class ImapService {
    private readonly logger = new Logger(ImapService.name);
    private client: ImapFlow | null = null;

    constructor(private readonly configService: ConfigService) {}

    async connect(): Promise<void> {
        this.client = new ImapFlow({
            host: this.configService.get<string>('IMAP_HOST') || 'imap.gmail.com',
            port: this.configService.get<number>('IMAP_PORT') || 993,
            secure: true,
            auth: {
                user: this.configService.get<string>('IMAP_USER') || this.configService.get<string>('SMTP_USER') || '',
                pass: this.configService.get<string>('IMAP_PASSWORD') || this.configService.get<string>('IMAP_PASS') || this.configService.get<string>('SMTP_PASS') || '',
            },
            logger: false
        });

        await this.client.connect();
        this.logger.log('Conectado al servidor IMAP exitosamente.');
    }

    async disconnect(): Promise<void> {
        if (this.client && this.client.usable) {
            try {
                await this.client.logout();
                this.logger.log('Desconectado del servidor IMAP.');
            } catch (err) {
                this.logger.error(`Error al desconectar IMAP: ${err.message}`);
            }
        } else if (this.client) {
            this.client.close();
            this.logger.log('Conexión IMAP cerrada forzosamente (no estaba utilizable).');
        }
    }

    async fetchUnprocessedEmails(): Promise<any[]> {
        if (!this.client) throw new Error("Client not initialized");
        const results = [];
        const lock = await this.client.getMailboxLock('INBOX');
        try {
            // Buscamos correos que no tengan la etiqueta custom
            for await (const message of this.client.fetch({ unKeyword: 'Procesado_SIGMA' }, { source: true, uid: true })) {
                if (message.source) {
                    const parsed = await mailparser.simpleParser(message.source);
                    results.push({
                        uid: message.uid,
                        messageId: parsed.messageId,
                        subject: parsed.subject,
                        text: parsed.text,
                        from: parsed.from?.text || parsed.from?.value?.[0]?.address,
                        date: parsed.date,
                        attachments: parsed.attachments || []
                    });
                }
            }
        } finally {
            lock.release();
        }
        return results;
    }

    async markAsProcessed(uid: number): Promise<void> {
        if (!this.client) throw new Error("Client not initialized");
        await this.client.messageFlagsAdd(uid, ['Procesado_SIGMA'], { uid: true });
        this.logger.log(`Mensaje ${uid} marcado con la etiqueta Procesado_SIGMA.`);
    }
}
