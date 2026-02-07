import { Module, Global } from '@nestjs/common';
import { FisheryClient } from './interfaces/fishery-client.interface';
import { FisheryMockAdapter } from './adapters/fishery-mock-adapter';

@Global()
@Module({
    providers: [
        {
            provide: FisheryClient,
            useClass: FisheryMockAdapter, // Por ahora usamos el Mock
        },
    ],
    exports: [FisheryClient],
})
export class FisheryClientModule { }
