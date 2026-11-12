/**
 * Servicio para renderizado de gráficos Chart.js a imágenes PNG en servidor.
 * Utiliza @napi-rs/canvas (binarios precompilados, sin compilación nativa requerida).
 */
import { Injectable } from '@nestjs/common';
import { createCanvas } from '@napi-rs/canvas';
import { Chart, ChartConfiguration, registerables } from 'chart.js';
import { CHART_COLORS, CHART_DIMENSIONS, FONTS } from './docx-styles';

Chart.register(...registerables);

export const ESTADO_COLORS: Record<string, string> = {
    'en revisión': '#1e3a8a', // blue-900
    'esperando entrega': '#0369a1', // sky-700
    'entregada recibida': '#0284c7', // sky-600
    'pendiente de informe': '#b45309', // amber-700
    'esperando protocolizacion': '#4338ca', // indigo-700
    'protocolizada': '#166534', // green-800
    'derivada': '#9a3412', // orange-800
    'delegada': '#9a3412', // orange-800
    'desestimada': '#475569', // slate-600
    'dni': '#0f766e', // teal-700

    'planificada': '#52525b', // zinc-600
    'asignada': '#ca8a04', // yellow-600
    'embarcado': '#6d28d9', // violet-700
    'en curso': '#b91c1c', // red-700
    'regresando': '#c2410c', // orange-700
    'en ejecución': '#c2410c', // orange-700 (Fijado para evitar el color verde por hash)
};

export const getColorByEstado = (estado: string) => {
    if (!estado) return '#334155';
    const s = estado.toLowerCase().replace(/_/g, ' ');
    for (const [key, val] of Object.entries(ESTADO_COLORS)) {
        if (s.includes(key)) return val;
    }

    // Generar un tono HSL consistente para estados desconocidos
    let hash = 0;
    for (let i = 0; i < s.length; i++) {
        hash = s.charCodeAt(i) + ((hash << 5) - hash);
    }
    const hues = [0, 25, 45, 120, 160, 210, 260, 280, 320];
    const h = hues[Math.abs(hash) % hues.length];
    return `hsl(${h}, 70%, 40%)`;
};

