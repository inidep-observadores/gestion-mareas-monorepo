
import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { AsyncLocalStorage } from 'async_hooks';

export interface UserContextData {
    userId?: string;
    userEmail?: string;
}

export const UserContext = new AsyncLocalStorage<UserContextData>();

@Injectable()
export class UserContextMiddleware implements NestMiddleware {
    use(req: Request, res: Response, next: NextFunction) {
        // Inicializamos un objeto vacío en el almacenamiento para ser poblado luego por el Interceptor
        UserContext.run({ userId: undefined, userEmail: undefined }, () => next());
    }
}
