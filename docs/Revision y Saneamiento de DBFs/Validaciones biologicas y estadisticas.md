# Validaciones Biológicas, Estadísticas y Operativas (Sistema de Mareas)

Este documento define las reglas de consistencia para el control de calidad de datos en los ingresos diarios de Lances, Capturas, Muestras y Producciones. Estas validaciones detectan errores de tipado, inconsistencias operativas y datos biológicamente inverosímiles.

Se dividen en diferentes niveles de severidad:
*   **[ERROR]**: Inconsistencia dura que impide guardar o aceptar el dato (Ej. Fecha final < Fecha Inicial).
*   **[WARNING]**: Inconsistencia blanda o estadística. El dato es biológica u operativamente inusual, por lo que demanda una revisión de un analista o una confirmación, pero podría ser verdadero en casos excepcionales.

> [!NOTE]
> **Campos Opcionales:** Varias de las validaciones detalladas a continuación involucran variables que son opcionales en el modelo de datos (ej. velocidades, calador, tamaño del tramo de red, hora final). **Regla General:** Toda validación que dependa de un campo opcional sólo se ejecutará si dicho campo **está presente** (contiene un valor). Si el dato es nulo, la validación se omitirá automáticamente para evitar la generación de falsos positivos y sin bloquear el guardado de la información principal.

---

## 1. Validaciones a Nivel de Lance Individual

### 1.1 Espacio-Temporales
*   **[ERROR]** Temporal: `horaFinal` de arrastre debe ser cronológicamente posterior a `horaInicio`.
*   **[ERROR]** Duración Lógica: El tiempo total de arrastre (`tiempoRed`) debe coincidir (considerando conversiones de minutos/horas) con la diferencia entre `horaInicio` y `horaFinal`.
*   **[WARNING]** Duración Típica: `tiempoRed` no debería ser menor a 15 minutos ni mayor a X horas (ej. 6 horas en merluza). Si está fuera de rango, es probable error en horaInicio/horaFinal.
*   **[ERROR]** Cinemática de Arrastre: La `distanciaRed` (recorrida) debe ser matemáticamente coherente con el `tiempoRed` y la `velocidadArrastre` media. Tolerancia +/- 10%. $Distancia \approx Velocidad \times Tiempo$.
*   **[WARNING]** Velocidad Máxima de Arrastre: Un arrastre demersal a más de 5-6 nudos es físicamente improbable o ineficiente, levanta alerta.
*   **[ERROR]** Geometría y Rumbo: La posición (lat/lon inicio y fin) genera un vector de avance. Su rumbo calculado debe concordar con el campo reportado `rumbo` (Tolerancia angular +/- 15 grados).

### 1.2 Batimétricas (Profundidad)
*   **[ERROR]** Fondo Invertido: `fondoMin` no puede ser mayor que `fondoMax`.
*   **[WARNING]** Profundidad Red vs Fondo: `profInicio` / `profFinal` (profundidad del arte de pesca) debería ser próxima al fondo (si es red demersal o de arrastre de fondo) o razonablemente pelágica (si es red de arrastre pelágica). No puede ser mayor a la profundidad del fondo.
*   **[WARNING]** Posición vs Batimetría: (Si hay cruce con base GIS) La profundidad reportada debe coincidir con la topografía de la plataforma marina para esa coordenada. Evita errores graves de coordenadas positivas/negativas.

### 1.3 Calibración de Pesos Globales vs Especies
*   **[ERROR]** Total Capturado: En un lance, la sumatoria de todas las `Captura.kgCaptura` para todas las especies retendias NO puede exceder (ni desviar marcadamente, ej >5%) al total reportado manual `capturaTotalKg` (si este existe como estimación total de cubierta).
*   **[ERROR]** Total Descarte: Similar a lo anterior; la sumatoria de `Captura.kgDescarte` no debe exceder sustancialmente el sumario de `descarteTotalKg` del lance.

---

## 2. Validaciones Secuenciales (Lances Sucesivos)

*   **[ERROR]** Solapamiento Temporal: El `horaInicio` del Lance N+1 (ordenados por número) debe ser estrictamente MAYOR al `horaFinal` del Lance N. Un barco no puede hacer dos lances a la vez.
*   **[WARNING]** Sobreposición Espacial Imposible: La trayectoria de tránsito libre. La distancia geográfica entre el fin del Lance N (Lat/Lon final) y el inicio del Lance N+1 (Lat/Lon inicial), computada en el lapso transcurrido entre los dos (Tiempo Tránsito = N1_inicio - N_final), no puede exigir una velocidad de navegación superior a la velocidad máxima libre del buque (ej. 14 nudos). Evita coordenadas mal ingresadas o cruce de hemisferios accidental (Latitud errada por un signo +/-).

---

## 3. Validaciones Cruzadas: Captura y Producción (Balance de Masas)

*   **[ERROR]** Especies Procesadas ≠ Especies Capturadas: Si la tabla `Produccion` registra cajas/toneladas de una especie un día, debe haber registros en la tabla `Captura` referenciando captura retenida (`kgCaptura` > 0) de la misma especie durante los lances de ese día (o el día anterior, permitiendo stock inter-diario en bodega).
    *   *Nota operativa:* Esto es especialmente crítico en pesquerías como el **Langostino**, donde la captura de un día suele procesarse parcialmente ese mismo día, pero es normal terminar con la producción del remanente de esa materia prima en el día posterior.