@Injectable()
export class DocxChartService {
    /**
     * Renderiza un gráfico de barras verticales.
     */
    async renderBarChart(
        labels: string[],
        datasets: Array<{ label: string; data: number[] }>,
        options?: { title?: string; stacked?: boolean; yAxisLabel?: string; displayLabels?: boolean },
    ): Promise<Buffer> {
        const config: ChartConfiguration = {
            type: 'bar',
            data: {
                labels,
                datasets: datasets.map((ds, i) => ({
                    label: ds.label,
                    data: ds.data,
                    backgroundColor: CHART_COLORS.palette[i % CHART_COLORS.palette.length],
                    borderColor: CHART_COLORS.paletteSolid[i % CHART_COLORS.paletteSolid.length],
                    borderWidth: 1,
                    borderRadius: 4,
                })),
            },
            options: {
                responsive: false,
                animation: false,
                plugins: {
                    legend: {
                        display: datasets.length > 1,
                        position: 'top',
                        labels: { font: { family: FONTS.primary, size: 22 }, padding: 16 },
                    },
                    title: options?.title ? {
                        display: true,
                        text: options.title,
                        font: { family: FONTS.primary, size: 26, weight: 'bold' },
                        color: '#1E293B',
                        padding: { bottom: 20 }
                    } : undefined,
                },
                scales: {
                    x: {
                        stacked: options?.stacked,
                        ticks: { font: { family: FONTS.primary, size: 18 } },
                        grid: { display: false },
                    },
                    y: {
                        stacked: options?.stacked,
                        beginAtZero: true,
                        grace: options?.displayLabels ? '8%' : undefined,
                        title: options?.yAxisLabel ? {
                            display: true,
                            text: options.yAxisLabel,
                            font: { family: FONTS.primary, size: 18 },
                        } : undefined,
                        ticks: { font: { family: FONTS.primary, size: 18 } },
                    },
                },
            },
            plugins: options?.displayLabels ? [{
                id: 'datalabels',
                afterDraw: (chart) => {
                    const ctx = chart.ctx;
                    chart.data.datasets.forEach((dataset, i) => {
                        const meta = chart.getDatasetMeta(i);
                        meta.data.forEach((bar, index) => {
                            const data = dataset.data[index] as number;
                            if (data === 0) return;
                            ctx.save();
                            ctx.fillStyle = '#1E293B'; // Darker text for visibility
                            ctx.font = `bold 18px ${FONTS.primary}`;
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'bottom';
                            // Ajustar posición para stacked si fuera necesario, 
                            // pero para bar normal bar.y - 5 está perfecto
                            ctx.fillText(data.toString(), (bar as any).x, (bar as any).y - 5);
                            ctx.restore();
                        });
                    });
                },
            }] : [],
        };

        return this.render(config, CHART_DIMENSIONS.width, CHART_DIMENSIONS.height);
    }
    /**
     * Renderiza un gráfico de líneas.
     */
    async renderLineChart(
        labels: string[],
        datasets: Array<{ label: string; data: number[] }>,
        options?: { title?: string; yAxisLabel?: string; displayLabels?: boolean },
    ): Promise<Buffer> {
        const config: ChartConfiguration = {
            type: 'line',
            data: {
                labels,
                datasets: datasets.map((ds, i) => ({
                    label: ds.label,
                    data: ds.data,
                    borderColor: CHART_COLORS.paletteSolid[i % CHART_COLORS.paletteSolid.length],
                    backgroundColor: CHART_COLORS.paletteSolid[i % CHART_COLORS.paletteSolid.length],
                    borderWidth: 3,
                    pointRadius: 6,
                    pointBackgroundColor: '#FFFFFF',
                    pointBorderWidth: 2,
                    tension: 0.3,
                    fill: false,
                })),
            },
            options: {
                responsive: false,
                animation: false,
                plugins: {
                    legend: {
                        display: datasets.length > 1,
                        position: 'top',
                        labels: { font: { family: FONTS.primary, size: 15 } },
                    },
                    title: options?.title ? {
                        display: true,
                        text: options.title,
                        font: { family: FONTS.primary, size: 15, weight: 'bold' },
                        color: '#1E293B',
                    } : undefined,
                },
                scales: {
                    x: {
                        ticks: { font: { family: FONTS.primary, size: 13 } },
                        grid: { display: false },
                    },
                    y: {
                        beginAtZero: true,
                        title: options?.yAxisLabel ? {
                            display: true,
                            text: options.yAxisLabel,
                            font: { family: FONTS.primary, size: 14 },
                        } : undefined,
                        ticks: { font: { family: FONTS.primary, size: 13 } },
                    },
                },
            },
            plugins: options?.displayLabels ? [{
                id: 'datalabels',
                afterDraw: (chart) => {
                    const ctx = chart.ctx;
                    chart.data.datasets.forEach((dataset, i) => {
                        const meta = chart.getDatasetMeta(i);
                        meta.data.forEach((point, index) => {
                            const data = dataset.data[index] as number;
                            if (data === 0) return;
                            ctx.save();
                            ctx.fillStyle = CHART_COLORS.paletteSolid[i % CHART_COLORS.paletteSolid.length];
                            ctx.font = `bold 13px ${FONTS.primary}`;
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'bottom';
                            ctx.fillText(data.toString(), (point as any).x, (point as any).y - 10);
                            ctx.restore();
                        });
                    });
                },
            }] : [],
        };

        return this.render(config, CHART_DIMENSIONS.width, CHART_DIMENSIONS.height);
    }

