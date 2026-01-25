import { Response } from 'express';
import { StatsService } from './stats.service';
import { GetStatsDto } from './dto/get-stats.dto';
export declare class StatsController {
    private readonly statsService;
    constructor(statsService: StatsService);
    getDashboardStats(query: GetStatsDto): Promise<{
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
    getDashboardStatsDetail(query: GetStatsDto): Promise<import("./interfaces/dashboard.interface").StatsDetailItem[]>;
    exportStats(res: Response, query: GetStatsDto): Promise<void>;
}
