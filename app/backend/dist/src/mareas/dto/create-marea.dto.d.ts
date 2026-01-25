import { TipoMarea } from '../mareas.constants';
import { MareaEtapaDto } from './marea-etapa.dto';
export declare class CreateMareaDto {
    buqueId: string;
    anioMarea: number;
    nroMarea: number;
    pesqueriaId: string;
    observadorId: string;
    arteId?: string;
    fechaZarpadaEstimada: string;
    tipoMarea?: TipoMarea;
    diasEstimados?: number;
    fechaInicioObservador?: string;
    observaciones?: string;
    etapas?: MareaEtapaDto[];
}
