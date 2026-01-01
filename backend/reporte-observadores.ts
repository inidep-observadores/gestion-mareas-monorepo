import * as fs from 'fs';
import * as path from 'path';

const jsonlPath = path.join(process.cwd(), 'prisma/data/mareas_2025.jsonl');
const obsPath = path.join(process.cwd(), 'prisma/data/observadores.jsonl');

const normalize = (str: string) => {
    if (!str) return '';
    return str.toLowerCase()
        .trim()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .replace(/[^a-z0-9\s]/g, "");
};

const observadores = fs.readFileSync(obsPath, 'utf8').split('\n').filter(l => l.trim()).map(l => JSON.parse(l));
const records = fs.readFileSync(jsonlPath, 'utf8').split('\n').filter(l => l.trim()).map(l => JSON.parse(l));

const getMatched = (name: string) => {
    if (!name) return null;
    const inputParts = normalize(name).split(/\s+/).filter(p => p.length > 2);
    return observadores.find(o => {
        const nomParts = normalize(o.nombre).split(/\s+/).filter(p => p.length > 2);
        const apeParts = normalize(o.apellido).split(/\s+/).filter(p => p.length > 2);
        const hasApellido = apeParts.every(ap => inputParts.some(ip => ip.includes(ap) || ap.includes(ip)));
        const hasNombre = nomParts.some(np => inputParts.some(ip => ip.includes(np) || np.includes(ip)));
        return hasApellido && hasNombre;
    });
};

const missing = new Map();
records.forEach(r => {
    if (r.obsName && !getMatched(r.obsName)) {
        if (!missing.has(r.obsName)) missing.set(r.obsName, []);
        missing.get(r.obsName).push(r.nroMarea);
    }
});

console.log('--- REPORTE DE OBSERVADORES NO ENCONTRADOS ---');
console.log('| Observador en CSV | Mareas afectadas |');
console.log('|-------------------|------------------|');
missing.forEach((mareas, name) => {
    console.log(`| ${name.padEnd(17)} | ${mareas.join(', ')} |`);
});
