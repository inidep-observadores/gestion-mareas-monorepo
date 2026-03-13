# Propuesta de Intercambio de Datos: Programa de Observadores INIDEP - CTMFM

## 1. Introducción y Marco Conceptual

El **Programa de Observadores a Bordo del INIDEP** constituye una herramienta fundamental para la generación de conocimiento científico de alta calidad sobre los recursos pesqueros. En el contexto de la Comisión Técnica Mixta del Frente Marítimo (CTMFM) y sus grupos de trabajo responsables de la evaluación del recurso Merluza (Merluccius hubbsi), la información recolectada por observadores a bordo es vital para la toma de decisiones de ordenación pesquera basadas en evidencia.

El sistema de gestión de mareas del INIDEP permite el registro sistemático de datos biológico-pesqueros, ambientales y de artes de pesca con un alto grado de resolución espacial y temporal. La presente propuesta formaliza un protocolo de exportación de datos diseñado para facilitar el intercambio de información entre el INIDEP y la CTMFM, garantizando la trazabilidad, calidad y estandarización de los datos.

## 2. Definición del Programa de Recolección

Los datos relevados se estructuran en torno a la **Marea de Pesca**, el **Lance** y el **Muestreo Biológico**. El flujo de información garantiza:
- **Trazabilidad Geográfica**: Posiciones precisas de inicio y fin de cada lance dentro de la Zona Común de Pesca.
- **Caracterización Ambiental**: Registro de condiciones meteorológicas y de temperatura del agua durante la operación.
- **Selectividad y Artes**: Detalle técnico sobre las redes y dispositivos de selectividad empleados.
- **Estructura Poblacional**: Datos biométricos de frecuencia de tallas, sexo y madurez gonadal.

## 3. Formato de Intercambio Propuesto

Se propone un formato basado en archivos de texto plano (.csv) con codificación UTF-8, estructurados para minimizar la dependencia de sistemas externos y facilitar su importación en diferentes plataformas de análisis estadístico (R, Python, Excel).

La propuesta incluye cuatro (4) conjuntos de datos vinculados:

### A. Datos de Operación (Lances)
Contiene la información del esfuerzo pesquero, posición geográfica y condiciones del entorno.
- **Campos Clave**: Año, Número de marea, Número de lance.
- **Datos Relevantes**: Nombre del buque, fechas, horas, posiciones decimales, condiciones ambientales, parámetros de la red y uso de dispositivos de selectividad.

### B. Capturas Específicas
Detalle de la composición de la captura por especie para cada lance.
- **Campos Clave**: Año, Marea, Lance, Especie (Nombre Científico).
- **Datos Relevantes**: Peso retenido (kg) y peso descartado (kg).

### C. Estructura de Tallas (Muestreo Grupal)
Frecuencia de longitudes recolectada para la evaluación de la estructura poblacional.
- **Campos Clave**: Año, Marea, Lance, Especie, Largo (cm), Sexo.
- **Datos Relevantes**: Cantidad de ejemplares por cada categoría.

### D. Datos Biológicos Individuales (Submuuestras)
Información detallada a nivel de ejemplar para estudios de crecimiento y biología reproductiva.
- **Campos Clave**: Año, Marea, Lance, Especie, Número de ejemplar.
- **Datos Relevantes**: Largo (cm), peso (g), sexo, estadío de madurez, grado de repleción y contenido estomacal.

## 4. Consideraciones Técnicas y Estandarización

Para asegurar la interoperabilidad, la propuesta adopta los siguientes estándares:
- **Nomenclatura Científica**: Identificación unívoca de especies mediante nombres científicos.
- **Unidades del Sistema Internacional**: Pesos en kg/g, longitudes en mm, profundidades en metros.
- **Coordenadas Decimales**: Facilita la representación cartográfica inmediata en sistemas SIG.
- **Nombres de Campos Autodescriptivos**: Inclusión de la unidad de medida en el nombre del campo (ej. `peso_gramos`).

---
*Este documento constituye una propuesta técnica preliminar sujeta a revisión por parte de los Grupos de Trabajo de la CTMFM y las autoridades de coordinación del Programa de Observadores a Bordo del INIDEP.*

<br>

# Anexo: Estructura Detallada de Datos

Este anexo detalla la estructura de los 4 archivos CSV propuestos para la exportación de datos.

## Campos Comunes de Relación
En todos los archivos se incluyen estos campos para permitir la vinculación de los datos:
- `anio`: Año de la marea (Extraído de la fecha del lance).
- `nro_marea`: Número correlativo de la marea dentro del año.
- `nro_lance`: Número correlativo del lance dentro de la marea.

## 1. Lances.csv
Contiene la información general de cada operación de pesca.

