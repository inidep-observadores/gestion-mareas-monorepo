import * as fs from 'fs';
import * as path from 'path';

async function runTest() {
    const modelName = 'granite3.2-vision:2b'; // El modelo local a utilizar
    const ollamaUrl = 'http://localhost:11434/api/generate';

    // Para evitar problemas de compilación de node-canvas en Windows con Node 24,
    // usaremos directamente una imagen del pasaje/boleto.
    // Por favor, toma una captura de pantalla del PDF y guárdala como 'boleto-prueba.png' en esta carpeta.
    // const imagePath = path.resolve(__dirname, 'boleto-prueba.png');
    const imagePath = path.resolve(__dirname, 'boleto-prueba2.jpeg');

    if (!fs.existsSync(imagePath)) {
        console.error(`\n❌ Archivo de imagen no encontrado: ${imagePath}`);
        console.log(`💡 Para continuar: Abre el PDF (20260604030743692.pdf), toma una captura de pantalla del boleto y guárdala como 'boleto-prueba.png' en la carpeta app/backend/`);
        return;
    }

    console.log(`\n🚀 Iniciando prueba con Ollama (${modelName})`);
    console.log(`1️⃣  Cargando imagen... (${path.basename(imagePath)})`);

    let base64Image = '';
    try {
        const imageBuffer = fs.readFileSync(imagePath);
        base64Image = imageBuffer.toString('base64');
        console.log(`   ✅ Imagen cargada (Base64 length: ${base64Image.length})`);
    } catch (err: any) {
        console.error('   ❌ Error al leer la imagen:', err.message);
        return;
    }

    // Mejoramos el prompt especificando cómo encontrar el pasajero e incluimos el DNI.
    // Delegamos la lógica del estado (INICIO_VIAJE/FIN_VIAJE) al código posterior para mayor control.
    const prompt = `
Eres un asistente experto en logística pesquera. 
Tu tarea es analizar el comprobante de pasaje adjunto (imagen del boleto o e-ticket).
El objetivo es extraer de forma precisa los datos del viaje.

Reglas de extracción:
1. "observador": Busca específicamente el texto que sigue a la palabra "Pasajero:". El nombre suele estar en formato "APELLIDO, NOMBRES" (ejemplo: "LEON, WALTER ALEJANDRO"). NUNCA extraigas ciudades como "PARANA".
2. "dni": Busca la sigla exacta "DNI " que se encuentra en la MISMA línea y a la DERECHA del nombre del pasajero. Extrae únicamente el número de 8 dígitos que le sigue (ejemplo: 29236006). Es absolutamente prohibido extraer el importe del pasaje o números que tengan decimales (como 57000.00).
3. "fechaInicio": Debe formatearse estrictamente como 'YYYY-MM-DD'.
4. "origen": La ciudad desde donde parte el viaje (ej. "Mar del Plata Terminal").
5. "destino": La ciudad hacia donde se dirige el viaje (ej. "Buenos Aires").

IMPORTANTE: Responde ÚNICAMENTE con un objeto JSON válido con las siguientes claves (no incluyas texto extra):
{
  "observador": "string",
  "dni": "string",
  "fechaInicio": "string",
  "origen": "string",
  "destino": "string"
}
`;

    console.log(`2️⃣  Enviando petición a Ollama local...`);
    const startTime = Date.now();
    
    try {
        const response = await fetch(ollamaUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                model: modelName,
                prompt: prompt,
                images: [base64Image],
                format: 'json',
                stream: false,
                options: {
                    temperature: 0.0 // 0 puro para que no "cree" datos
                }
            })
        });

        if (!response.ok) {
            throw new Error(`Error en la API de Ollama: ${response.status} ${response.statusText}`);
        }

        const data = await response.json();
        const elapsedTime = ((Date.now() - startTime) / 1000).toFixed(2);
        
        console.log(`\n⏱️  Tiempo de inferencia: ${elapsedTime} segundos`);
        console.log("\n✅ === RESULTADO OLLAMA ===");
        console.log(data.response);
        
        try {
            // Validamos que sea un JSON parseable
            const parsed = JSON.parse(data.response);
            
            // Post-procesamiento de reglas de negocio
            let estadoDisponibilidad = 'TRANSITO';
            const origenLower = (parsed.origen || '').toLowerCase();
            const destinoLower = (parsed.destino || '').toLowerCase();
            const esMdq = (str: string) => str.includes('mar del plata') || str.includes('mdp') || str.includes('mdq');

            if (esMdq(origenLower)) {
                estadoDisponibilidad = 'VIAJE_INICIO'; // O INICIO_VIAJE según regla de tu app
            } else if (esMdq(destinoLower)) {
                estadoDisponibilidad = 'VIAJE_FIN'; // O FIN_VIAJE
            }
            
            parsed.estadoDisponibilidad = estadoDisponibilidad;

            console.log("\n✅ === JSON PROCESADO FINAL ===");
            console.log(JSON.stringify(parsed, null, 2));
        } catch (e) {
            console.log("\n⚠️ Atención: La respuesta no es un JSON válido.");
        }

    } catch (e: any) {
        console.error("\n❌ Error de conexión o ejecución con Ollama:");
        console.error(e.message);
        console.log("\nAsegúrate de que Ollama esté en ejecución y que el modelo granite3.2-vision:2b esté descargado (ollama run granite3.2-vision:2b)");
    }
}

runTest();
