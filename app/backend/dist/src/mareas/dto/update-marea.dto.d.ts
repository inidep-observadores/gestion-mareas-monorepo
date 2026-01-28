import { CreateMareaDto } from './create-marea.dto';
import { MareaEtapaDto } from './marea-etapa.dto';
declare const UpdateMareaDto_base: import("@nestjs/mapped-types").MappedType<Partial<CreateMareaDto>>;
export declare class UpdateMareaDto extends UpdateMareaDto_base {
    diasZonaAustral?: number | null;
    tipoCalculoZonaAustral?: string | null;
    fechaInicioObservador?: string | null;
    fechaFinObservador?: string | null;
    nroProtocolizacion?: number | null;
    anioProtocolizacion?: number | null;
    fechaProtocolizacion?: string | null;
    observaciones?: string | null;
    activo?: boolean;
    artePrincipalId?: string | null;
    observadorPrincipalId?: string | null;
    etapas?: MareaEtapaDto[];
}
export {};
