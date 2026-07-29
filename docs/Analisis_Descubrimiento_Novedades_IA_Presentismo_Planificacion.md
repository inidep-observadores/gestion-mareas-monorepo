# Análisis de Descubrimiento de Novedades por IA: Integración entre Presentismo y Planificación de Embarques

**Proyecto:** SIGMA (Sistema Integral de Gestión de Mareas)  
**Organismo:** INIDEP (Instituto Nacional de Investigación y Desarrollo Pesquero)  
**Fecha:** Julio 2026  
**Estado:** Documento de Análisis y Diseño de Dominio (Previo a Implementación de Código)

---

## 1. Contexto y Propósito

El módulo de procesamiento automático de novedades mediante Inteligencia Artificial (IA) lee correos electrónicos entrantes y sus adjuntos (notas GDE, pasajes, certificados médicos, texto libre) para extraer eventos de disponibilidad o ausencia del personal de observadores.

El propósito de este documento es definir la arquitectura de dominio y las reglas de negocio para el tratamiento de estas novedades, estableciendo claramente su doble propósito dentro del sistema SIGMA:
1. **Alimentar el Módulo de Presentismo** (Control contable, legal y de liquidación de haberes para personal en relación de dependencia).
2. **Alimentar el Módulo de Planificación de Embarques** (Logística operativa, cálculo de disponibilidad y asignación de mareas para todo el cuerpo de observadores).

---

## 2. Arquitectura de Ingesta y Desacoplamiento de Dominios

```
[ Ingesta IMAP / Correos ] ──► [ Parser LLM / IA ] ──► [ Novedad PENDIENTE (Bandeja Triage) ]
                                                                  │
                                                        [ APROBACIÓN MANUAL ]
                                                                  │
                                       ┌──────────────────────────┴──────────────────────────┐
                                       ▼                                                     ▼
                     [ MÓDULO DE PRESENTISMO ]                            [ MÓDULO DE PLANIFICACIÓN ]
                     - Enfoque: RRHH / Liquidación                        - Enfoque: Logística / Asignación
                     - Personal: Relación de dependencia                  - Personal: Todos (Planta, Contratados, Eventuales)
                     - Regla: Exige formalidad (GDE)                      - Regla: Considera compromisos formales e informales
                     - Cálculo: Días contables / Francos                  - Cálculo: Ventanas operativas / Disponibilidad
```

### 2.1 Regla Transversal de Ingesta con IA (Aprobación Humana Mandatoria)
**Toda novedad detectada automáticamente por la IA NUNCA ingresa como aprobada o activa en la base de datos operativa.** Se registra obligatoriamente en estado **`PENDIENTE`** (Origen `EMAIL`) dentro de la bandeja de auditoría/triage. Ninguna inferencia del modelo LLM modifica el estado real o el calendario del observador sin la **intervención y aprobación manual explícita** por parte del coordinador o administrador.

### 2.2 Capa Ingestora Única
El proceso de lectura de emails actúa como una **Capa Ingestora Única**. Su función es estandarizar la información no estructurada en **Eventos Temporales de Novedad** (`fechaInicio`, `fechaFin`, `tipoNovedad`, `observadorId`, `origenDoc`).

### 2.3 Consumidor 1: Módulo de Presentismo (RRHH / Contable)
* **Objetivo:** Registro contable y justificación legal de ausencias, licencias oficiales y seguimiento de francos compensatorios (devengados vs. gozados).
* **Foco:** Aplica al personal en relación de dependencia.
* **Criterio:** Rígido. Solo computa ausencias respaldadas por actos administrativos formales o certificaciones válidas.

### 2.4 Consumidor 2: Módulo de Planificación de Embarques (Operativo / Logístico)
* **Objetivo:** Determinar la elegibilidad y ventanas temporales en las que un observador puede ser asignado a mareas (embarques, prospecciones, comisiones).
* **Foco:** Aplica a **todos los observadores** (relación de dependencia, contratados y eventuales).
* **Criterio:** Flexible y Preventivo. Un aviso informal (*"el 12/09 no puedo navegar por un trámite personal"*) es fundamental para la logística de embarque, impidiendo que el planificador designe a un observador en una fecha donde no estará disponible.