*   **[ERROR/WARNING]** Límite Material (Balance): La Producción Diaria Calculada en Toneladas equivalentes de materia prima pura (`Produccion.kgProduccion` dividido por el `Produccion.factorConversion` al producto derivado) de una especie E **NO DEBE EXCEDER** la sumatoria total retenida (`Captura.kgCaptura`) de esa misma especie E en los lances correspondientes a ese horizonte (mismo día/etapa).
*   *Nota*: El Factor de conversión permite saber cuántos Kilos puros ("entero redondo") representaban esos kilos de "filete" procesado.
*   **[WARNING]** Captura Incidental Retenida: Si se registra mucha captura retenida de una especie regulada (bycatch) pero producción no reporta, hay potencial descarte no asentado o viceversa.

---

## 4. Validaciones Biológicas: Muestras (Distribución de Talla / Frecuencia)

Estas validaciones aplican sobre los agregados presentes en `Muestras` y sus `MuestraDetalleTalla`.

*   **[ERROR]** Relación Muestra-Captura: No puede existir una entrada en `Muestras` referenciando una especie E para el lance L si en `Capturas` del Lance L esa misma especie no fue reportada como capturada y/o descartada > 0kg.
*   **[ERROR]** Consistencia Frecuencia: La sumatoria de totales por talla (Suma de `cantidadTotal` de todos los `MuestraDetalleTalla`) debe ser idéntico al campo `totalMediciones` reportado en el encabezado de la `Muestra`.
*   **[ERROR]** Verificación de Integridad Sexual: `cantidadTotal` en `muestras_detalle_talla` DEBE igualar la sumatoria rigurosa de `cantidadMachos` + `cantidadHembras` + `cantidadIndet`.
*   **[ERROR/WARNING]** Limites Máximos y Mínimos (Biológicos): Las tallas (`MuestraDetalleTalla.tallaMm`) recolectadas DEBEN estar entre los rangos absolutos biológicos conocidos para esa `Especie` en catálogo (ej: un langostino de 500mm es un error humano de escala y coma flotante).
*   **[WARNING]** Sex Ratio Estadística: Si de N=200 ejemplares muestreados, la proporción de machos es 0% o es >95%, siendo una especie habitualmente 1:1, lanza alarma. Quizá el observador olvidó cargar un sexo.

---

## 5. Validaciones Botánicas / Biológicas Profundas: Submuestras

El análisis sobre individuos únicos medidos exhaustivamente (`submuestras`).

*   **[ERROR]** Pertenencia de Talla: Un individuo detallado en la Submuestra, cuya talla es `largoTotal`, DEBE caer dentro de los rangos registrados (`primeraTalla` a `ultimaTalla`) de su distribución frecuencial madre en `Muestra`. Su talla no debería ser un pico anómalo no documentado en la frecuencia original.
*   **[WARNING]** Curva Alométrica de Paridades (Relación Peso / Talla): La validación estrella biológica. Todo par ($L$, $W$) de la biometría donde $L =$ `largoTotal` y $W =$ `pesoTotalG` se debe comparar contra la función $W = a \cdot L^b$ (Parámetros especie-específicos). Se permite una envolvente estadística de +/- X % de tolerancia. Cualquier individuo cuyo peso difiera garrafalmente para su talla implica una transposición de cifras o falla de tara en la balanza de a bordo.
*   **[ERROR]** Lógica de Masas Somáticas: `pesoGonadasG` (peso de ovarios/testículos) ESTRICTAMENTE MENOR que `pesoTotalG`. No puede existir tampoco valores de IGS (Índice gonadosomático = Péso gónadas/Peso Total) superiores a un umbral biológico máximo razonable por especie (ej. > 30% del peso en peces es insostenible generalmete).
*   **[WARNING]** Escala Madurativa y Longitudes: Si el `estadioMadurez` reporta a un individuo maduro / en desove, el `largoTotal` de este individuo idealmente superaría (o estaría muy próximo) a la Talla de Primera Madurez ($L_{50}$) de la población objeto, o ser mayor al mínimo reproductivo absoluto histórico conocido. Valores inmaduros anómalos (ej. 1 juvenil chiquito reportado estadío de madurez avanzado = error de carga humana en las grillas manuales del observador).
*   **[ERROR]** Relación de Sexo-Madurez Inferida: Animales listados y medidos taxonómicamente bajo un marco "Sexo Indeterminado / Juveniles no diferenciados" no pueden poseer anotaciones relativas a estadíos madurativos de reproducción avanzada.

---

## 6. Integridad de los Catálogos y Requisitos Opcionales

*   **[ERROR]** Las tablas maestras definen la regla de juego. Todo código interno inserto por los observadores o la base de Access migrada debe cruzar correctamente (pesquería vs arte, especie bentónica no admisible en arte pelágico mediano pelágico `[WARNING]`, etc.).
*   **[ERROR]** Si una Muestra tiene `tipoMuestra` == "Talla por Sexo", se espera obligadamente que la información esté dividida entre Macho/Hembra en la tabla de detalle. Si el `tipoMuestra` es "Muestra Descarte Sin Sexar", todos los recuentos deberán caer inexorablemente en la canasta del registro `cantidadIndet`.
