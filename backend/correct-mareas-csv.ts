import * as fs from 'fs';
import * as path from 'path';

// --- Fuzzy Logic ---
function jaroWinkler(s1: string, s2: string): number {
    let m = 0;
    if (s1.length === 0 || s2.length === 0) return 0;
    if (s1 === s2) return 1;

    let matchWindow = Math.floor(Math.max(s1.length, s2.length) / 2) - 1;
    let s1Matches = new Array(s1.length);
    let s2Matches = new Array(s2.length);

    for (let i = 0; i < s1.length; i++) {
        let start = Math.max(0, i - matchWindow);
        let end = Math.min(i + matchWindow + 1, s2.length);
        for (let j = start; j < end; j++) {
            if (s2Matches[j]) continue;
            if (s1[i] !== s2[j]) continue;
            s1Matches[i] = true;
            s2Matches[j] = true;
            m++;
            break;
        }
    }

    if (m === 0) return 0;

    let t = 0;
    let k = 0;
    for (let i = 0; i < s1.length; i++) {
        if (!s1Matches[i]) continue;
        while (!s2Matches[k]) k++;
        if (s1[i] !== s2[k]) t++;
        k++;
    }

    let jaro = (m / s1.length + m / s2.length + (m - t / 2) / m) / 3;
    let prefixScale = 0.1;
    let prefixLength = 0;
    for (let i = 0; i < Math.min(4, s1.length, s2.length); i++) {
        if (s1[i] === s2[i]) prefixLength++;
        else break;
    }

    return jaro + prefixLength * prefixScale * (1 - jaro);
}

function normalize(str: string): string {
    if (!str) return '';
    return str.toLowerCase()
        .trim()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .replace(/[^a-z0-9]/g, "");
}

// --- CSV Parsing ---
function parseCsvLine(line: string, sep: string): string[] {
    const result = [];
    let cur = '';
    let inQuotes = false;
    for (let i = 0; i < line.length; i++) {
        const char = line[i];
        if (char === '"') {
            inQuotes = !inQuotes;
        } else if (char === sep && !inQuotes) {
            result.push(cur.trim());
            cur = '';
        } else {
            cur += char;
        }
    }
    result.push(cur.trim());
    return result;
}

const buquesFile = 'old_data/buques_tmp.csv';
const observadoresFile = 'old_data/observadores_tmp.csv';
const mareasFile = 'old_data/MAREAS_2025.csv';
const outputFile = 'old_data/Mareas_2025_corregido.csv';

async function main() {
    console.log('--- Iniciando Corrección por Similitud ---');

    // 1. Cargar Catálogos
    const buquesRaw = fs.readFileSync(buquesFile, 'utf8').split('\n').filter(l => l.trim());
    const buquesCatalog = buquesRaw.slice(1).map(l => {
        const parts = parseCsvLine(l, ',');
        return { original: parts[1], norm: normalize(parts[1]) };
    });

    const obsRaw = fs.readFileSync(observadoresFile, 'utf8').split('\n').filter(l => l.trim());
    const obsCatalog = obsRaw.slice(1).map(l => {
        const parts = parseCsvLine(l, ',');
        const full = `${parts[3]} ${parts[2]}`; // Apellido Nombre
        const fullAlt = `${parts[2]} ${parts[3]}`; // Nombre Apellido
        return { original: full, norm: normalize(full), normAlt: normalize(fullAlt) };
    });

    // 2. Procesar Mareas
    const mareasRaw = fs.readFileSync(mareasFile, 'utf8').split('\n');
    const header = mareasRaw[0];
    const correctedRows = [header];

    console.log(`Procesando ${mareasRaw.length - 1} registros de mareas...`);

    for (let i = 1; i < mareasRaw.length; i++) {
        const line = mareasRaw[i];
        if (!line.trim()) continue;

        const row = line.split(';');
        const mareaNro = row[0];
        const obsSource = row[1];
        const buqueSource = row[2];

        // --- Corrección Buque ---
        let bestBuque = buqueSource;
        let bestBuqueScore = 0;
        const normBuqueSource = normalize(buqueSource);

        for (const b of buquesCatalog) {
            const score = jaroWinkler(normBuqueSource, b.norm);
            if (score > bestBuqueScore) {
                bestBuqueScore = score;
                bestBuque = b.original;
            }
        }

        // Umbral de seguridad para buques
        if (bestBuqueScore < 0.85) {
            // console.warn(`[Marea ${mareaNro}] Baja similitud para buque: ${buqueSource} -> ${bestBuque} (${bestBuqueScore.toFixed(3)})`);
            bestBuque = buqueSource; // No corregir si es muy incierto
        }

        // --- Corrección Observador ---
        let bestObs = obsSource;
        let bestObsScore = 0;
        const normObsSource = normalize(obsSource);

        if (obsSource && obsSource.trim()) {
            for (const o of obsCatalog) {
                const score = Math.max(jaroWinkler(normObsSource, o.norm), jaroWinkler(normObsSource, o.normAlt));
                if (score > bestObsScore) {
                    bestObsScore = score;
                    bestObs = o.original;
                }
            }

            if (bestObsScore < 0.80) {
                // console.warn(`[Marea ${mareaNro}] Baja similitud para observador: ${obsSource} -> ${bestObs} (${bestObsScore.toFixed(3)})`);
                bestObs = obsSource;
            }
        }

        // Reconstruir fila
        row[1] = bestObs;
        row[2] = bestBuque;
        correctedRows.push(row.join(';'));
    }

    fs.writeFileSync(outputFile, correctedRows.join('\n'));
    console.log(`\nArchivo corregido guardado en: ${outputFile}`);
    console.log('Proceso completado.');
}

main().catch(console.error);
