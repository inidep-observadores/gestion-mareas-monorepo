import * as fs from 'fs';
import * as path from 'path';

const jsonlPath = path.join(__dirname, 'data', 'mareas_2025.jsonl');
const content = fs.readFileSync(jsonlPath, 'utf8');
const records = content.split('\n').filter(l => l.trim()).map(l => JSON.parse(l));

console.log(`Total records: ${records.length}`);

// Check for duplicates
const seen = new Set();
const duplicates = [];

for (const rec of records) {
    const key = `${rec.nroMarea}`;
    if (seen.has(key)) {
        duplicates.push(rec.nroMarea);
    }
    seen.add(key);
}

if (duplicates.length > 0) {
    console.log(`Found ${duplicates.length} duplicate nroMarea values:`, duplicates);
} else {
    console.log('No duplicates found in nroMarea');
}

// Sample first 3 records
console.log('\nFirst 3 records:');
records.slice(0, 3).forEach(r => {
    console.log(`Marea ${r.nroMarea}: ${r.buqueName}, Estado: ${r.estadoStr}, Etapas: ${r.etapas?.length || 0}`);
});

// Check cancelled mareas
const canceladas = records.filter(r => r.estadoStr && r.estadoStr.toLowerCase().includes('cancelada'));
console.log(`\nCancelled mareas: ${canceladas.length}`);
if (canceladas.length > 0) {
    console.log('Sample cancelled:', canceladas.slice(0, 2).map(r => `Marea ${r.nroMarea}: ${r.estadoStr}, Etapas: ${r.etapas?.length || 0}`));
}

// Check mareas without etapas
const sinEtapas = records.filter(r => !r.etapas || r.etapas.length === 0);
console.log(`\nMareas without etapas: ${sinEtapas.length}`);
if (sinEtapas.length > 0) {
    console.log('Sample without etapas:', sinEtapas.slice(0, 3).map(r => `Marea ${r.nroMarea}: ${r.estadoStr}, zarpada: ${r.zarpadaEstimada}`));
}
