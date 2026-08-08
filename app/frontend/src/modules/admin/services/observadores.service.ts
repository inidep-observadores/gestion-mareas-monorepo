import httpClient from '@/config/http/http.client';
import type { Observador } from '../interfaces/observador.interface';

export interface CreateObservadorDto {
    codigoInterno: number;
    nombre: string;
    apellido: string;
    fotoUrl?: string;
    tipoObservador: string;
    tipoContrato: string;
    activo?: boolean;
    disponible?: boolean;
    fechaProximaDisponibilidad?: string;
    observaciones?: string;
}

export interface UpdateObservadorDto extends Partial<CreateObservadorDto> { }

const observadoresApi = {
    getObservadores: async (incluirInactivos: boolean = false): Promise<Observador[]> => {
        const { data } = await httpClient.get<Observador[]>(`/catalogos/observadores?incluirInactivos=${incluirInactivos}`);
        return data;
    },

    getObservador: async (id: string): Promise<Observador> => {
        const { data } = await httpClient.get<Observador>(`/catalogos/observadores/${id}`);
        return data;
    },

    createObservador: async (observador: CreateObservadorDto): Promise<Observador> => {
        const { data } = await httpClient.post<Observador>('/catalogos/observadores', observador);
        return data;
    },

    updateObservador: async (id: string, observador: UpdateObservadorDto): Promise<Observador> => {
        const { data } = await httpClient.patch<Observador>(`/catalogos/observadores/${id}`, observador);
        return data;
    },

    deleteObservador: async (id: string): Promise<void> => {
        await httpClient.delete(`/catalogos/observadores/${id}`);
    },

    uploadFoto: async (file: File): Promise<string> => {
        const formData = new FormData();
        formData.append('file', file);
        // Note: Using the same file upload endpoint as users for now if it exists, 
        // but backend has /files/user. Let's check if there is a generic one or if I should use /files/user
        const { data } = await httpClient.post<{ secureUrl: string }>('/files/user', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        });
        return data.secureUrl;
    },

    getHistorial: async (id: string, year?: number): Promise<any[]> => {
        const url = year ? `/catalogos/observadores/${id}/historial/${year}` : `/catalogos/observadores/${id}/historial`;
        const { data } = await httpClient.get<any[]>(url);
        return data;
    },

    exportToExcel: async (searchQuery?: string): Promise<void> => {
        const response = await httpClient.post('/catalogos/observadores/export/excel', 
            { searchQuery }, 
            { responseType: 'blob' }
        );
        
        const url = window.URL.createObjectURL(new Blob([response.data]));
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', 'OBSERVADORES.xlsx');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}

export default observadoresApi;
