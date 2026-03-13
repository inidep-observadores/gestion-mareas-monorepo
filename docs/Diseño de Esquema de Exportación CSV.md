# Diseño de Esquema de Exportación CSV (SIGMA)

Este documento detalla la estructura de los 4 archivos CSV propuestos para la exportación de datos a sistemas externos. Los datos han sido aplanados para eliminar la dependencia de tablas paramétricas.

## Campos Comunes de Relación
En todos los archivos se incluyen estos campos para permitir la vinculación de los datos:
- `anio`: Año de la marea (Extraído de la fecha del lance).
- `nro_marea`: Número correlativo de la marea dentro del año.
- `nro_lance`: Número correlativo del lance dentro de la marea.

---

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

---

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

---

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

---

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