---

## 3. Clasificación del Catálogo: Novedades Formales vs. Informales

Para que el motor de dominio procese automáticamente cada novedad sin código rígido ni condicionales frágiles, la tabla de catálogo `tipos_novedad` se extenderá conceptualmente con un atributo de clasificación de formalidad:

### 3.1 Novedades Formales (`es_formal = true`)
* **Ejemplos:** Licencia Anual Ordinaria (Vacaciones GDE), Francos Compensatorios Aprobados por Disposición, Licencia Médica / Parte de Enfermedad, Licencia por Estudio, Comisiones Oficiales.
* **Impacto en Presentismo:** Justifica inasistencia contable y computa en haberes / planillas.
* **Impacto en Planificación:** Infranqueable. Invalida la disponibilidad del observador para embarques.
* **Prioridad de Resolución:** Jerarquía Máxima. No puede ser anulada ni recortada por un aviso informal por correo sin acto administrativo.

### 3.2 Novedades Informales (`es_formal = false`)
* **Ejemplos:** Aviso directo por email (*"disponible a partir de tal fecha"*), Aviso de compromiso personal / imprevisto, Pasaje / Traslado informado por el observador.
* **Impacto en Presentismo:** No justifica liquidación de haberes por sí sola.
* **Impacto en Planificación:** Alta prioridad logística. Bloquea o habilita la ventana de embarque operativa para evitar fallos de cobertura en mareas.
* **Prioridad de Resolución:** Jerarquía Flexible. Puede ser sobrescrita o actualizada por el observador o por una novedad formal.

---

## 4. Análisis Detallado de los Escenarios Principales

### Escenario 1: Declaración de Disponibilidad Futura (Interpretación e Indisponibilidad Implícita)

**Situación:** El observador envía un email indicando *"voy a estar disponible a partir del 10 de septiembre"*.

* **Análisis de Datos Explícitos vs. Implícitos:**
  * **Dato Explícito:** A partir del `10/09` el observador declara estar operativo (`DISPONIBLE`).
  * **Dato Implícito:** No está disponible para ser asignado a mareas en el periodo previo (desde la fecha actual hasta el `09/09`).
* **Tratamiento en Planificación de Embarques (tras aprobación manual):**
  1. Se registra la novedad `DISPONIBLE` con `fechaInicio = 10/09`.
  2. Se actualiza el atributo en la ficha del observador: `fechaProximaDisponibilidad = 10/09`.
  3. Para el periodo previo (hasta el `09/09`), el sistema evalúa el historial:
     * Si el observador ya cuenta con mareas, francos o licencias en ese rango, **no se genera ninguna novedad adicional**.
     * Si existe un "hueco" (gap) sin justificar, el Módulo de Planificación trata al observador como **No Asignable** para la logística de embarques y genera un aviso preventivo para el coordinador (*"Observador declaró disponibilidad para el 10/09; periodo previo sin marea ni licencia cargada"*).
* **Tratamiento en Presentismo:** No inventa días de licencia contable de forma ciega; requiere confirmación o se mantiene en espera de la nota GDE/franco formal.

---

### Escenario 2: Adelanto de Disponibilidad, Francos Devengados y Descanso Consensuado

**Situación:** El observador registra en el sistema francos o no disponibilidad hasta el **15 de agosto**. Luego envía un correo informando que a partir del **8 de agosto** ya se encuentra disponible.

* **Naturaleza de los Francos y Descanso en INIDEP:**
  * **No Obligatoriedad de Goce Inmediato:** Los francos se devengan por días navegados, pero **no es obligatorio tomarlos inmediatamente** al desembarcar; se van acumulando en un "saldo de francos devengados" para cuando el observador decida usarlos.
  * **Descanso Consensuado:** No existe un periodo de descanso legal forzoso u obligatorio predeterminado por sistema. El período entre mareas es acordado y **consensuado mutuamente** entre el observador y los responsables de la planificación.
