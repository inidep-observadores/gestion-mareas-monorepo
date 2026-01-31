# Introducción

Este documento resume todas las definiciones conceptuales, decisiones arquitectónicas y criterios de modelado adoptados durante la sesión de trabajo. No se incluyen los pseudocódigos de las tablas, ya que fueron registrados aparte; aquí se detallan **las razones, enfoques y lineamientos** que fundamentan el diseño general del sistema.

## 1\. Definición y organización de roles

Se definieron cuatro roles principales dentro del sistema:

*   **Asistente Administrativo**: rol de base. Puede cargar nuevas mareas, registrar novedades operativas, actualizar datos administrativos y adjuntar documentación. No realiza análisis técnico ni correcciones de datos.
    
*   **Técnico de Datos**: rol operativo encargado de verificar y corregir los datos de marea, procesar archivos, abrir y cerrar sesiones de corrección, y avanzar las mareas dentro de su flujo técnico.
    
*   **Coordinador**: rol con capacidad de supervisión y control. Puede aprobar informes, gestionar delegaciones externas, destrabar situaciones (liberar mareas bloqueadas), reasignar responsables y validar transiciones complejas.
    
*   **Administrador**: tiene acceso completo a la configuración, catálogos, usuarios, y puede intervenir en cualquier etapa del flujo. Se reserva para tareas especiales, mantenimiento y soporte.
    

Se descartó el rol &quot;Observador&quot; dentro del sistema web, ya que el observador no interactúa directamente con esta plataforma. Su información sí se almacena en catálogos y relaciones.

## 2\. Catálogos estructurales del sistema

Se definieron los principales catálogos necesarios para la operación:

*   **Buques**: incluye información operativa y administrativa, incorporando tipo de flota, arte de pesca habitual y pesquería habitual.
    
*   **Artes de pesca** y **Tipos de flota**: catálogos simples, estables y poco cambiantes.
    
*   **Pesquerías**: catálogo flexible, con identificación clara, nombre oficial, descripción y grupo biológico. El grupo (Peces, Crustáceos, Moluscos, etc.) se maneja mediante constantes que no requieren tabla adicional.
    
*   **Puertos**: para registrar puertos de zarpe y arribo de cada etapa.
    
*   **Observadores**: catálogo enriquecido con DNI, datos de contacto, foto opcional, clasificación como Observador profesional o Técnico embarcado, y pesquerías habituales (array). También se diseñó una **bitácora de observador** para registrar observaciones relevantes sobre su desempeño o situaciones personales.
    

## 3\. Modelado del flujo de mareas

### 3.1 Enfoque basado en estados

Los estados de marea se organizan en un catálogo estructurado con:

*   Código
    
*   Nombre visible
    
*   Categoría general (Pendiente, En curso, Completado, Cancelado)
    
*   Orden dentro del flujo
    
*   Flags de control (permite carga de archivos, permite corrección, permite informe)
    
*   Indicadores de estado inicial y estado final
    

Se definió una lista ordenada y refinada de estados que representa fielmente el flujo institucional, incluyendo:

*   Designada
    
*   En ejecución
    
*   Esperando entrega
    
*   Recibida
    
*   Verificación inicial
    
*   Corrección interna
    
*   Delegada externa
    
*   Pendiente de informe
    
*   Esperando revisión
    
*   Para protocolizar
    
*   Esperando protocolización
    
*   Protocolizada
    
*   Cancelada
    

### 3.2 Eliminación del estado redundante

Se tomó la decisión de **no almacenar el estado actual dentro de la tabla** `**mareas**`. En su lugar, el estado se deriva **siempre del último movimiento registrado de tipo** `**CAMBIO_ESTADO**`. Esto evita inconsistencias, elimina duplicación y permite reconstruir la historia completa de cambios.

## 4\. Diseño de la tabla `mareas` y sus relaciones

### 4.1 Principios adoptados

*   La tabla `mareas` se limita a **información estable, global y no repetitiva**.
    
*   Todo lo que ocurre en momentos específicos (recepción de datos, escaneo, delegación, correcciones, entregas de otolitos, cambios de responsable, etc.) se registra como **evento**.
    
