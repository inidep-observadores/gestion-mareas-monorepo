# SIGMA: Sistema Integral de Gestión de Mareas y Alertas
## Documento de Presentación Ejecutiva

---

### 1. RESUMEN EJECUTIVO

**SIGMA** (Sistema Integral de Gestión de Mareas y Alertas) es la plataforma tecnológica desarrollada para la modernización de la gestión operativa del **Programa de Observadores a Bordo del INIDEP**.

Su propósito fundamental es dotar a la coordinación del Programa de una capacidad de supervisión integral, centralizada y en tiempo real sobre el ciclo de vida de las mareas y el despliegue de personal técnico y científico. Al digitalizar flujos de trabajo que históricamente dependían de procesos manuales, SIGMA asegura la **trazabilidad del dato**, optimiza la logística de embarque y fortalece la calidad de la información base para la investigación pesquera.

---

### 2. INTRODUCCIÓN Y CONTEXTO

La gestión de observadores a bordo es una operación logística de alta complejidad que involucra la coordinación de personal, la interacción con la flota comercial y el cumplimiento de rigurosos protocolos de muestreo científico.

Históricamente, esta gestión se ha enfrentado a desafíos significativos debido a la fragmentación de la información. Datos críticos como la disponibilidad de observadores, la ubicación de los buques y el estado de las mareas residían en planillas dispersas, correos electrónicos o registros físicos. Esta descentralización dificultaba la visión global del Programa, aumentaba el riesgo de inconsistencias en los datos y retrasaba la toma de decisiones operativas.

En respuesta a este escenario, SIGMA se concibe no solo como un sistema de registro, sino como un **entorno operativo unificado**. Su implementación busca trascender el mero almacenamiento de datos para proveer herramientas activas de gestión que acompañen al coordinador y al personal administrativo en cada etapa del proceso, desde la planificación de una campaña hasta la recepción final de los datos científicos.

---

### 3. OBJETIVOS ESTRATÉGICOS

La implementación de SIGMA persigue cuatro objetivos rectores alineados con la misión del INIDEP:

*   **Aseguramiento de la Calidad del Dato:** Implementar barreras de entrada digitales y validaciones automáticas que garanticen la integridad de la información (fechas, buques, zonas) antes de que esta ingrese a las bases de datos científicas.
*   **Optimización Logística:** Maximizar la eficiencia en el despliegue de observadores mediante herramientas que facilitan la asignación de buques, el control de rotaciones y el seguimiento de licencias y disponibilidad.
*   **Trazabilidad y Transparencia:** Mantener un registro histórico inmutable y auditable de todas las acciones del Programa, permitiendo reconstruir la historia completa de cualquier marea o legajo de personal.
*   **Gestión Proactiva:** Cambiar el paradigma de gestión reactiva (resolver problemas post-facto) a un enfoque preventivo, donde el sistema alerta sobre inconsistencias o necesidades operativas en tiempo real.

---

### 4. CAPACIDADES Y FUNCIONALIDADES CLAVE

Para cumplir con estos objetivos, SIGMA despliega un conjunto de módulos funcionales interconectados:

#### A. Gestión del Ciclo de Vida de Mareas (Core)
Es el corazón del sistema, donde se administra el flujo de trabajo de cada observador de manera secuencial y ordenada:
*   **Designación y Logística:** Permite asignar personal a buques específicos basándose en disponibilidad real, configurar los objetivos de muestreo y gestionar la documentación previa al embarque.
*   **Seguimiento de Etapas:** Monitoreo paso a paso de la marea: "Designada", "Zarpada", "En Zona de Pesca", "Regresando", "Finalizada".
*   **Cierre y Rendición:** Proceso formal de recepción de la información biológico-pesquera y cierre administrativo de la comisión.

#### B. Centro de Monitoreo y Alertas
Herramientas de apoyo para la supervisión activa de las campañas:
*   **Tablero de Control (Dashboard):** Visión panorámica de todos los observadores desplegados, buques activos y alertas pendientes de resolución.
*   **Sistema de Alertas Inteligentes:** Detección automática de inconsistencias (ej. discrepancias entre fechas reportadas y movimientos reales) para su corrección temprana.
*   **Mapa de Trayectorias y Eventos:** Visualización de las derrotas de los buques para corroborar las áreas de operación reportadas por el personal científico.

#### C. Gestión del Capital Humano y Flota
Módulos transversales para la administración de los recursos del Programa:
*   **Legajo Digital de Observadores:** Historial completo de mareas realizadas, desempeño, capacitaciones y estado actual (Disponible, Embarcado, Vacaciones, Licencia).
*   **Registro de Buques:** Base de datos actualizada de la flota comercial monitoreada, historial de coberturas y características técnicas relevantes para el embarque.

#### D. Integridad y Análisis de Datos
Funcionalidades invisibles pero críticas para la robustez científica:
*   **Validación de Reglas de Negocio:** Controles automáticos que impiden la carga de datos incoherentes (ej. superposición de fechas, observadores asignados a múltiples buques).
*   **Reportes de Gestión:** Generación automática de métricas de cobertura, días navegados y esfuerzo de muestreo para asistir a la Dirección en la planificación estratégica.

---

### 5. ESTADO DE SITUACIÓN Y PROYECCIÓN

**Estado Actual**
SIGMA se encuentra actualmente en sus **fases iniciales de desarrollo**, operando con un conjunto de funcionalidades basales que ya permiten gestionar el flujo diario de asignaciones y seguimiento de mareas.
Si bien la arquitectura central está operativa, la plataforma se encuentra en evolución activa. Se está ejecutando un plan de desarrollo escalonado que prevé la incorporación progresiva de los módulos restantes, siguiendo la planificación estratégica establecida.

**Proyección y Mejora Continua**
El desarrollo de SIGMA es dinámico. En paralelo a la implementación de la hoja de ruta técnica, se lleva a cabo un **análisis continuo de necesidades** presentes y futuras junto a los responsables del Programa.
Este enfoque asegura que el sistema no sea estático; se busca identificar e incorporar nuevas funcionalidades que resulten útiles o necesarias para la gestión, garantizando que la evolución tecnológica acompañe siempre los requerimientos reales de la investigación pesquera.