* **Estrategia de Solapamiento (Overlap & Adjustment Pattern):**
  1. **Ingreso y Detección de Conflicto:** La novedad `DISPONIBLE` leída por IA ingresa como `PENDIENTE`. El sistema detecta el solapamiento con los francos/indisponibilidad hasta el `15/08`.
  2. **Evaluación según Tipo de Novedad:**
     * **Si la novedad previa era INFORMAL:** Al aprobar la nueva disponibilidad desde el `08/08`, el sistema puede ajustar la fecha de fin de la novedad previa al `07/08`.
     * **Si la novedad previa era FORMAL (Francos Aprobados por Disposición / Licencia GDE):** El sistema exige confirmación explícita en UI al coordinador para recortar los francos.
  3. **Visualización de Saldo:** El sistema muestra en pantalla el saldo actualizado de francos devengados acumulados del observador para respaldar la toma de decisión consensuada.

---

### Escenario 3: Interrupción de Disponibilidad por Imprevisto (Fraccionamiento de Ventanas)

**Situación:** El observador había informado disponibilidad a partir del **10 de agosto**. Posteriormente, envía un email indicando un imprevisto que le exige estar en tierra entre el **15 y el 25 de agosto**.

* **Estrategia: Registro Aditivo y Fraccionamiento Dinámico (Time-Window Splitting):**
  1. **Ingreso en Estado `PENDIENTE`:** La IA extrae la novedad `NO_DISPONIBLE` / `IMPREVISTO` del `15/08` al `25/08`.
  2. **Aprobación y Cálculo de Ventanas Operativas (Planificación):**
     Al ser aprobada por el coordinador, el motor de Planificación deduce dinámicamente tres tramos:
     * **Ventana 1 (Disponible):** Del `10/08` al `14/08` (Apto para mareas cortas o tareas en puerto local).
     * **Tramo Bloqueado (Indisponible):** Del `15/08` al `25/08`.
     * **Ventana 2 (Disponible nuevamente):** A partir del `26/08`.
  3. **Actualización de Ficha:** La `fechaProximaDisponibilidad` del observador se recalcula automáticamente al **`26/08`**.
  4. **Alertas de Conflicto de Asignación:**
     Si el observador ya formaba parte de una Marea planificada o designada entre el `15/08` y el `25/08`, el sistema dispara una alerta crítica e inmediata al coordinador de mareas:  
     ⚠️ *"El observador X agendó una indisponibilidad del 15/08 al 25/08 y posee asignación activa en la Marea N° YY (Zarpada estimada: 18/08)."*

---

## 5. Escenarios Operativos Adicionales y Casos de Borde

### Escenario 4: Impedimentos Administrativos Institucionales vs. Indisponibilidad Voluntaria
* **Situación:** Un observador con un impedimento administrativo registrado (ej. sanción disciplinaria, falta de curso de seguridad náutica PNA vencido, examen médico psicofísico no apto) envía un correo declarando *"estoy disponible para embarcar a partir de mañana"*.
* **Regla de Negocio:** **Precedencia Jerárquica Absoluta de Impedimentos Administrativos.**
  * El sistema debe diferenciar claramente el origen de la no disponibilidad:
    * `INDISPONIBILIDAD_VOLUNTARIA`: Declarada por el observador (vacaciones, trámites, avisos informales).
    * `IMPEDIMENTO_ADMINISTRATIVO`: Decisión institucional/coordinación (sanciones, cursos PNA, apto médico).
  * **Regla de Jerarquía:** Los Impedimentos Administrativos tienen **precedencia absoluta**. Aunque la IA procese y el usuario apruebe un correo de disponibilidad enviado por el observador, el Módulo de Planificación mantendrá al observador como **NO ELEGIBLE** mientras el impedimento administrativo no sea dado de baja o levantado formalmente por la autoridad correspondiente.

### Escenario 5: Solapamiento con Marea Real en Navegación (Arribo Demorado)
* **Situación:** El observador tenía fecha estimada de arribo el 15/08 y una disponibilidad/licencia planificada para el 18/08. Sin embargo, el buque sufre demoras operativas o de mal tiempo y el arribo real se posterga al 22/08.
* **Regla de Negocio:** **Prevalencia Absoluta de la Realidad Física de Navegación.** Mientras la etapa de marea figure en estado `EN_NAVEGACION`, invalida automáticamente cualquier ventana de disponibilidad o novedad planificada para esas fechas, emitiendo una alerta de postergación en la planificación.

