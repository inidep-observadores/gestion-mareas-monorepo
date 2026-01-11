import { CreateMareaDto } from './create-marea.dto';
import { MareaEtapaDto } from './marea-etapa.dto';
declare const UpdateMareaDto_base: import("@nestjs/mapped-types").MappedType<Partial<CreateMareaDto>>;
export declare class UpdateMareaDto extends UpdateMareaDto_base {
    diasZonaAustral?: number;
    tipoCalculoZonaAustral?: string;
    fechaInicioObservador?: string;
    fechaFinObservador?: string;
    nroProtocolizacion?: number;
    anioProtocolizacion?: number;
    fechaProtocolizacion?: string;
    observaciones?: string;
    activo?: boolean;
    artePrincipalId?: string;
    etapas?: MareaEtapaDto[];
}
export {};
