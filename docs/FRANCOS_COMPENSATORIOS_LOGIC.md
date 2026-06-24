# Lógica de Francos Compensatorios (Para futuras iteraciones)

Esta documentación describe la regla de negocio para la acumulación de **Francos Compensatorios** que los observadores generan mientras prestan funciones durante días no hábiles (Fines de semana y Feriados).

## Reglas de Acumulación

Dentro del período en que el observador está asignado o ejecutando una marea, **cada fin de semana (sábado y domingo) y feriado computa 1 (un) día de franco acumulable**, siempre y cuando el observador se encuentre en condiciones de **No Residencia Habitual** o prestando servicios directos en la marea:

1. **Navegación**: Todo fin de semana o feriado en el que el observador esté `NAVEGANDO` (en alta mar entre `fechaZarpada` y `fechaArribo` de una etapa) genera 1 día de franco.
2. **Puertos No Locales (Fuera de Mar del Plata)**: 
   - A quienes inician o finalizan la marea en un puerto **NO local** se les considera cualquier fin de semana o feriado para acumular francos.
   - Esto incluye los días `EN VIAJE` (el trayecto desde que salen de su casa, `fechaInicioObservador`, hasta que embarcan).
   - Incluye los días `EN PUERTO` que aguardan entre dos etapas de la misma marea en un puerto que no sea el puerto local base.
3. **Puertos Locales (Mar del Plata)**:
   - Cuando las etapas inician o finalizan en el puerto **LOCAL**, los días que pasa en puerto NO acumulan días de franco (dado que el observador pernocta o aguarda en su residencia habitual).
   - Si el buque zarpa en la primera etapa desde puerto local o arriba la última etapa en puerto local, **cualquier diferencia de días** (los días `EN VIAJE` locales, o tiempo de espera local) **tampoco acumulan francos**, sin importar cuántos días de diferencia haya entre el inicio de funciones y la zarpada.

## Implementación Propuesta

Una vez estabilizado el motor de cruce de días de la matriz de presentismo, la "Bolsa de Francos" se construirá iterando sobre los días del observador en un rango dado (mensual, o por marea) y aplicando las reglas anteriores para arrojar el `totalFrancosGanados`.
