import { Global, Module } from '@nestjs/common';
import { MailerModule } from '@nestjs-modules/mailer';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MailService } from './mail.service';
import { ImapService } from './imap.service';
import { NovedadesAiService } from './novedades-ai.service';
import { MailController } from './mail.controller';

@Global()
@Module({
    imports: [
        ConfigModule,
        MailerModule.forRootAsync({
            imports: [ConfigModule],
            inject: [ConfigService],
            useFactory: (configService: ConfigService) => ({
                transport: {
                    host: configService.get('SMTP_HOST'),
                    port: Number(configService.get('SMTP_PORT')),
                    secure: configService.get('SMTP_SECURE') === 'true',
                    auth: configService.get('SMTP_USER')
                        ? {
                            user: configService.get('SMTP_USER'),
                            pass: configService.get('SMTP_PASS'),
                        }
                        : undefined,
                },
                defaults: {
                    from: configService.get('SMTP_FROM'),
                },
            }),
        }),
    ],
    controllers: [MailController],
    providers: [MailService, ImapService, NovedadesAiService],
    exports: [MailService, MailerModule, ImapService, NovedadesAiService],
})
export class MailModule { }
