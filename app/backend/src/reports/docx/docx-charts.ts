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
        options?: { title?: string; stacked?: boolean; yAxisLabel?: string },
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
                        font: { family: FONTS.primary, size: 20, weight: 'bold' },
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
                        title: options?.yAxisLabel ? {
                            display: true,
                            text: options.yAxisLabel,
                            font: { family: FONTS.primary, size: 14 },
                        } : undefined,
                        ticks: { font: { family: FONTS.primary, size: 13 } },
                    },
                },
            },
        };

        return this.render(config, CHART_DIMENSIONS.width, CHART_DIMENSIONS.height);
    }

    /**
     * Renderiza un gráfico de barras horizontales (para ranking de observadores).
     */
    async renderHorizontalBarChart(
        labels: string[],
        data: number[],
        options?: { title?: string; avgLine?: number; barColor?: string },
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
                        font: { family: FONTS.primary, size: 20, weight: 'bold' },
                        color: '#1E293B',
                    } : undefined,
                },
                scales: {
                    x: {
                        beginAtZero: true,
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
            plugins: options?.avgLine ? [{
                id: 'avgLine',
                afterDraw: (chart) => {
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
            }] : [],
        };

        return this.render(config, CHART_DIMENSIONS.width, height);
    }

    /**
     * Renderiza un gráfico tipo donut/pie.
     */
    async renderDoughnutChart(
        labels: string[],
        data: number[],
        options?: { title?: string; colors?: string[] },
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
                plugins: {
                    legend: {
                        position: 'right',
                        labels: { font: { family: FONTS.primary, size: 15 }, padding: 16 },
                    },
                    title: options?.title ? {
                        display: true,
                        text: options.title,
                        font: { family: FONTS.primary, size: 20, weight: 'bold' },
                        color: '#1E293B',
                    } : undefined,
                },
            },
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
}
