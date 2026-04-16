/**
 * Servicio para renderizado de gráficos Chart.js a imágenes PNG en servidor.
 * Utiliza @napi-rs/canvas (binarios precompilados, sin compilación nativa requerida).
 */
import { Injectable } from '@nestjs/common';
import { createCanvas } from '@napi-rs/canvas';
import { Chart, ChartConfiguration, registerables } from 'chart.js';
import { CHART_COLORS, CHART_DIMENSIONS, FONTS } from './docx-styles';

Chart.register(...registerables);

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
                        stacked: options?.stacked,
                        ticks: { font: { family: FONTS.primary, size: 13 } },
                        grid: { display: false },
                    },
                    y: {
                        stacked: options?.stacked,
                        beginAtZero: true,
                        grace: options?.displayLabels ? '8%' : undefined,
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
                        meta.data.forEach((bar, index) => {
                            const data = dataset.data[index] as number;
                            if (data === 0) return;
                            ctx.save();
                            ctx.fillStyle = '#64748B'; // Muted text
                            ctx.font = `bold 13px ${FONTS.primary}`;
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
                        font: { family: FONTS.primary, size: 15, weight: 'bold' },
                        color: '#1E293B',
                    } : undefined,
                },
                scales: {
                    x: {
                        beginAtZero: true,
                        grace: options?.displayLabels ? '12%' : undefined,
                        ticks: { font: { family: FONTS.primary, size: 13 } },
                        title: {
                            display: true,
                            text: 'Días Navegados',
                            font: { family: FONTS.primary, size: 14 },
                        },
                    },
                    y: {
                        ticks: { font: { family: FONTS.primary, size: 13 } },
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
                        ctx.font = `bold 13px ${FONTS.primary}`;
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
                                ctx.fillStyle = '#64748B'; // Muted text
                                ctx.font = `bold 13px ${FONTS.primary}`;
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
                        labels: { font: { family: FONTS.primary, size: 15 }, padding: 16 },
                    },
                    title: options?.title ? {
                        display: true,
                        text: options.title,
                        font: { family: FONTS.primary, size: 15, weight: 'bold' },
                        color: '#1E293B',
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
                        ctx.font = `bold 15px ${FONTS.primary}`;
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
}
