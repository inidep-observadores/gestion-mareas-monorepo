import { Module, Global } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { FisheryClient } from './interfaces/fishery-client.interface';
import { FisheryMockAdapter } from './adapters/fishery-mock-adapter';
import { FisheryApiAdapter } from './adapters/fishery-api.adapter';

@Global()
@Module({
    providers: [
        {
            provide: FisheryClient,
            useFactory: (configService: ConfigService) => {
                const useMock = configService.get('USE_MOCK_FISHERY_API') === 'true';

                if (useMock) {
                    return new FisheryMockAdapter();
                }

                // Validar credenciales antes de crear el adaptador real
                const user = configService.get('PNA_API_USER');
                const password = configService.get('PNA_API_PASSWORD');

                if (!user || !password) {
                    throw new Error(
                        'PNA_API_USER y PNA_API_PASSWORD son requeridos cuando USE_MOCK_FISHERY_API=false',
                    );
                }

                return new FisheryApiAdapter(configService);
            },
            inject: [ConfigService],
        },
    ],
    exports: [FisheryClient],
})
export class FisheryClientModule { }
