import { Global, Module } from '@nestjs/common';
import { MailerModule } from '@nestjs-modules/mailer';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { MailService } from './mail.service';

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
                    port: configService.get('SMTP_PORT'),
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
    providers: [MailService],
    exports: [MailService, MailerModule],
})
export class MailModule { }
