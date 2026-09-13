import { describe, it, expect } from 'vitest';
import { calcularDiasRestantes, calcularEstadoDocumentacion } from '../observador-documentacion';

describe('observador-documentacion.ts', () => {
    it('debe indicar sin_datos y color gris si el observador es nulo o no tiene datos', () => {
        const res = calcularEstadoDocumentacion(null);
        expect(res.estado).toBe('sin_datos');
        expect(res.color).toBe('gray');
        expect(res.tooltipText).toContain('Sin registrar');
    });

    it('debe indicar sin_datos y color gris si no tiene cédula ni fechas', () => {
        const res = calcularEstadoDocumentacion({
            id: '1',
            codigoInterno: 101,
            nombre: 'Juan',
            apellido: 'Perez'
        });
        expect(res.estado).toBe('sin_datos');
        expect(res.color).toBe('gray');
    });

    it('debe indicar vencido y color rojo si la cédula o el apto médico ya vencieron', () => {
        const fechaPasada = new Date();
        fechaPasada.setDate(fechaPasada.getDate() - 5);

        const res = calcularEstadoDocumentacion({
            id: '1',
            numeroCedula: 1234,
            vencimientoCedula: fechaPasada.toISOString(),
            vencimientoAptoMedico: null
        });

        expect(res.estado).toBe('vencido');
        expect(res.color).toBe('red');
        expect(res.tooltipText).toContain('VENCIDA');
    });

    it('debe indicar vencido y color rojo si falta menos de 30 días', () => {
        const fechaProxima = new Date();
        fechaProxima.setDate(fechaProxima.getDate() + 15);

        const res = calcularEstadoDocumentacion({
            id: '1',
            numeroCedula: 1234,
            vencimientoCedula: fechaProxima.toISOString(),
            vencimientoAptoMedico: null
        });

        expect(res.estado).toBe('vencido');
        expect(res.color).toBe('red');
        expect(res.tooltipText).toContain('vencimiento crítico');
    });

    it('debe indicar por_vencer y color amarillo si el vencimiento está a menos de 60 días pero >= 30 días', () => {
        const fechaAmarilla = new Date();
        fechaAmarilla.setDate(fechaAmarilla.getDate() + 45);

        const res = calcularEstadoDocumentacion({
            id: '1',
            numeroCedula: 1234,
            vencimientoCedula: fechaAmarilla.toISOString(),
            vencimientoAptoMedico: null
        });

        expect(res.estado).toBe('por_vencer');
        expect(res.color).toBe('yellow');
        expect(res.tooltipText).toContain('próxima a vencer');
    });

    it('debe indicar al_dia y color verde si los vencimientos son >= 60 días', () => {
        const fechaLejana = new Date();
        fechaLejana.setDate(fechaLejana.getDate() + 90);

        const res = calcularEstadoDocumentacion({
            id: '1',
            numeroCedula: 1234,
            vencimientoCedula: fechaLejana.toISOString(),
            vencimientoAptoMedico: fechaLejana.toISOString()
        });

        expect(res.estado).toBe('al_dia');
        expect(res.color).toBe('green');
        expect(res.tooltipText).toContain('al día');
    });
});