| Campo | Tipo | Descripción / Comentario |
|-------|------|-------------------------|
| `anio` | Integer | Año de la marea. |
| `nro_marea` | Integer | Número de la marea. |
| `buque_nombre` | String | Nombre de la embarcación (aplanado). |
| `nro_lance` | Integer | Número del lance. |
| `fecha` | Date | Fecha del lance (Formato YYYY-MM-DD). |
| `hora_inicio` | Time | Hora de inicio (Formato HH:MM). |
| `hora_final` | Time | Hora de finalización (Formato HH:MM). |
| `latitud_inicio_decimal` | Decimal | Latitud inicial en grados decimales. |
| `longitud_inicio_decimal` | Decimal | Longitud inicial en grados decimales. |
| `latitud_final_decimal` | Decimal | Latitud final en grados decimales. |
| `longitud_final_decimal` | Decimal | Longitud final en grados decimales. |
| `profundidad_inicio_m` | Integer | Profundidad al inicio en metros. |
| `profundidad_final_m` | Integer | Profundidad al final en metros. |
| `estado_tiempo_codigo` | Integer | Código de estado del tiempo (de planilla). |
| `estado_mar_codigo` | Integer | Código de estado del mar (de planilla). |
| `viento_direccion_grados` | Integer | Dirección del viento en grados (0-360). |
| `viento_fuerza_nudos` | Integer | Fuerza del viento en nudos. |
| `temperatura_aire_c` | Decimal | Temperatura del aire en grados Celsius. |
| `temperatura_red_c` | Decimal | Temperatura en la red en grados Celsius. |
| `presion_hpa` | Integer | Presión atmosférica en hectopascales (o mb). |
| `captura_total_kg` | Decimal | Peso total capturado en kilogramos. |
| `velocidad_arrastre_nudos` | Decimal | Velocidad de arrastre en nudos. |
| `rumbo_grados` | Integer | Rumbo de navegación en grados. |
| `malla_copo_mm` | Integer | Abertura de malla en el copo en milímetros. |
| `malla_alas_mm` | Integer | Abertura de malla en las alas en milímetros. |
| `cable_filado_m` | Integer | Longitud de cable filado en metros. |
| `abertura_vertical_m` | Decimal | Abertura vertical de la red en metros. |
| `distancia_alas_m` | Decimal | Distancia entre alas en metros. |
| `profundidad_arte_m` | Integer | Profundidad del arte de pesca en metros. |
| `selectividad_si_no` | Boolean | Indica si se usó algún dispositivo de selectividad (1: Sí, 0: No). |

## 2. Capturas.csv
Detalle de las especies capturadas por cada lance.

| Campo | Tipo | Descripción / Comentario |
|-------|------|-------------------------|
| `anio` | Integer | Clave de relación. |
| `nro_marea` | Integer | Clave de relación. |
| `nro_lance` | Integer | Clave de relación. |
| `especie_nombre_cientifico` | String | Nombre científico de la especie (Clave única por lance). |
| `captura_kg` | Decimal | Peso de la captura en kilogramos. |
| `descarte_kg` | Decimal | Peso del descarte en kilogramos. |

## 3. Muestras.csv
Información biométrica agrupada (frecuencia de tallas).

| Campo | Tipo | Descripción / Comentario |
|-------|------|-------------------------|
| `anio` | Integer | Clave de relación. |
| `nro_marea` | Integer | Clave de relación. |
| `nro_lance` | Integer | Clave de relación. |
| `especie_nombre_cientifico` | String | Nombre científico de la especie. |
| `largo_cm` | Integer | Largo total del ejemplar en centímetros (Clave única con especie). |
| `sexo` | String | Sexo del ejemplar (Ej: "Macho", "Hembra", "Indeterminado"). |
| `cantidad_ejemplares`| Integer | Número de ejemplares registrados para esa talla/sexo. |

## 4. Submuestras.csv
Datos individuales de ejemplares muestreados en detalle.

| Campo | Tipo | Descripción / Comentario |
|-------|------|-------------------------|
| `anio` | Integer | Clave de relación. |
| `nro_marea` | Integer | Clave de relación. |
| `nro_lance` | Integer | Clave de relación. |
| `especie_nombre_cientifico` | String | Nombre científico de la especie. |
| `nro_ejemplar` | Integer | Número correlativo del ejemplar (Clave única por especie/lance). |
| `largo_cm` | Integer | Largo total del ejemplar en centímetros. |
| `sexo` | String | Sexo del ejemplar. |
| `peso_gramos` | Decimal | Peso del ejemplar en gramos. |
| `estadio_gonadal` | Integer | Código de estadío madurez gonadal. |
| `grado_replecion` | Integer | Código de grado de repleción estomacal. |
| `contenido_estomacal`| String | Descripción del contenido estomacal observado. |
