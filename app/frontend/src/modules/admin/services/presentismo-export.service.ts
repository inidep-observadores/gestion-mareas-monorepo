import * as XLSX from 'xlsx';
import type { PlanillaMensualResponse } from '../interfaces/planilla-mensual.interface';

const presentismoExportService = {
  exportarAExcel: (data: PlanillaMensualResponse) => {
    const headerRow = [
      'Observador',
      'NAV',
      'PTO',
      'NOV',
      'LIB',
      'F/FS',
      'ERR'
    ];

    for (let i = 1; i <= data.diasMes; i++) {
      headerRow.push(`${i}`);
    }

    const rows = [headerRow];

    data.matriz.forEach((row) => {
      const dataRow = [
        `${row.observador.apellido}, ${row.observador.nombre}`,
        row.totales.navegando,
        row.totales.puerto,
        row.totales.novedades,
        row.totales.libres,
        row.totales.feriadosFinSemana,
        row.totales.conflictos,
      ];

      for (let i = 1; i <= data.diasMes; i++) {
        const dia = row.dias[i];
        if (!dia) {
          dataRow.push('');
          continue;
        }

        switch (dia.estado) {
          case 'NAVEGANDO':
            dataRow.push('NAV');
            break;
          case 'PUERTO':
            dataRow.push('PTO');
            break;
          case 'NOVEDAD':
            dataRow.push('NOV');
            break;
          case 'FIN_SEMANA':
          case 'FERIADO':
            dataRow.push('FS');
            break;
          case 'CONFLICTO':
            dataRow.push('ERR');
            break;
          case 'LIBRE':
          default:
            dataRow.push('');
            break;
        }
      }

      rows.push(dataRow as any[]);
    });

    const worksheet = XLSX.utils.aoa_to_sheet(rows);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, `Planilla ${data.month}-${data.year}`);

    // Ajustar anchos de columnas
    const wscols = [
      { wch: 30 }, // Observador
      { wch: 5 }, // Totales
      { wch: 5 },
      { wch: 5 },
      { wch: 5 },
      { wch: 5 },
      { wch: 5 },
    ];
    for (let i = 1; i <= data.diasMes; i++) {
      wscols.push({ wch: 4 });
    }
    worksheet['!cols'] = wscols;

    XLSX.writeFile(workbook, `Presentismo_Observadores_${data.year}_${data.month.toString().padStart(2, '0')}.xlsx`);
  }
};

export default presentismoExportService;
