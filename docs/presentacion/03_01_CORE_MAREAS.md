# 3.1 Módulo Core: Gestión del Ciclo de Vida de Mareas

> **La Columna Vertebral del Sistema**

---

## Concepto: La Marea como "Entidad Viva"

En los sistemas tradicionales, una marea era a menudo una fila estática en una planilla de cálculo. En SIGMA, una marea es una **entidad dinámica y trazable** que evoluciona a lo largo del tiempo.

El sistema modela la realidad operativa con precisión, entendiendo que una campaña no es un evento puntual, sino un proceso con múltiples fases, cambios de estado y actores involucrados.

---

## Detalle del Flujo de Trabajo (Workflow)

El ciclo de vida se gestiona a través de un workflow secuencial y validado:

### 1. Designación y Planificación
Todo comienza con la asignación inteligente. Al designar un observador a un buque:
*   **Validación de Disponibilidad:** El sistema verifica automáticamente que el observador no esté embarcado, de licencia o en periodo de descanso obligatorio.
*   **Configuración de Objetivos:** Se definen las metas de muestreo y la pesquería objetivo (ej. Langostiño, Merluza) desde el primer momento.

### 2. Ejecución: Etapas de Navegación
SIGMA introduce el concepto de **"Etapas"** para reflejar la complejidad real de la operación. Una marea puede tener múltiples etapas (ej. el buque entra a puerto por mal tiempo y vuelve a salir), y el sistema registra cada movimiento con granularidad:
*   **Zarpada:** Registro de fecha, hora y puerto de salida.
*   **Operación en Zona:** Seguimiento del periodo activo de pesca.
*   **Arribo:** Registro de fecha, hora y puerto de llegada.

### 3. Cierre y Rendición
Al finalizar la última etapa, se inicia el proceso formal de cierre:
*   Recepción de datos científicos.
*   Evaluación de desempeño.
*   Cierre administrativo de la comisión.

---

## Valor Estratégico: Integridad y Precisión

La mayor innovación de este módulo radica en su capacidad para manejar la complejidad temporal y garantizar la calidad del dato.

### Trazabilidad Completa
Cada cambio de estado, cada edición de fecha y cada movimiento queda registrado. Es posible reconstruir la historia completa de una marea meses después de finalizada, sabiendo exactamente quién modificó qué dato y cuándo.

### Manejo Inteligente de Fechas
El sistema resuelve uno de los problemas históricos más comunes: la confusión entre tiempos del buque y tiempos del personal. SIGMA diferencia y calcula automáticamente:
*   **Días Navegados (Buque):** El tiempo real que el barco estuvo fuera de puerto (Zarpada -> Arribo), descontando entradas intermedias.
*   **Días de Marea (Observador):** El periodo total de afectación del personal, que incluye los días de viaje y estadías en puertos no locales, fundamentales para la liquidación de viáticos y control de francos.
