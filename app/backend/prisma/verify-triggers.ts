
import { PrismaClient, TipoMarea } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
    console.log('⚡ Iniciando Verificación de Triggers de Base de Datos ⚡');
    let errors = 0;
    
    // Helper para limpiar
    const cleanup = async () => {
        try {
            await prisma.observador.deleteMany({ where: { codigoInterno: 99999 } });
            await prisma.marea.deleteMany({ where: { nroMarea: 99999 } });
        } catch (e) {}
    };
    await cleanup();

    // =========================================================================
    // 1. Validar Observador (Disponibilidad vs Impedimento)
    // =========================================================================
    console.log('\n[1] Observador: Disponible + Con Impedimento (Esperado: FALLO)');
    try {
        await prisma.observador.create({
            data: {
                nombre: 'Test', apellido: 'Trigger',
                codigoInterno: 99999,
                disponible: true,
                conImpedimento: true,
                motivoImpedimento: 'Test trigger',
                tipoObservador: 'OBSERVADOR',
                tipoContrato: 'RELACION_DEPENDENCIA'
            }
        });
        console.error('❌ FAIL: Se permitió crear observador inválido.');
        errors++;
    } catch (e: any) {
        if (e.message.includes('Un observador no puede estar disponible y tener impedimento')) {
            console.log('✅ PASS: Trigger bloqueó la operación correctamente.');
        } else {
            console.error('❌ FAIL: Error inesperado:', e.message);
            errors++;
        }
    }

    // =========================================================================
    // 2. Validar Protocolización (Campos Parciales)
    // =========================================================================
    console.log('\n[2] Marea: Protocolización Parcial (Esperado: FALLO)');
    // Crear buque y estado dummy necesarios? Usaremos existentes o creamos dummies
    // Mejor crear una marea dummy minima.
    // Necesitamos Buque, EstadoMarea (Inicial).
    const estadoInicial = await prisma.estadoMarea.findFirst({ where: { esInicial: true } });
    const buque = await prisma.buque.findFirst();
    
    if (!estadoInicial || !buque) {
        console.error('Skipping marea tests: Missing seed data (Estado/Buque)');
        return;
    }

    // Crear Marea Base
    const marea = await prisma.marea.create({
        data: {
            anioMarea: 2025,
            nroMarea: 99999,
            tipoMarea: TipoMarea.MC,
            buqueId: buque.id,
            estadoActualId: estadoInicial.id,
            fechaInicioObservador: null,
            inicioValidado: false,
            fechaFinObservador: null
        }
    });

    try {
        await prisma.marea.update({
            where: { id: marea.id },
            data: {
                nroProtocolizacion: 100,
                // anio y fecha faltan
            }
        });
        console.error('❌ FAIL: Se permitió actualización parcial de protocolización.');
        errors++;
    } catch (e: any) {
        if (e.message.includes('protocolización')) {
            console.log('✅ PASS: Trigger bloqueó protocolización incompleta.');
        } else {
            console.error('❌ FAIL: Error inesperado:', e.message);
            errors++;
        }
    }

    // =========================================================================
    // 3. Validar Fechas Observador (Inicio > Fin)
    // =========================================================================
    console.log('\n[3] Marea: Fecha Inicio > Fin (Esperado: FALLO)');
    try {
        await prisma.marea.update({
            where: { id: marea.id },
            data: {
                fechaInicioObservador: new Date('2025-01-10'),
                fechaFinObservador: new Date('2025-01-05')
            }
        });
        console.error('❌ FAIL: Se permitió fecha inicio > fin.');
        errors++;
    } catch (e: any) {
        if (e.message.includes('La fecha de inicio del observador no puede ser posterior')) {
            console.log('✅ PASS: Gridder bloqueó fechas inválidas.');
        } else {
            console.error('❌ FAIL:', e.message);
            errors++;
        }
    }

    // =========================================================================
    // 4. Validar Cierre en Estado Designada (Sin cambio de estado)
    // =========================================================================
    console.log('\n[4] Marea: Cierre en Estado DESIGNADA sin cambiar estado (Esperado: FALLO)');
    // Asegurar que el estado inicial es DESIGNADA o similar activo.
    const estadoDesignada = await prisma.estadoMarea.findFirst({ where: { codigo: 'DESIGNADA' } });
    if (estadoDesignada) {
        await prisma.marea.update({ where: { id: marea.id }, data: { estadoActualId: estadoDesignada.id } });
        
        try {
            await prisma.marea.update({
                where: { id: marea.id },
                data: {
                    fechaInicioObservador: new Date('2025-01-01'),
                    fechaFinObservador: new Date('2025-01-10')
                }
            });
            console.error('❌ FAIL: Se permitió cerrar marea en estado DESIGNADA.');
            errors++;
        } catch (e: any) {
             if (e.message.includes('mientras la marea esté (o permanezca) en estado')) {
                console.log('✅ PASS: Trigger bloqueó cierre en estado activo.');
            } else {
                console.error('❌ FAIL:', e.message);
                errors++;
            }
        }
    } else {
        console.warn('⚠ SKIP: No se encontró estado DESIGNADA');
    }

    // =========================================================================
    // 5. Validar Cierre CON Cambio de Estado (Caso Válido)
    // =========================================================================
    console.log('\n[5] Marea: Cierre con cambio a FINALIZADA (Esperado: ÉXITO)');
    const estadoFinalizada = await prisma.estadoMarea.findFirst({ where: { codigo: 'PENDIENTE_DE_INFORME' } }); // O algun estado no activo
    
    if (estadoFinalizada && estadoDesignada) {
         try {
            await prisma.marea.update({
                where: { id: marea.id },
                data: {
                    estadoActualId: estadoFinalizada.id,
                    fechaInicioObservador: new Date('2025-01-01'),
                    fechaFinObservador: new Date('2025-01-10')
                }
            });
            console.log('✅ PASS: Se permitió cierre simultáneo con cambio de estado.');
        } catch (e: any) {
            console.error('❌ FAIL: Operación válida bloqueada:', e.message);
            errors++;
        }
    } else {
         console.warn('⚠ SKIP: No se encontraron estados para prueba de transición');
    }


    // Limpieza
    await cleanup();

    if (errors > 0) {
        console.error(`\n❌ Se encontraron ${errors} errores.`);
        process.exit(1);
    } else {
        console.log('\n✨ Todos los triggers verificados correctamente.');
        process.exit(0);
    }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
