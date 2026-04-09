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
    getProtocolizacionEmailContent(marcadasParaProtocolizar: any[]) {
        const subject = 'NOTIFICACIÓN DE MAREAS ENVIADAS A PROTOCOLIZAR';
        let tableRows = '';
        
        // Ordenar mareas por año y número (ascendente)
        const mareasOrdenadas = [...marcadasParaProtocolizar].sort((a, b) => {
            if (a.anioMarea !== b.anioMarea) return a.anioMarea - b.anioMarea;
            return a.nroMarea - b.nroMarea;
        });

        for (const marea of mareasOrdenadas) {
            const buqueCod = marea.buque?.codigoInterno ? ` (${marea.buque.codigoInterno})` : '';
            const obs = marea.observadorPrincipal;
            
            // Normalizar nombre del observador (soporte para SQL raw de observadores y Prisma)
            let nombreCompleto = 'N/D';
            if (obs) {
                if (obs.fullName) nombreCompleto = obs.fullName;
                else if (obs.full_name) nombreCompleto = obs.full_name;
                else if (obs.apellido && obs.nombre) nombreCompleto = `${obs.apellido}, ${obs.nombre}`;
                else if (obs.nombre) nombreCompleto = obs.nombre;
            }
            
            const codigo = obs?.codigoInterno || obs?.codigo_interno || '';
            const obsInfo = nombreCompleto + (codigo ? ` (${codigo})` : '');

            tableRows += `
            <tr style="border-bottom: 1px solid #e2e8f0;">
                <td style="padding: 12px; color: #1e293b; font-weight: bold;">${marea.nroMarea}/${marea.anioMarea}</td>
                <td style="padding: 12px; color: #334155;">${marea.buque?.nombreBuque || 'N/D'}${buqueCod}</td>
                <td style="padding: 12px; color: #334155;">${obsInfo}</td>
            </tr>`;
        }

        const html = `
        <div style="font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 800px; margin: 0 auto; color: #0f172a; line-height: 1.5;">
            <h3 style="color: #1e3a8a; font-size: 18px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 24px; border-left: 4px solid #3b82f6; padding-left: 16px;">
                Notificación de envío de informes de marea
            </h3>
            
            <p style="font-size: 14px; margin-bottom: 20px; color: #475569;">
                Se informa que las siguientes mareas han sido enviadas a protocolizar satisfactoriamente:
            </p>
            
            <table style="width: 100%; border-collapse: collapse; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; font-size: 13px; margin-bottom: 32px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <thead style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <tr>
                        <th style="padding: 14px 12px; text-align: left; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; font-weight: 800; font-size: 11px;">Marea</th>
                        <th style="padding: 14px 12px; text-align: left; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; font-weight: 800; font-size: 11px;">Buque</th>
                        <th style="padding: 14px 12px; text-align: left; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; font-weight: 800; font-size: 11px;">Observador</th>
                    </tr>
                </thead>
                <tbody>
                    ${tableRows}
                </tbody>
            </table>
            
            <p style="font-size: 14px; color: #475569; margin-top: 24px;">
                Se adjuntan los archivos digitales correspondientes a cada informe.
            </p>
            
            <div style="margin-top: 48px; padding-top: 24px; border-top: 1px solid #f1f5f9; text-align: left;">
                <p style="font-size: 10px; color: #94a3b8; font-style: italic; letter-spacing: 0.02em;">
                    Enviado automáticamente por <strong>SIGMA</strong> - Sistema Integral de Gestión de Mareas
                    <br/>INIDEP - Instituto Nacional de Investigación y Desarrollo Pesquero
                </p>
            </div>
        </div>
        `;

        return { subject, body: html };
    }

    async sendProtocolizacionEmail(to: string, marcadasParaProtocolizar: any[], attachmentsConfig: any[], cc?: string) {
        try {
            const { subject, body } = this.getProtocolizacionEmailContent(marcadasParaProtocolizar);
            
            await this.mailerService.sendMail({
                to,
                cc,
                subject,
                html: body,
                attachments: attachmentsConfig,
            });

            return {
                to,
                cc,
                subject,
                body
            };
        } catch (error) {
            this.logger.error(`Error sending email to ${to} (CC: ${cc || 'N/D'}): ${error.message}`, error.stack);
            await this.auditService.logEvento({
                tipoEvento: 'ERROR_ENVIO_EMAIL',
                categoria: AuditCategoria.SISTEMA,
                descripcion: `Fallo al enviar correo a ${to} (CC: ${cc || 'N/D'}): Notificación de protocolización`,
                resultado: AuditResultado.ERROR,
                metadata: {
                    error: error.message,
                    destinatario: to,
                    cc: cc || null,
                    asunto: 'Notificación de mareas enviadas a protocolizar'
                }
            });
            return null;
        }
    }
}
