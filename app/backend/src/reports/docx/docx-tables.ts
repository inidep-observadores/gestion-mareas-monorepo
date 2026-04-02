/**
 * Helpers para la creación de tablas formateadas en documentos Word.
 * Proporciona funciones para generar tablas con estilo institucional INIDEP.
 */
import {
    Table, TableRow, TableCell, Paragraph, TextRun, WidthType,
    AlignmentType, BorderStyle, VerticalAlign, ShadingType, HeadingLevel,
    convertInchesToTwip,
} from 'docx';
import { INIDEP_COLORS, FONTS, FONT_SIZES } from './docx-styles';

type AlignmentTypeValue = (typeof AlignmentType)[keyof typeof AlignmentType];

/** Opciones de configuración para una tabla */
export interface TableOptions {
    /** Anchos de columna en porcentaje (deben sumar 100) */
    columnWidths?: number[];
    /** Alineación por columna */
    alignments?: AlignmentTypeValue[];
    /** Mostrar filas alternadas con color de fondo */
    stripedRows?: boolean;
    /** Incluir fila de totales */
    totalsRow?: { label: string; values: (string | number)[] };
}

/** Crea una celda de encabezado de tabla con estilo INIDEP */
function createHeaderCell(text: string, widthPct?: number, alignment: AlignmentTypeValue = AlignmentType.CENTER): TableCell {
    return new TableCell({
        width: widthPct ? { size: widthPct, type: WidthType.PERCENTAGE } : undefined,
        shading: { type: ShadingType.SOLID, color: INIDEP_COLORS.tableHeaderBg },
        verticalAlign: VerticalAlign.CENTER,
        children: [
            new Paragraph({
                alignment,
                spacing: { before: 40, after: 40 },
                children: [
                    new TextRun({
                        text,
                        font: FONTS.primary,
                        size: FONT_SIZES.tableHeader,
                        bold: true,
                        color: INIDEP_COLORS.tableHeaderText,
                    }),
                ],
            }),
        ],
    });
}

/** Crea una celda de datos de tabla. Acepta string[], donde cada elemento se renderiza en un párrafo separado. */
function createDataCell(
    text: string | string[] | number,
    options?: {
        widthPct?: number;
        alignment?: AlignmentTypeValue;
        bold?: boolean;
        striped?: boolean;
        isTotal?: boolean;
        color?: string;
    },
): TableCell {
    const {
        widthPct,
        alignment = AlignmentType.LEFT,
        bold = false,
        striped = false,
        isTotal = false,
        color,
    } = options || {};

    const bgColor = isTotal
        ? INIDEP_COLORS.tableTotalBg
        : striped
            ? INIDEP_COLORS.tableRowAlt
            : undefined;

    const lines = Array.isArray(text) ? text : [String(text)];

    return new TableCell({
        width: widthPct ? { size: widthPct, type: WidthType.PERCENTAGE } : undefined,
        shading: bgColor ? { type: ShadingType.SOLID, color: bgColor } : undefined,
        verticalAlign: VerticalAlign.CENTER,
        children: lines.map((line, idx) =>
            new Paragraph({
                alignment,
                spacing: {
                    before: idx === 0 ? 30 : 0,
                    after: idx === lines.length - 1 ? 30 : 0,
                },
                children: [
                    new TextRun({
                        text: line,
                        font: FONTS.primary,
                        size: FONT_SIZES.tableCell,
                        bold: bold || isTotal,
                        color: color || INIDEP_COLORS.text,
                    }),
                ],
            }),
        ),
    });
}

/**
 * Crea una tabla formateada con encabezados, datos y totales opcionales.
 */