    /**
     * Renderiza un gráfico de barras horizontales (para ranking de observadores).
     */
    async renderHorizontalBarChart(
        labels: string[],
        data: number[],
        options?: { title?: string; avgLine?: number; barColor?: string; displayLabels?: boolean },
    ): Promise<Buffer> {
        const height = Math.max(CHART_DIMENSIONS.horizontalBarMinHeight, labels.length * 35);

        const datasets: any[] = [
            {
                label: 'Días Navegados',
                data,
                backgroundColor: options?.barColor || CHART_COLORS.violet,
                borderColor: options?.barColor || CHART_COLORS.violet,
                borderWidth: 1,
                borderRadius: 3,
                barPercentage: 0.7,
            },
        ];

        const config: ChartConfiguration<'bar'> = {
            type: 'bar',
            data: { labels, datasets },
            options: {
                indexAxis: 'y',
                responsive: false,
                animation: false,
                plugins: {
                    legend: { display: false },
                    title: options?.title ? {
                        display: true,
                        text: options.title,
                        font: { family: FONTS.primary, size: 26, weight: 'bold' },
                        color: '#1E293B',
                        padding: { bottom: 20 }
                    } : undefined,
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        grace: options?.displayLabels ? '12%' : undefined,
                        ticks: { font: { family: FONTS.primary, size: 18 } },
                        title: {
                            display: true,
                            text: 'Días Navegados',
                            font: { family: FONTS.primary, size: 20 },
                        },
                    },
                    y: {
                        ticks: { font: { family: FONTS.primary, size: 18 } },
                        grid: { display: false },
                    },
                },
            },
            plugins: [
                ...(options?.avgLine ? [{
                    id: 'avgLine',
                    afterDraw: (chart: any) => {
                        const ctx = chart.ctx;
                        const xScale = chart.scales.x;
                        const yScale = chart.scales.y;
                        const x = xScale.getPixelForValue(options.avgLine!);

                        ctx.save();
                        ctx.strokeStyle = CHART_COLORS.danger;
                        ctx.lineWidth = 2;
                        ctx.setLineDash([6, 4]);
                        ctx.beginPath();
                        ctx.moveTo(x, yScale.top);
                        ctx.lineTo(x, yScale.bottom);
                        ctx.stroke();

                        // Etiqueta
                        ctx.fillStyle = CHART_COLORS.danger;
                        ctx.font = `bold 18px ${FONTS.primary}`;
                        ctx.textAlign = 'center';
                        ctx.fillText(`Promedio: ${options.avgLine}`, x, yScale.top - 8);
                        ctx.restore();
                    },
                }] : []),
                ...(options?.displayLabels ? [{
                    id: 'datalabels',
                    afterDraw: (chart: any) => {
                        const ctx = chart.ctx;
                        chart.data.datasets.forEach((dataset: any, i: number) => {
                            const meta = chart.getDatasetMeta(i);
                            meta.data.forEach((bar: any, index: number) => {
                                const val = dataset.data[index] as number;
                                if (val === 0) return;
                                ctx.save();
                                ctx.fillStyle = '#1E293B'; // Darker text
                                ctx.font = `bold 18px ${FONTS.primary}`;
                                ctx.textAlign = 'left';
                                ctx.textBaseline = 'middle';
                                ctx.fillText(val.toString(), bar.x + 5, bar.y);
                                ctx.restore();
                            });
                        });
                    },
                }] : []),
            ],
        };

