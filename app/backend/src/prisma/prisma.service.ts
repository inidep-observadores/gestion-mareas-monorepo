
import { Injectable, OnModuleInit, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import { UserContext } from '../common/middlewares/user-context.middleware';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  private readonly logger = new Logger(PrismaService.name);
  private _extendedClient: any;

  constructor(private readonly config: ConfigService) {
    const dbUrl = config.get('DATABASE_URL');
    if (!dbUrl) {
      throw new Error('DATABASE_URL is not defined. Please check your .env file.');
    }

    // Inicialización del pool y adaptador antes de super()
    const pool = new Pool({ connectionString: dbUrl });
    const adapter = new PrismaPg(pool);

    super({ adapter });

    this.logger.log('PrismaService initialized with PostgreSQL adapter');

    // Referencia al cliente base (this) para usar en la extensión
    const clientInstance = this;

    // Configurar extensiones para propagar el contexto del usuario
    this._extendedClient = this.$extends({
      query: {
        $allModels: {
          async $allOperations({ args, query, operation, model }) {
            const context = UserContext.getStore();
            const userId = context?.userId;
            const userEmail = context?.userEmail;

            // Solo inyectamos contexto en operaciones de escritura
            const isWrite = ['create', 'update', 'delete', 'upsert', 'createMany', 'updateMany', 'deleteMany'].includes(operation);

            if (isWrite && (userId || userEmail)) {
              try {
                let sql = '';
                if (userId) sql += `SET "app.current_user_id" = '${userId}'; `;
                if (userEmail) sql += `SET "app.current_user_email" = '${userEmail}';`;

                // IMPORTANTE: Volvemos a usar clientInstance porque 'this' dentro de la extensión es un proxy restringido
                await (clientInstance as any).$executeRawUnsafe(sql);

                if (userId || userEmail) {
                  console.log(`[Prisma Extension] Session context set for: ${userEmail || userId}`);
                }
              } catch (e) {
                console.error(`[Prisma Extension] Error setting session variables: ${e.message}`);
              }
            }

            return query(args);
          },
        },
      },
    });

    // Proxy para que PrismaService use el cliente extendido
    return new Proxy(this, {
      get: (target, prop) => {
        if (prop === '_extendedClient') return target._extendedClient;
        if (target._extendedClient && prop in target._extendedClient) {
          return target._extendedClient[prop];
        }
        return (target as any)[prop];
      },
    });
  }

  async onModuleInit() {
    await this.$connect();
  }
}
