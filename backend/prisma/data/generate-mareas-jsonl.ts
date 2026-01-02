import * as fs from 'fs';
import * as path from 'path';

function parseEtapaDates(etapaStr: string) {
    if (!etapaStr || !etapaStr.includes('al')) return null;
    const [start, end] = etapaStr.split('al').map(s => s.trim());

    const parseDate = (d: string) => {
        const p = d.split('/');
        if (p.length !== 3) return null;
        let [dd, mm, yy] = p.map(n => parseInt(n));
        if (isNaN(dd) || isNaN(mm) || isNaN(yy)) return null;
        if (mm === 0) mm = 1;
        const year = yy < 100 ? 2000 + yy : yy;
        const date = new Date(year, mm - 1, dd);
        return isNaN(date.getTime()) ? null : date;
    };

    const dStart = parseDate(start);
    const dEnd = parseDate(end);

    if (dStart && dEnd) {
        if (dStart > dEnd) {
            return { error: `Fecha de zarpada (${start}) es posterior a arribo (${end})` };
        }
        return { start: dStart.toISOString(), end: dEnd.toISOString() };
    }

    return { error: `Formato de fecha inválido en: ${etapaStr}` };
}

async function generateJsonl() {
    const csvPath = path.join(__dirname, '../../old_data/Mareas_2025_corregido.csv');
    const outputPath = path.join(__dirname, 'mareas_2025.jsonl');

    if (!fs.existsSync(csvPath)) {
        console.error(`CSV not found at: ${csvPath}`);
        return;
    }

    const content = fs.readFileSync(csvPath, 'utf8');
    const lines = content.split('\n').filter(l => l.trim());

    const result = [];
    let errorsFound = 0;

    for (let i = 1; i < lines.length; i++) {
        const row = lines[i].split(';');
        if (row.length < 10) continue;

        const nroMarea = parseInt(row[0]);
        if (isNaN(nroMarea)) continue;

        const obsName = row[1]?.trim();
        const buqueName = row[2]?.trim();
        const empresa = row[3]?.trim();
        const zarpadaEstimada = row[4]?.trim();
        const diasEstimadosStr = row[5]?.trim(); // "días estimados" is at index 5
        const diasZonaAustralStr = row[12]?.trim(); // "ZONA AUSTRAL" is at index 12
        const especieStr = row[7]?.trim();
        const estadoStr = row[9]?.trim();

        const diasEstimados = diasEstimadosStr ? parseInt(diasEstimadosStr) : null;
        const diasZonaAustral = diasZonaAustralStr ? parseInt(diasZonaAustralStr) : null;

        const etapas = [];
        for (let e = 1; e <= 7; e++) {
            const etapaStr = row[14 + e - 1]; // ETAPA 1 is col 14
            if (etapaStr && etapaStr.trim()) {
                const parsed = parseEtapaDates(etapaStr.trim());
                if (parsed && 'error' in parsed) {
                    console.error(`[Línea ${i + 1}] Error en Etapa ${e} of Marea ${nroMarea}: ${parsed.error}`);
                    errorsFound++;
                }

                etapas.push({
                    nroEtapa: e,
                    rangoRaw: etapaStr.trim(),
                    fecha_zarpada: parsed && 'start' in parsed ? parsed.start : null,
                    fecha_arribo: parsed && 'end' in parsed ? parsed.end : null,
                    valido: parsed && 'start' in parsed
                });
            }
        }

        result.push({
            nroMarea,
            buqueName,
            obsName,
            especieStr,
            estadoStr,
            zarpadaEstimada,
            diasEstimados: isNaN(diasEstimados) ? null : diasEstimados,
            diasZonaAustral: isNaN(diasZonaAustral) ? null : diasZonaAustral,
            empresa,
            etapas
        });
    }

    fs.writeFileSync(outputPath, result.map(r => JSON.stringify(r)).join('\n'));
    console.log(`\n--- Proceso completado ---`);
    console.log(`Registros generados: ${result.length}`);
    console.log(`Errores de validación de fecha encontrados: ${errorsFound}`);
    console.log(`Archivo guardado en: ${outputPath}`);

    if (errorsFound > 0) {
        console.warn(`\nATENCION: Se encontraron ${errorsFound} errores en las fechas. Revisa el log arriba.`);
    }
}

generateJsonl();
