import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ImapFlow } from 'imapflow';
import * as mailparser from 'mailparser';

@Injectable()
export class ImapService {
    private readonly logger = new Logger(ImapService.name);
    private client: ImapFlow;

    constructor(private readonly configService: ConfigService) {
        this.client = new ImapFlow({
            host: this.configService.get<string>('IMAP_HOST') || 'imap.gmail.com',
            port: this.configService.get<number>('IMAP_PORT') || 993,
            secure: true,
            auth: {
                user: this.configService.get<string>('SMTP_USER') || '',
                pass: this.configService.get<string>('SMTP_PASS') || '',
            },
            logger: false
        });
    }

    async connect(): Promise<void> {
        await this.client.connect();
        this.logger.log('Conectado al servidor IMAP exitosamente.');
    }

    async disconnect(): Promise<void> {
        if (this.client) {
            await this.client.logout();
            this.logger.log('Desconectado del servidor IMAP.');
        }
    }

    async fetchUnreadEmails(): Promise<any[]> {
        const results = [];
        const lock = await this.client.getMailboxLock('INBOX');
        try {
            // fetch unread emails
            for await (const message of this.client.fetch({ seen: false }, { source: true, uid: true })) {
                if (message.source) {
                    const parsed = await mailparser.simpleParser(message.source);
                    results.push({
                        uid: message.uid,
                        messageId: parsed.messageId,
                        subject: parsed.subject,
                        text: parsed.text,
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
        await this.client.messageFlagsAdd(uid, ['Procesado_SIGMA'], { uid: true });
        this.logger.log(`Mensaje ${uid} marcado con la etiqueta Procesado_SIGMA.`);
    }
}