export function createFormattedTable(
    headers: string[],
    rows: (string | string[] | number)[][],
    options?: TableOptions,
): Table {
    const {
        columnWidths,
        alignments,
        stripedRows = true,
        totalsRow,
    } = options || {};

    const tableRows: TableRow[] = [];

    // Fila de encabezados
    tableRows.push(
        new TableRow({
            tableHeader: true,
            children: headers.map((header, i) =>
                createHeaderCell(
                    header,
                    columnWidths?.[i],
                    alignments?.[i] || AlignmentType.CENTER,
                ),
            ),
        }),
    );

    // Filas de datos
    rows.forEach((row, rowIndex) => {
        const isStriped = stripedRows && rowIndex % 2 === 1;
        tableRows.push(
            new TableRow({
                children: row.map((cell, colIndex) =>
                    createDataCell(cell, {
                        widthPct: columnWidths?.[colIndex],
                        alignment: alignments?.[colIndex] || AlignmentType.LEFT,
                        striped: isStriped,
                    }),
                ),
            }),
        );
    });

    // Fila de totales
    if (totalsRow) {
        const totalCells: TableCell[] = [];
        totalCells.push(
            createDataCell(totalsRow.label, {
                widthPct: columnWidths?.[0],
                alignment: AlignmentType.LEFT,
                bold: true,
                isTotal: true,
            }),
        );
        totalsRow.values.forEach((val, i) => {
            totalCells.push(
                createDataCell(val, {
                    widthPct: columnWidths?.[i + 1],
                    alignment: alignments?.[i + 1] || AlignmentType.CENTER,
                    bold: true,
                    isTotal: true,
                }),
            );
        });
        tableRows.push(new TableRow({ children: totalCells }));
    }

    const borderStyle = {
        style: BorderStyle.SINGLE,
        size: 1,
        color: INIDEP_COLORS.tableBorder,
    };

    return new Table({
        width: { size: 100, type: WidthType.PERCENTAGE },
        rows: tableRows,
        borders: {
            top: borderStyle,
            bottom: borderStyle,
            left: borderStyle,
            right: borderStyle,
            insideHorizontal: borderStyle,
            insideVertical: borderStyle,
        },
    });
}

/**
 * Crea una tabla de KPIs (indicadores clave) en layout horizontal tipo cards.
 * Cada KPI se muestra como valor + etiqueta en una celda sin bordes visibles.
 */
export function createKpiTable(
    kpis: Array<{ value: string | number; label: string }>,
    columns = 3,
): Table {
    const rows: TableRow[] = [];

    for (let i = 0; i < kpis.length; i += columns) {
        const chunk = kpis.slice(i, i + columns);
        const cells = chunk.map(kpi =>
            new TableCell({
                width: { size: Math.floor(100 / columns), type: WidthType.PERCENTAGE },
                shading: { type: ShadingType.SOLID, color: INIDEP_COLORS.primaryUltraLight },
                verticalAlign: VerticalAlign.CENTER,
                margins: {
                    top: convertInchesToTwip(0.08),
                    bottom: convertInchesToTwip(0.08),
                    left: convertInchesToTwip(0.15),
                    right: convertInchesToTwip(0.15),
                },
                children: [
                    new Paragraph({
                        alignment: AlignmentType.CENTER,
                        spacing: { after: 20 },
                        children: [
                            new TextRun({
                                text: String(kpi.value),
                                font: FONTS.primary,
                                size: FONT_SIZES.kpiValue,
                                bold: true,
                                color: INIDEP_COLORS.primary,
                            }),
                        ],
                    }),
                    new Paragraph({
                        alignment: AlignmentType.CENTER,
                        children: [
                            new TextRun({
                                text: kpi.label,
                                font: FONTS.primary,
                                size: FONT_SIZES.kpiLabel,
                                color: INIDEP_COLORS.textMuted,
                            }),
                        ],
                    }),
                ],
            }),
        );

        // Rellenar con celdas vacías si la última fila no está completa
        while (cells.length < columns) {
            cells.push(
                new TableCell({
                    width: { size: Math.floor(100 / columns), type: WidthType.PERCENTAGE },
                    children: [new Paragraph({})],
                }),
            );
        }

        rows.push(new TableRow({ children: cells }));
    }

    return new Table({
        width: { size: 100, type: WidthType.PERCENTAGE },
        rows,
        borders: {
            top: { style: BorderStyle.NONE, size: 0 },
            bottom: { style: BorderStyle.NONE, size: 0 },
            left: { style: BorderStyle.NONE, size: 0 },
            right: { style: BorderStyle.NONE, size: 0 },
            insideHorizontal: { style: BorderStyle.SINGLE, size: 1, color: INIDEP_COLORS.white },
            insideVertical: { style: BorderStyle.SINGLE, size: 1, color: INIDEP_COLORS.white },
        },
    });
}
