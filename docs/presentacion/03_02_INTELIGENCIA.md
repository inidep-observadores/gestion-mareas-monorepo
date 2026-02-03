# 3.2 Módulo de Inteligencia y Monitoreo

> **Gestión Proactiva Basada en Eventos**

---

## Cambio de Paradigma: De lo Reactivo a lo Proactivo

Tradicionalmente, la gestión pesquera dependía de reportes que llegaban con días de retraso. SIGMA invierte esta lógica mediante una **capa de inteligencia activa** que monitorea periódicamentela flota, permitiendo a los coordinadores anticiparse a los problemas en lugar de solo reaccionar ante ellos.

---

## 1. Sistema de Alertas Inteligentes
El sistema consume datos de diversas fuentes (APIs de posición, reportes electrónicos) para detectar eventos relevantes. La distinción clave en este módulo es la separación entre "Ruido" y "Dato Confirmado":

### Alertas Automáticas (Posibles Eventos)
El sistema detecta una señal, por ejemplo, un buque designado que comienza a moverse a velocidad constante fuera del puerto. Esto genera una **Alerta Pendiente**.
*   No altera los datos "oficiales" de la marea automáticamente.
*   Requiere la intervención humana para validar el contexto.

### Eventos Confirmados (La Decisión Humana)
Un operador revisa la alerta y toma una decisión: **Confirmar** o **Descartar**.
*   **Si se confirma:** La alerta se transforma en una "Etapa" oficial (ej. se crea una Zarpada en el sistema).
*   **Si se descarta:** La alerta se archiva como falso positivo, pero queda en el historial para auditoría.

Este mecanismo híbrido combina la velocidad de la automatización con el criterio irreemplazable del experto humano.

---

## 2. Validación Geoespacial y Mapas
Para tomar decisiones informadas, el contexto visual es fundamental. SIGMA integra herramientas cartográficas avanzadas directamente en el flujo de gestión:

### Visor de Trayectorias (Contexto de 24hs)
Ante cualquier alerta (ej. "Posible Zarpada"), el operador puede desplegar un mapa interactivo que muestra la derrota exacta del buque durante las 24 horas circundantes al evento. Esto permite distinguir visualmente:
*   Una maniobra de prueba de máquinas (movimiento local).
*   Un traslado a otro muelle.
*   Una salida efectiva a zona de pesca.

### Geocercas y Zonas de Manejo
El sistema verifica geográficamente la actividad. Si un buque reporta estar pescando en una zona específica, el sistema puede contrastar esto con su posición real, alertando inmediatamente si opera en áreas de veda o zonas no habilitadas para su pesquería objetivo.

> **Nota:** Aunque el rol del Programa de Observadores es estrictamente científico y no de fiscalización, esta capacidad de validación es un activo invaluable. Permite a los distintos Programas de Investigación monitorear con precisión la distribución del esfuerzo pesquero, asegurando que los datos biológicos estén vinculados a áreas geográficas certeras y verificadas.

---

## 3. Tableros de Control para la Dirección
La inteligencia de datos se sintetiza en Dashboards ejecutivos diseñados para responder preguntas críticas en segundos:
*   **¿Cuántos observadores están embarcados hoy?**
*   **¿Qué buques con observador están próximos a arribar?** (Para coordinar logística de recepción).
*   **¿Hay alertas de inconsistencia pendientes de resolución?**

Estos tableros transforman miles de registros individuales en indicadores claros de salud y rendimiento del Programa.
