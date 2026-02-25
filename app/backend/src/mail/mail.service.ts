import { Injectable, Logger } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
import { AuditService } from '../audit/services/audit.service';
import { AuditCategoria, AuditResultado } from '../audit/enums/audit.enums';

@Injectable()
export class MailService {
    private readonly logger = new Logger(MailService.name);

    constructor(
        private readonly mailerService: MailerService,
        private readonly auditService: AuditService,
    ) { }

    async sendMail(to: string, subject: string, html: string) {
        try {
            await this.mailerService.sendMail({
                to,
                subject,
                html,
            });
            return true;
        } catch (error) {
            this.logger.error(`Error sending email to ${to}: ${error.message}`, error.stack);

            // Registrar en auditoría del sistema
            await this.auditService.logEvento({
                tipoEvento: 'ERROR_ENVIO_EMAIL',
                categoria: AuditCategoria.SISTEMA,
                descripcion: `Fallo al enviar correo a ${to}: ${subject}`,
                resultado: AuditResultado.ERROR,
                metadata: {
                    error: error.message,
                    destinatario: to,
                    asunto: subject
                }
            });

            return false;
        }
    }
}
