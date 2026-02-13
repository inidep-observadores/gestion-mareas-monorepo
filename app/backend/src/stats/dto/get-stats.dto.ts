
import { IsEnum, IsInt, IsOptional, IsBoolean, IsString } from 'class-validator';
import { Transform } from 'class-transformer';

export enum StatsMode {
    CALENDAR = 'CALENDAR',
    TOTAL = 'TOTAL',
}

export enum DaysCalculationMode {
    SHIP = 'SHIP',
    OBSERVER = 'OBSERVER',
}

export enum FilterType {
    FISHERY = 'FISHERY',
    FLEET = 'FLEET',
    OBSERVER = 'OBSERVER',
}

export class GetStatsDto {
    @IsInt()
    @Transform(({ value }) => parseInt(value))
    year: number;

    @IsEnum(StatsMode)
    @IsOptional()
    mode?: StatsMode = StatsMode.CALENDAR;

    @IsBoolean()
    @IsOptional()
    @Transform(({ value }) => value === 'true')
    includeNonProtocolized?: boolean = false;

    @IsBoolean()
    @IsOptional()
    @Transform(({ value }) => value === 'true')
    includeProtocolizedOutOfPeriod?: boolean = false;

    @IsEnum(DaysCalculationMode)
    @IsOptional()
    daysCalculationMode?: DaysCalculationMode = DaysCalculationMode.SHIP;

    @IsBoolean()
    @IsOptional()
    @Transform(({ value }) => value === 'true')
    includeCampaigns?: boolean = true;

    @IsEnum(FilterType)
    @IsOptional()
    filterType?: FilterType;

    @IsString()
    @IsOptional()
    filterValue?: string;

    @IsString()
    @IsOptional()
    startDate?: string;

    @IsString()
    @IsOptional()
    endDate?: string;

    @IsString()
    @IsOptional()
    filterStartDate?: string;

    @IsString()
    @IsOptional()
    filterEndDate?: string;

    @IsString()
    @IsOptional()
    customFilename?: string;
}
