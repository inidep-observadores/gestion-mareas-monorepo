// Importar y re-exportar los enums generados por Prisma
export { JobStatus, JobType } from '@prisma/client';

export interface JobProcessor {
    process(payload: any): Promise<any>;
}
