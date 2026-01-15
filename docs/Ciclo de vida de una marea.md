# Manejo de fechas y cálculo de días en el ciclo de vida de una marea

Este documento describe de forma detallada y operativa cómo se registran las fechas relevantes de una marea, cómo se modelan las zarpadas y arribos, y cómo se calculan los **días navegados** y los **días de marea del observador**, contemplando mareas con una o múltiples etapas.

El diseño busca:

* claridad conceptual,

* trazabilidad administrativa,

* y cálculos robustos y reproducibles.

## 1\. Conceptos generales

En el ciclo de vida de una marea se distinguen tres niveles de información:

1. **Fechas globales de la marea**  
    Representan el período de trabajo del observador y se almacenan como atributos directos de la marea.

2. **Etapas de navegación**  
    Representan ciclos reales de operación del buque (zarpada → arribo) y pueden repetirse dentro de una misma marea.

3. **Alertas y eventos**  
    Registran señales externas, decisiones humanas y trazabilidad administrativa, pero no constituyen la fuente de verdad operativa.

Esta separación evita ambigüedades, permite auditoría fina y simplifica los cálculos.

## 2\. Fechas globales de la marea

Se almacenan directamente en la entidad **marea**, y representan el marco temporal del trabajo del observador.

### 2.1 Fecha estimada de zarpada

* **Descripción**: Fecha tentativa en la que se espera que el buque zarpe.

* **Momento de carga**: Al momento de la designación del observador.

* **Carácter**: Administrativa, no definitiva.

* **Uso**: Planificación, filtros, reportes preliminares.

### 2.2 Fecha de inicio del observador

* **Descripción**: Momento en que el observador inicia efectivamente su trabajo.

* **Casos típicos**:

  * Puerto local (Mar del Plata): suele coincidir con la fecha de zarpada.

  * Puerto no local: corresponde al inicio del viaje del observador hacia el buque.

* **Carácter**: Fecha real, corregible si es necesario.

### 2.3 Fecha de finalización del observador

* **Descripción**: Momento en que el observador finaliza su trabajo.

* **Casos típicos**:

  * Puerto local: suele coincidir con la fecha de arribo.

  * Puerto no local: incluye el viaje de regreso hasta destino final.

* **Carácter**: Fecha real, puede diferir del último arribo del buque.

> Estas fechas representan el **período total de afectación del observador** y no dependen directamente de la cantidad de etapas.

## 3\. Etapas de navegación

Las **etapas** modelan la operación real del buque y son la base para el cálculo de días navegados.

Cada etapa representa un ciclo:

> **Zarpada → Arribo**

### 3.1 Datos registrados en una etapa

* Fecha de zarpada

* Puerto de zarpada (referencia a catálogo de puertos)

* Fecha de arribo

* Puerto de arribo (referencia a catálogo de puertos)

El catálogo de puertos incluye un flag:

* `es_puerto_local` (true / false)

Este flag es fundamental para el cálculo de días de marea.

### 3.2 Reglas generales

* Una marea puede tener **una o múltiples etapas**.

* Puede existir una etapa con zarpada registrada y sin arribo (etapa abierta).

* No puede existir un arribo sin una zarpada previa.

* Mientras el observador siga designado, no se considera fin de marea, aunque haya múltiples arribos y zarpadas.

## 4\. Alertas externas y confirmación manual

Las zarpadas y arribos pueden ser detectados por **APIs externas** que monitorean buques designados.

### 4.1 Registro de alertas

Las detecciones externas se almacenan como **alertas**, no como etapas ni eventos definitivos.

Una alerta:

* indica una _posible_ zarpada o arribo,

* queda en estado pendiente,

* debe ser confirmada o descartada manualmente.

Esto permite:

* manejar falsos positivos,

* evitar duplicaciones,

* conservar evidencia del origen de la información.

### 4.2 Confirmación de una alerta

Cuando un operador confirma una alerta:

* **Zarpada confirmada**:

  * Si no hay etapa abierta → se crea una nueva etapa con fecha y puerto.

  * Si ya hay una etapa abierta → se solicita validación (caso excepcional).

* **Arribo confirmado**:

  * Se completa la etapa abierta correspondiente.

  * Si no existe etapa abierta, el sistema debe advertir inconsistencia.

### 4.3 Eventos de auditoría

Toda confirmación o descarte genera un **evento administrativo**, con el objetivo de dejar trazabilidad de la decisión humana.

Los eventos:

* no son la fuente de verdad operativa,

* documentan quién confirmó, cuándo y sobre qué alerta.

## 5\. Cálculo de días navegados

### 5.1 Definición

Los **días navegados** son los días calendario transcurridos entre la zarpada y el arribo de una etapa, **incluyendo ambos extremos**.

Ejemplo:

* Zarpada: 02/05/2025

* Arribo: 04/05/2025  
    → 3 días navegados (2, 3 y 4)

### 5.2 Múltiples etapas y solapamientos

Cuando hay más de una etapa:

* cada etapa tiene su propio rango de días navegados,

* pero **los días solapados no se cuentan más de una vez**.

Ejemplo:

* Etapa 1: 02/05 → 04/05

* Etapa 2: 04/05 → 06/05

Cada etapa tiene 3 días, pero el total es:

* 02, 03, 04, 05, 06 → **5 días navegados**

### 5.3 Estrategia de cálculo

1. Tomar todas las etapas con zarpada y arribo completos.

2. Convertir cada etapa en un intervalo de fechas calendario.

3. Unir los intervalos solapados o contiguos.

4. Sumar los días de cada intervalo resultante.

Este método garantiza:

* no duplicar días,

* resultados consistentes ante correcciones.

## 6\. Cálculo de días de marea del observador

### 6.1 Definición

Los **días de marea** son los días en los que el observador estuvo afectado a la marea, incluyendo:

* días de navegación,

* días de estadía en puerto,

* días de viaje (ida y vuelta),  
    según corresponda.

### 6.2 Cálculo base

Se parte del rango global del observador:

* Inicio: `fecha_inicio_observador`

* Fin: `fecha_fin_observador`

Cálculo base:

`días_base = fin - inicio + 1`

### 6.3 Descuento de estadías en puerto local

En mareas con múltiples etapas:

* Si entre un **arribo** y la **siguiente zarpada**:

  * ambos ocurren en un **puerto local**,

  * los días intermedios **no se consideran días de marea**.

* Si esto ocurre en un puerto **no local**, esos días **sí se cuentan**.

### 6.4 Estrategia de cálculo

1. Ordenar las etapas por fecha de zarpada.

2. Para cada par consecutivo de etapas:

    * calcular los días entre el arribo de la primera y la zarpada de la siguiente.

3. Si el puerto de arribo y el de la siguiente zarpada son locales:

    * restar esos días del total.

4. El resultado final es:

`días_marea = días_base - días_estadía_local`

## 7\. Beneficios del diseño adoptado

* Las fechas del observador son claras, editables y consultables.

* Las etapas representan fielmente la operatoria real del buque.

* Las alertas externas no contaminan los datos operativos.

* Los eventos dejan trazabilidad sin ser fuente de verdad.

* Los cálculos son reproducibles, auditables y simples de explicar.
