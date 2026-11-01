import { describe, it, expect, vi } from 'vitest';
import { mount } from '@vue/test-utils';
import AttachmentViewer from '../AttachmentViewer.vue';

// Mock httpClient
vi.mock('@/config/http/http.client', () => ({
  default: {
    get: vi.fn(),
  },
}));

describe('AttachmentViewer.vue', () => {
  it('renderiza archivos en modo simple si no tienen tipoNovedad', () => {
    const archivos = [
      {
        id: '1',
        rutaArchivo: 'https://example.com/file1.pdf',
        nombreOriginal: 'informe_general.pdf',
      },
    ];

    const wrapper = mount(AttachmentViewer, {
      props: { archivos },
    });

    expect(wrapper.text()).toContain('informe_general.pdf');
    // No debe contener el badge de novedad
    expect(wrapper.find('.rounded-full.border').exists()).toBe(false);
  });

  it('renderiza el tipo de novedad y la fecha de recepción ordenados descendentemente', () => {
    const archivos = [
      {
        id: '1',
        rutaArchivo: 'https://example.com/file1.pdf',
        nombreOriginal: 'nota_antigua.pdf',
        tipoNovedad: 'Licencia Médica',
        tipoNovedadCodigo: 'LICENCIA',
        fechaRecepcion: '2026-08-10T10:00:00.000Z',
      },
      {
        id: '2',
        rutaArchivo: 'https://example.com/file2.pdf',
        nombreOriginal: 'nota_reciente.pdf',
        tipoNovedad: 'Declaración de Disponibilidad',
        tipoNovedadCodigo: 'DISPONIBLE',
        fechaRecepcion: '2026-09-25T10:00:00.000Z',
      },
    ];

    const wrapper = mount(AttachmentViewer, {
      props: { archivos },
    });

    const items = wrapper.findAll('.p-2\\.5');
    expect(items).toHaveLength(2);

    // El primer ítem debe ser el más reciente ('Declaración de Disponibilidad')
    expect(items[0].text()).toContain('Declaración de Disponibilidad');
    expect(items[0].text()).toContain('nota_reciente.pdf');
    expect(items[0].text()).toContain('Recibido:');

    // El segundo ítem debe ser el más antiguo ('Licencia Médica')
    expect(items[1].text()).toContain('Licencia Médica');
    expect(items[1].text()).toContain('nota_antigua.pdf');
  });
});
