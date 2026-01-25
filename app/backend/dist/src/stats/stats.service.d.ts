import { PrismaService } from '../prisma/prisma.service';
import { StatsDetailItem } from './interfaces/dashboard.interface';
import * as ExcelJS from 'exceljs';
export declare class StatsService {
    private readonly prisma;
    constructor(prisma: PrismaService);
    private getSharedWhereClause;
    getDashboardStats(year: number, mode: 'CALENDAR' | 'TOTAL', includeNonProtocolized: boolean, includeProtocolizedOutOfPeriod: boolean, daysCalculationMode?: 'SHIP' | 'OBSERVER', includeCampaigns?: boolean): Promise<{
        year: number;
        mode: "CALENDAR" | "TOTAL";
        totalMareas: number;
        totalDaysNavigated: number;
        avgDaysPerMarea: number;
        monthly: {
            mareas: any[];
            days: any[];
        };
        fisheries: {
            name: string;
            mareas: number;
            days: number;
        }[];
        fleets: {
            name: string;
            mareas: number;
            days: number;
        }[];
        observers: {
            id: string;
            name: string;
            mareas: number;
            days: number;
            active: boolean;
        }[];
    }>;
    getDashboardStatsDetail(year: number, mode: 'CALENDAR' | 'TOTAL', includeNonProtocolized: boolean, includeProtocolizedOutOfPeriod: boolean, filterType: 'FISHERY' | 'FLEET' | 'OBSERVER', filterValue: string, daysCalculationMode?: 'SHIP' | 'OBSERVER', includeCampaigns?: boolean): Promise<StatsDetailItem[]>;
    getExportWorkbook(year: number, mode: 'CALENDAR' | 'TOTAL', includeNonProtocolized: boolean, includeProtocolizedOutOfPeriod: boolean, daysCalculationMode?: 'SHIP' | 'OBSERVER', includeCampaigns?: boolean, filterType?: 'FISHERY' | 'FLEET' | 'OBSERVER', filterValue?: string): Promise<ExcelJS.Workbook>;
}
