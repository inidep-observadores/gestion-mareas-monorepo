---
name: business-logic-assurance
description: Garantiza la comprensión profunda de requerimientos y reglas de negocio, y la implementación automática de pruebas unitarias con alta cobertura para validar cada funcionalidad desarrollada.
category: quality
displayName: Aseguramiento de Reglas de Negocio y Calidad
color: blue
---

# Aseguramiento de Reglas de Negocio y Calidad

Esta habilidad obliga al agente a priorizar la claridad conceptual y la robustez técnica mediante pruebas automáticas antes de considerar terminada cualquier funcionalidad.

## Requerimiento de Activación

Esta habilidad DEBE activarse al inicio de cada nueva solicitud de funcionalidad o modificación de lógica existente.

## Fase 1: Comprensión y Descubrimiento (SIN CÓDIGO TODAVÍA)

Antes de escribir una sola línea de código funcional, el agente debe:

1.  **Analizar el Contexto**: Buscar en el código existente, esquemas de base de datos y documentación técnica relacionada.
2.  **Identificar Reglas de Negocio**: Listar explícitamente las reglas de negocio, validaciones y casos de borde detectados.
3.  **Clarificación de Dudas**: Si algún requerimiento es ambiguo o falta información sobre un caso de borde, DEBE preguntar al usuario mediante `notify_user` antes de proceder.
4.  **Documentar en el Plan**: Incluir una sección de "Reglas de Negocio" en `implementation_plan.md`.

## Fase 2: Instrumentación de Pruebas Unitarias

Una vez comprendido el requerimiento, la implementación debe seguir estos pasos:

1.  **Esqueleto de Pruebas**: Crear o actualizar el archivo de pruebas (`.spec.ts`) con una suite que cubra:
    -   El flujo exitoso ("happy path").
    -   Todas las validaciones y errores esperados.
    -   Casos de borde (edge cases).
2.  **Mocking de Dependencias**: Utilizar mocks para servicios externos, repositorios o APIs, asegurando que la prueba se centre únicamente en la unidad de lógica de negocio.
3.  **Cobertura**: Se debe aspirar a una cobertura de líneas y ramas superior al 80% en la lógica modificada.

## Fase 3: Validación y Refinamiento

1.  **Ejecución de Pruebas**: Ejecutar las pruebas y verificar que pasen.
2.  **Verificación de Reglas**: Confirmar que cada regla de negocio listada en la Fase 1 tenga al menos una prueba que la valide.

## Lista de Verificación Obligatoria

- [ ] ¿He listado todas las reglas de negocio involucradas?
- [ ] ¿He preguntado al usuario si hay dudas sobre algún comportamiento esperado?
- [ ] ¿He creado pruebas para los casos de éxito, error y borde?
- [ ] ¿Los tests pasan satisfactoriamente?
- [ ] ¿La cobertura es adecuada para la importancia de la funcionalidad?

## Cuándo NO usar:

- En refactorizaciones puras de infraestructura que no cambian la lógica.
- En correcciones de UI/CSS menores que no afectan el flujo de datos.
- En actualizaciones de dependencias sin cambios funcionales.