        return this.render(config, CHART_DIMENSIONS.width, height);
    }

    /**
     * Renderiza un gráfico tipo donut/pie.
     */
    async renderDoughnutChart(
        labels: string[],
        data: number[],
        options?: { title?: string; colors?: string[]; displayLabels?: boolean },
    ): Promise<Buffer> {
        const colors = options?.colors || CHART_COLORS.palette.slice(0, data.length);

        const config: ChartConfiguration = {
            type: 'doughnut',
            data: {
                labels,
                datasets: [{
                    data,
                    backgroundColor: colors,
                    borderWidth: 2,
                    borderColor: '#FFFFFF',
                }],
            },
            options: {
                responsive: false,
                animation: false,
                layout: {
                    padding: {
                        left: 80,   // Espacio para evitar que las etiquetas largas se corten a la izquierda
                        right: 40,  // Margen de seguridad a la derecha
                        top: 20,
                        bottom: 20,
                    },
                },
                plugins: {
                    legend: {
                        position: 'right',
                        labels: { font: { family: FONTS.primary, size: 24 }, padding: 20 },
                    },
                    title: options?.title ? {
                        display: true,
                        text: options.title,
                        font: { family: FONTS.primary, size: 26, weight: 'bold' },
                        color: '#1E293B',
                        padding: { bottom: 20 }
                    } : undefined,
                },
            },
            plugins: options?.displayLabels ? [{
                id: 'donutLabels',
                afterDraw: (chart) => {
                    const ctx = chart.ctx;
                    const meta = chart.getDatasetMeta(0);
                    meta.data.forEach((element: any, index) => {
                        const val = chart.data.datasets[0].data[index] as number;
                        const labelText = chart.data.labels![index] as string;
                        if (val === 0) return;

                        // TooltipPosition suele ser el centro del arco
                        const { x, y } = element.tooltipPosition();

                        ctx.save();
                        // Aura blanca para legibilidad
                        ctx.strokeStyle = 'rgba(255, 255, 255, 0.8)';
                        ctx.lineWidth = 4;
                        ctx.lineJoin = 'round';
                        ctx.font = `bold 24px ${FONTS.primary}`;
                        ctx.textAlign = 'center';
                        ctx.textBaseline = 'middle';
                        ctx.strokeText(labelText, x, y);

                        // Texto principal
                        ctx.fillStyle = '#1E293B';
                        ctx.fillText(labelText, x, y);
                        ctx.restore();
                    });
                }
            }] : [],
        };

        return this.render(config, CHART_DIMENSIONS.pieWidth, CHART_DIMENSIONS.pieHeight);
    }

    /**
     * Método interno para renderizar cualquier configuración de Chart.js a PNG.
     */
    private render(config: ChartConfiguration, width: number, height: number): Buffer {
        const canvas = createCanvas(width, height);
        const ctx = canvas.getContext('2d');

        ctx.fillStyle = 'white';
        ctx.fillRect(0, 0, width, height);

        const chart = new Chart(ctx as any, config as any);
        const buffer = canvas.toBuffer('image/png');
        chart.destroy();

        return buffer;
    }

    /**
     * Renderiza el logo de SIGMA usando Canvas (para insertar en informes).
     */
    async renderSigmaLogo(size: number = 400): Promise<Buffer> {
        const canvas = createCanvas(size, size);
        const ctx = canvas.getContext('2d');
        const scale = size / 160;

        ctx.save();
        ctx.scale(scale, scale);

        // Gradiente institucional (basado en SigmaLogo.vue light mode)
        const grd = ctx.createLinearGradient(0, 0, 160, 160);
        grd.addColorStop(0, '#2563eb');
        grd.addColorStop(1, '#4f46e5');

        ctx.lineWidth = 10;
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';
        ctx.strokeStyle = grd;

        // Brazo exterior (Arco)
        ctx.beginPath();
        ctx.moveTo(140, 25);
        ctx.lineTo(80, 25);
        ctx.arc(80, 80, 55, -Math.PI / 2, Math.PI / 2, true);
        ctx.lineTo(92, 135);
        ctx.stroke();

        // Núcleo circular (Core)
        ctx.beginPath();
        ctx.lineWidth = 6;
        ctx.arc(80, 80, 28, -Math.PI / 4, Math.PI * 1.4);
        ctx.stroke();

        // Punto central (Dot)
        ctx.beginPath();
        ctx.fillStyle = '#2563eb';
        ctx.arc(80, 80, 6, 0, Math.PI * 2);
        ctx.fill();

        ctx.restore();
        return canvas.toBuffer('image/png');
    }

    /**
     * Renderiza un diagrama de flujo/árbol para el resumen de mareas.
     */
    async renderMareasTreeChart(
        total: { count: number, days: number },
        finalizadas: { count: number, days: number },
        desgloseFinalizadas: {
            revision: { count: number, days: number };
            derivadas: { count: number, days: number };
            desestimadas: { count: number, days: number };
            esperandoProtocolizacion: { count: number, days: number };
            protocolizadas: { count: number, days: number };
            enEjecucion: { count: number, days: number };
        }
    ): Promise<Buffer> {
        const width = 1200;
        const height = 820;
        const canvas = createCanvas(width, height);
        const ctx = canvas.getContext('2d');

        // Fondo blanco
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(0, 0, width, height);

        // Estilos generales
        const boxFill = '#F8FAFC'; // slate-50
        const boxStroke = '#334155'; // slate-700
        const textFill = '#0F172A'; // slate-900
        const lineStroke = '#94A3B8'; // slate-400
        const fontFamily = FONTS.primary;

        // Función auxiliar para dibujar cajas
        const drawBox = (x: number, y: number, w: number, h: number, text1: string, text2: string, text3?: string, strokeColor?: string) => {
            ctx.fillStyle = boxFill;
            ctx.lineWidth = 3;
            ctx.strokeStyle = strokeColor || boxStroke;
            ctx.beginPath();
            ctx.roundRect(x - w / 2, y, w, h, 8);
            ctx.fill();
            ctx.stroke();

            ctx.fillStyle = textFill;
            ctx.textAlign = 'center';
            ctx.textBaseline = 'middle';

            // Permitir múltiples líneas pasadas con saltos de línea \n
            const lines1 = text1 ? text1.split('\n').filter(l => l.trim().length > 0) : [];
            const lines2 = text2 ? text2.split('\n') : [];
            const lines3 = text3 ? text3.split('\n') : [];
            const totalLines = lines1.length + lines2.length + lines3.length;

            let currentY = y + h / 2 - (totalLines * 14) + 10;

            if (lines1.length > 0) {
                ctx.font = `bold 36px ${fontFamily}`;
                lines1.forEach(line => {
                    ctx.fillText(line, x, currentY);
                    currentY += 40;
                });
            }
            if (lines2.length > 0) {
                ctx.font = `normal 22px ${fontFamily}`;
                currentY += 6; // Gap extra
                lines2.forEach(line => {
                    ctx.fillText(line, x, currentY);
                    currentY += 26;
                });
            }
            if (lines3.length > 0) {
                ctx.font = `italic 22px ${fontFamily}`;
                ctx.fillStyle = '#475569'; // gris más sutil
                lines3.forEach(line => {
                    ctx.fillText(line, x, currentY);
                    currentY += 26;
                });
            }
        };

        // Función auxiliar para conectar cajas
        const drawLine = (startX: number, startY: number, endX: number, endY: number) => {
            ctx.strokeStyle = lineStroke;
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(startX, startY);
            ctx.lineTo(endX, endY);
            ctx.stroke();

            // Dibujar flecha
            const headlen = 12;
            const angle = Math.atan2(endY - startY, endX - startX);
            ctx.beginPath();
            ctx.moveTo(endX, endY);
            ctx.lineTo(endX - headlen * Math.cos(angle - Math.PI / 6), endY - headlen * Math.sin(angle - Math.PI / 6));
            ctx.lineTo(endX - headlen * Math.cos(angle + Math.PI / 6), endY - headlen * Math.sin(angle + Math.PI / 6));
            ctx.fillStyle = lineStroke;
            ctx.fill();
        };

        const boxW = 280;
        const boxH = 140;

        // Coordenadas
        const level1Y = 40;
        const level2Y = 240;
        const level3Y = 440;
        const level4Y = 640;

        const rootX = width / 2;
        const finX = width / 2 - 200;
        const ejeX = width / 2 + 200;

        // Distribución de hijos de "finalizadas"
        const childrenW = 260;
        const childrenH = 150;
        const gap = 30;
        const numCajas = 4;
        const totalW = (childrenW * numCajas) + (gap * (numCajas - 1));
        const startX = width / 2 - totalW / 2 + childrenW / 2;

        const pts = [
            { x: startX, t1: `${desgloseFinalizadas.revision.count}`, t2: 'en revisión', t3: `(${desgloseFinalizadas.revision.days} d)`, c: getColorByEstado('en revisión') },
            { x: startX + (childrenW + gap), t1: `${desgloseFinalizadas.derivadas.count}`, t2: 'derivadas a\nprogramas externos', t3: `(${desgloseFinalizadas.derivadas.days} d)`, c: getColorByEstado('derivada') },
            { x: startX + (childrenW + gap) * 2, t1: `${desgloseFinalizadas.esperandoProtocolizacion.count}`, t2: 'esperando\nprotocolización', t3: `(${desgloseFinalizadas.esperandoProtocolizacion.days} d)`, c: getColorByEstado('dni') },
            { x: startX + (childrenW + gap) * 3, t1: `${desgloseFinalizadas.protocolizadas.count}`, t2: 'protocolizadas', t3: `(${desgloseFinalizadas.protocolizadas.days} d)`, c: getColorByEstado('protocolizada') },
        ];

        // Dibujar Conectores (Nivel 1 -> Nivel 2)
        drawLine(rootX, level1Y + boxH, finX, level2Y);
        drawLine(rootX, level1Y + boxH, ejeX, level2Y);

        // Dibujar Conectores (Nivel 2 -> Nivel 4)
        pts.forEach(p => {
            drawLine(finX, level2Y + boxH, p.x, level4Y);
        });

        // Dibujar Conector "En Ejecución" -> "Posteriores" (Diagonal hacia abajo y a la derecha)
        drawLine(ejeX, level2Y + boxH, ejeX + 150, level3Y);

        // Dibujar Cajas Nivel 1 y 2
        drawBox(rootX, level1Y, 260, boxH, `${total.count}`, 'mareas consideradas', `(${total.days} d)`);
        drawBox(finX, level2Y, boxW, boxH, `${finalizadas.count}`, 'finalizadas', `(${finalizadas.days} d)`);
        drawBox(ejeX, level2Y, boxW, boxH, `${desgloseFinalizadas.enEjecucion.count}`, 'en ejecución', `(${desgloseFinalizadas.enEjecucion.days} d)`, getColorByEstado('en ejecución'));

        // Caja "posteriores" (Nivel 3, desplazada a la derecha de "En ejecución")
        drawBox(ejeX + 150, level3Y, 300, childrenH, '', 'No se consideran en\nrecuento de mareas (*)');

        // Dibujar Cajas Nivel 4 (hijas de finalizadas)
        pts.forEach(p => {
            drawBox(p.x, level4Y, childrenW, childrenH, p.t1, p.t2, p.t3, p.c);
        });

        return canvas.toBuffer('image/png');
    }

    /**
     * Renderiza un diagrama de Gantt simplificado que muestra la continuidad de las mareas.
     */
    async renderMareasGanttChart(
        periodStart: Date,
        periodEnd: Date,
        mareas: Array<{ start: Date; end: Date | null; isFinalizada: boolean; estimatedDays: number; estado: string }>
    ): Promise<Buffer> {
        // Ordenar mareas por fecha de inicio
        const sortedMareas = [...mareas].sort((a, b) => a.start.getTime() - b.start.getTime());

        const width = 1200;
        // Altura adaptable a la cantidad de mareas (min 300)
        const rowHeight = 12;
        const paddingTop = 140; // Aumentado para mayor legibilidad
        const paddingBottom = 60;
        const height = Math.max(300, sortedMareas.length * rowHeight + paddingTop + paddingBottom);

        const canvas = createCanvas(width, height);
        const ctx = canvas.getContext('2d');

        // Escala de tiempo: arranca 15 días antes de la marea MÁS ANTIGUA
        let minDate = new Date(periodStart);
        sortedMareas.forEach(m => {
            if (m.start < minDate) minDate = new Date(m.start);
        });

        const extStart = new Date(minDate);
        extStart.setDate(extStart.getDate() - 15);

        const extEnd = new Date(periodEnd);
        extEnd.setDate(extEnd.getDate() + 90); // 3 meses después del período para mostrar la continuidad

        const totalTime = extEnd.getTime() - extStart.getTime();

        const getX = (date: Date) => {
            const pct = (date.getTime() - extStart.getTime()) / totalTime;
            return Math.max(0, Math.min(width, pct * width));
        };

        const cutX = getX(periodEnd);
        const startX = getX(periodStart);

        // --- Fondos ---
        // Período de reporte
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(startX, 0, cutX - startX, height);

        // Período posterior
        ctx.fillStyle = '#F1F5F9'; // slate-100
        ctx.fillRect(cutX, 0, width - cutX, height);

        // Sombrear período anterior
        ctx.fillStyle = '#F1F5F9'; // slate-100 (mismo que posterior)
        ctx.fillRect(0, 0, startX, height);

        // --- Referencias (Leyenda) ---
        /*
        const drawLegend = (xPos: number, yPos: number, color: string, label: string) => {
            ctx.fillStyle = color;
            ctx.beginPath();
            ctx.roundRect(xPos, yPos, 20, 10, 2);
            ctx.fill();
            ctx.fillStyle = '#334155';
            ctx.font = `normal 16px ${FONTS.primary}`;
            ctx.textAlign = 'left';
            ctx.textBaseline = 'middle';
            ctx.fillText(label, xPos + 28, yPos + 5);
            return ctx.measureText(label).width + 50;
        };
        
        let legendX = 30;
        const legendY = 30;
        const uniqueEstados = Array.from(new Set(sortedMareas.map(m => m.estado))).filter(e => e);
        uniqueEstados.forEach(est => {
            // Convertir constantes como PENDIENTE_DE_INFORME a formato coloquial (ej: Pendiente De Informe)
            let label = est.replace(/_/g, ' ').toLowerCase();
            label = label.charAt(0).toUpperCase() + label.slice(1);
            
            legendX += drawLegend(legendX, legendY, getColorByEstado(est), label);
        });
        */

        // --- Grid vertical de meses ---
        ctx.fillStyle = '#64748B'; // slate-500
        ctx.font = `bold 20px ${FONTS.primary}`;
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.lineWidth = 1;
        ctx.strokeStyle = '#E2E8F0'; // slate-200

        // Iterar meses para dibujar lineas verticales
        const cursorDate = new Date(extStart.getFullYear(), extStart.getMonth(), 1);
        while (cursorDate <= extEnd) {
            const x = getX(cursorDate);
            if (x >= 0 && x <= width) {
                // linea
                ctx.beginPath();
                ctx.moveTo(x, paddingTop - 15);
                ctx.lineTo(x, height);
                ctx.stroke();

                // texto mes
                const monthName = cursorDate.toLocaleString('es-ES', { month: 'short' }).toUpperCase();
                ctx.fillText(monthName, x, paddingTop - 40);
            }
            cursorDate.setMonth(cursorDate.getMonth() + 1);
        }

        // --- Líneas de Corte ---

        // Línea de inicio del periodo
        ctx.beginPath();
        ctx.setLineDash([5, 5]);
        ctx.strokeStyle = '#EF4444'; // Rojo claro
        ctx.lineWidth = 2;
        ctx.moveTo(startX, paddingTop - 110);
        ctx.lineTo(startX, height);
        ctx.stroke();

        ctx.setLineDash([]);
        ctx.font = `bold 22px ${FONTS.primary}`;
        ctx.textBaseline = 'top';

        ctx.fillStyle = '#64748B'; // Gris para actividad previa fuera del período
        ctx.textAlign = 'right';
        ctx.fillText('Previo', startX - 5, paddingTop - 90);

        ctx.fillStyle = '#EF4444'; // Rojo para inicio de período
        ctx.textAlign = 'left';
        ctx.fillText('Inicio', startX + 5, paddingTop - 90);

        // Línea de fin del periodo
        ctx.beginPath();
        ctx.setLineDash([5, 5]);
        ctx.strokeStyle = '#EF4444'; // Rojo claro
        ctx.lineWidth = 2;
        ctx.moveTo(cutX, paddingTop - 110);
        ctx.lineTo(cutX, height);
        ctx.stroke();

        ctx.setLineDash([]);
        ctx.fillStyle = '#EF4444';
        ctx.font = `bold 22px ${FONTS.primary}`;
        ctx.textAlign = 'right';
        ctx.textBaseline = 'top';
        ctx.fillText('Corte del Informe', cutX - 5, paddingTop - 90);

        ctx.fillStyle = '#64748B'; // Gris para continuidad
        ctx.textAlign = 'left';
        ctx.fillText('En Ejecución (Continuación)', cutX + 5, paddingTop - 90);

        // --- Barras de Mareas ---
        let currentY = paddingTop;
        sortedMareas.forEach(m => {
            const mStartX = getX(m.start);
            let mEndX = m.end ? getX(m.end) : width; // Si no tiene fin, va hasta el final

            ctx.beginPath();
            if (m.isFinalizada) {
                // Barra normal
                ctx.fillStyle = getColorByEstado(m.estado);
                ctx.roundRect(mStartX, currentY, mEndX - mStartX, rowHeight - 4, 3);
                ctx.fill();
            } else {
                // Barra de ejecución continua (choca la linea y sigue difuminada/flecha)
                const extDate = new Date(m.start);
                extDate.setDate(extDate.getDate() + (m.estimatedDays || 45));

                // Si el estimado era muy corto y la fecha ya pasó el corte de la auditoría, 
                // prolongamos visualmente pasando el corte para que la flecha sea consistente.
                if (extDate.getTime() <= periodEnd.getTime()) {
                    extDate.setTime(periodEnd.getTime() + 15 * 24 * 60 * 60 * 1000); // 15 días posteriores al corte
                }

                // Asegurar que la punta de la flecha no se salga del canvas visible
                let projectedEndX = getX(extDate);
                if (projectedEndX > width - 10) projectedEndX = width - 10;

                // Color dinámico según estado
                ctx.fillStyle = getColorByEstado(m.estado);

                // Cuerpo principal hasta el proyecto final
                ctx.roundRect(mStartX, currentY, projectedEndX - mStartX, rowHeight - 4, 3);
                ctx.fill();

                // Flecha final
                ctx.beginPath();
                ctx.moveTo(projectedEndX, currentY - 2);
                ctx.lineTo(projectedEndX + 8, currentY + (rowHeight - 4) / 2);
                ctx.lineTo(projectedEndX, currentY + rowHeight - 2);
                ctx.fill();
            }
            currentY += rowHeight;
        });

        return canvas.toBuffer('image/png');
    }
}