*   Fechas reales de zarpada y arribo no residen en la tabla principal, sino en una tabla subordinada de **etapas**.
    

### 4.2 Múltiples observadores

Se definió que una marea puede tener más de un observador (titular, suplente, reemplazos, técnicos embarcados). Por lo tanto, se crea la tabla `mareas_observadores`, con capacidad para registrar intervalos temporales.

### 4.3 Etapas de marea

Se estableció que una marea puede tener varias etapas, cada una con:

*   Puerto de zarpada
    
*   Puerto de arribo
    
*   Fecha (real) de zarpada
    
*   Fecha (real) de arribo
    

La **fecha estimada de zarpada**, al ser única y existir sólo al inicio, se almacena en la tabla principal.

## 5\. Registro de eventos (bitácora de marea)

Se creó el concepto de `**mareas_movimientos**` como bitácora oficial de toda acción o hito relevante.

Este registro incluye:

*   Cambios de estado
    
*   Recepción de datos originales
    
*   Carga de datos corregidos
    
*   Delegaciones y retornos externos
    
*   Escaneo de carpeta
    
*   Entrega de otolitos (con cantidad)
    
*   Asignación y cambio de responsable
    
*   Generación y revisión de informes
    
*   Notas técnicas y administrativas
    
*   Cualquier contacto con observador o empresa
    

Cada movimiento tiene:

*   Fecha y hora
    
*   Usuario responsable
    
*   Tipo de evento
    
*   Estado desde/hasta (si aplica)
    
*   Campos específicos opcionales (como cantidad de otolitos)
    

El sistema puede derivar en cualquier momento:

*   El estado actual de la marea
    
*   El historial completo de transiciones
    
*   La trazabilidad de responsables
    
*   La secuencia completa del ciclo de vida
    

## 6\. Gestión de archivos asociados a una marea

Se definió un modelo flexible donde:

*   **Todos los archivos pertenecen siempre a una marea**.
    
*   Opcionalmente, un archivo puede asociarse a un **evento específico**.
    

Esto permite:

*   localizar rápidamente todos los archivos de una marea,
    
*   saber en qué contexto se subió cada uno,
    
*   vincular PDFs de carpeta escaneada, datos originales, datos corregidos, informes, anexos y materiales varios.
    

Se establece una categorización explícita de tipos de archivo:

*   Datos originales del observador
    
*   Datos corregidos internos
    
*   Datos corregidos externos
    
*   Carpeta escaneada
    
*   Documentación adicional
    
*   Informes (borrador, final, protocolizado)
    
*   Anexos de informe
    
*   Material de referencia
    

Asimismo, se definen versiones (`ORIGINAL`, `CORREGIDO`, `FINAL`, etc.) y formatos libres.

## 7\. Sesiones de corrección

Si bien aún no se detalló completamente, se acordó conceptualmente que:

*   La corrección de datos debe registrarse como **sesión**, con apertura y cierre registrados mediante eventos.
    
*   Las responsabilidades de corrección se asignan mediante eventos específicos.
    
*   Los archivos corregidos se vinculan tanto a la marea como al movimiento correspondiente.
    

Este enfoque garantiza organización y trazabilidad en el proceso de control de calidad de los datos.

## 8\. Conclusiones principales

*   La arquitectura se basa en **entidades puras** (mareas, etapas, observadores, buques) complementadas por **bitácoras de eventos** que capturan todo lo dinámico.
    
*   Se prioriza evitar la redundancia y asegurar coherencia mediante cálculos derivados (por ejemplo, el estado actual).
    
*   Los roles y permisos acompañan fielmente las responsabilidades reales del flujo institucional.
    
*   La estructura de catálogos permite adaptarse al tiempo, con campos opcionales y espacio para crecimiento.
    
*   El registro minucioso de eventos y archivos convierte al sistema en una herramienta poderosa de trazabilidad, auditoría y reconstrucción histórica.
    

Este diseño deja sentadas las bases para un backend robusto, un frontend claro y un modelado de datos escalable para los próximos años.