export declare enum StatsMode {
    CALENDAR = "CALENDAR",
    TOTAL = "TOTAL"
}
export declare enum DaysCalculationMode {
    SHIP = "SHIP",
    OBSERVER = "OBSERVER"
}
export declare enum FilterType {
    FISHERY = "FISHERY",
    FLEET = "FLEET",
    OBSERVER = "OBSERVER"
}
export declare class GetStatsDto {
    year: number;
    mode?: StatsMode;
    includeNonProtocolized?: boolean;
    includeProtocolizedOutOfPeriod?: boolean;
    daysCalculationMode?: DaysCalculationMode;
    includeCampaigns?: boolean;
    filterType?: FilterType;
    filterValue?: string;
    customFilename?: string;
}
