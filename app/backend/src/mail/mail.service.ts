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
    async sendProtocolizacionEmail(to: string, marcadasParaProtocolizar: any[], files: Express.Multer.File[]) {
        try {
            const subject = 'Notificación de mareas enviadas a protocolizar';
            let tableRows = '';
            for (const marea of marcadasParaProtocolizar) {
                tableRows += `
                <tr>
                    <td>${marea.nroMarea}/${marea.anioMarea} (${marea.tipoMarea})</td>
                    <td>${marea.buque?.nombreBuque || 'N/D'}</td>
                </tr>`;
            }

            const html = `
            <h2>Notificación de Protocolización</h2>
            <p>Se informa que las siguientes mareas han sido enviadas a protocolizar:</p>
            <table border="1" cellpadding="5" cellspacing="0">
                <thead>
                    <tr><th>Marea</th><th>Buque</th></tr>
                </thead>
                <tbody>
                    ${tableRows}
                </tbody>
            </table>
            <p>Se adjuntan los documentos correspondientes.</p>
            `;

            const attachments = files ? files.map(file => ({
                filename: file.originalname,
                content: file.buffer,
                contentType: file.mimetype,
            })) : [];

            await this.mailerService.sendMail({
                to,
                subject,
                html,
                attachments,
            });
            return true;
        } catch (error) {
            this.logger.error(`Error sending email to ${to}: ${error.message}`, error.stack);
            await this.auditService.logEvento({
                tipoEvento: 'ERROR_ENVIO_EMAIL',
                categoria: AuditCategoria.SISTEMA,
                descripcion: `Fallo al enviar correo a ${to}: Notificación de protocolización`,
                resultado: AuditResultado.ERROR,
                metadata: {
                    error: error.message,
                    destinatario: to,
                    asunto: 'Notificación de mareas enviadas a protocolizar'
                }
            });
            return false;
        }
    }
}
