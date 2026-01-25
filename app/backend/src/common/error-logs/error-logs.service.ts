import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ErrorLogsService {
    constructor(private readonly prisma: PrismaService) { }

    async create(data: {
        level: string;
        source: string;
        context?: string;
        userId?: string;
        userEmail?: string;
        message: string;
        stack?: string;
        detail?: any;
        path?: string;
        method?: string;
        ip?: string;
    }) {
        try {
            return await this.prisma.errorLog.create({
                data: {
                    ...data,
                    detail: data.detail || undefined,
                },
            });
        } catch (dbError) {
            // Si falla el log en la DB, al menos lo sacamos por consola
            console.error('CRITICAL: Failed to save error log to DB', dbError);
            console.error('Original error:', data);
        }
    }

    async findAll() {
        return this.prisma.errorLog.findMany({
            orderBy: { timestamp: 'desc' },
            take: 100, // Limitamos a los últimos 100 por ahora
        });
    }

    async findOne(id: string) {
        return this.prisma.errorLog.findUnique({
            where: { id },
        });
    }
}