### Escenario 6: Ambigüedad de Fechas en Lenguaje Natural (Incertidumbre de IA)
* **Situación:** El observador envía un mensaje con lenguaje coloquial (*"vuelvo el lunes que viene"*, *"estoy libre después del feriado"*).
* **Regla de Negocio:** **Flag de Certeza (`certezaFecha = 'APROXIMADA'`).** En la Planificación de Embarques, la disponibilidad se grafica como una **Ventana Tentativa / Pendiente de Confirmación** (rango en color tramado) hasta que el observador o el coordinador precisen las fechas ISO exactas.

### Escenario 7: Secuenciamiento de Correos Cercanos (`sentAt`)
* **Situación:** El observador envía un correo a las 10:00 indicando indisponibilidad y a las 14:00 envía otro rectificando que se solucionó su problema y está disponible.
* **Regla de Negocio:** **Ordenamiento por Timestamp de Envío (`sentAt`).** El procesador de IA ordena las novedades de la bandeja de entrada según la fecha y hora de emisión del mensaje original, garantizando que el correo más reciente rectifique o reemplace al anterior.

### Escenario 8: Disponibilidad Condicionada o Parcial (Filtros Operativos)
* **Situación:** El observador indica: *"Disponible a partir del 10/08 solo para mareas cortas en buques fresqueros de Mar del Plata; no puedo viajar a la Patagonia hasta septiembre"*.
* **Regla de Negocio:** **Atributos de Restricción Operativa.** La IA extrae parámetros opcionales (`puertoPermitido`, `tipoBuquePermitido`, `diasMaximosEstimados`). En Planificación, el observador figura como **"Disponible con Restricciones Operativas"**, filtrándose automáticamente según el buque y puerto de la marea a cubrir.

---

## 6. Matriz Resumen de Dominio y Jerarquía

| Tipo de Novedad / Origen | Clasificación / Origen | Impacto en Presentismo | Impacto en Planificación | Regla de Precedencia y Conflicto |
| :--- | :--- | :--- | :--- | :--- |
| **Impedimento Administrativo** | **Institucional / Rígido** | Registro administrativo. | **Inhabilita al observador.** | **Precedencia Máxima.** Ningún mail del observador anula este estado. |
| **Marea en Navegación Real** | **Operativo Real** | Computa días embarcado. | **Inhabilita al observador.** | Prevalece sobre cualquier disponibilidad o fecha estimada. |
| **Licencia GDE / Médica** | **Formal (`es_formal=true`)** | Computa falta justificada. | Bloquea disponibilidad. | Prevalece sobre avisos informales por correo. |
| **Francos Acumulados** | **Formal (`es_formal=true`)** | Computa días devengados. | Informa saldo disponible. | Goce no obligatorio inmediato; descanso consensuado. |
| **Email Disp. / Imprevisto (IA)** | **Informal (`es_formal=false`)** | Requiere aprobación manual. | Ajusta ventanas operativas. | Ingresa como `PENDIENTE`. Modifica disponibilidad tras validación. |

---

## 7. Próximos Pasos (Roadmap de Implementación Futura)

1. **Ampliación de Esquema Prisma:** Incorporar atributos en `tipo_novedad` (`esFormal: Boolean`, `categoria: Enum`) y en `observador` (`impedimentoAdministrativo: Boolean`, `motivoImpedimento: String`).
2. **Refactorización de NovedadesAiProcessor:** Garantizar la asignación del estado `PENDIENTE` en toda ingesta por IA y extraer atributos de certeza y restricciones.
3. **Motor de Ventanas de Disponibilidad (Planning Engine):** Desarrollar el cálculo dinámico de ventanas operativas que consulte saldos de francos, impedimentos administrativos y prioridades de solapamiento.
4. **Pantalla de Auditoría y Triage (UI Vue 3):** Diseñar la interfaz de aprobación manual donde el coordinador visualice los correos extraídos, apruebe o rechace novedades y resuelva solapamientos de fechas.
