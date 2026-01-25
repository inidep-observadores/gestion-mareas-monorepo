
import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  constructor(private readonly config: ConfigService) {
    const dbUrl = config.get('DATABASE_URL');

    if (!dbUrl) {
      console.log('PrismaService: DATABASE_URL is MISSING');
      throw new Error('DATABASE_URL is not defined. Please check your .env file.');
    }

    // Mask password but show structure for debugging
    const maskedUrl = dbUrl.replace(/:([^:@]+)@/, ':****@');
    console.log('PrismaService: DATABASE_URL ->', maskedUrl);

    const pool = new Pool({ connectionString: dbUrl });
    const adapter = new PrismaPg(pool);
    super({ adapter });
  }

  async onModuleInit() {
    await this.$connect();
  }
}
