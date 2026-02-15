---
name: testing-standards
description: Configura una metodología sólida y profesional para el diseño de pruebas unitarias e integración en NestJS y Vue. Prioriza el cumplimiento de reglas de negocio y la cobertura de casos de éxito, error y borde.
category: quality
displayName: Estándares de Testing Profesional
color: green
---

# Estándares de Testing Profesional

Esta habilidad define el marco de trabajo para garantizar que cada componente del sistema (Backend o Frontend) esté respaldado por una suite de pruebas que no solo pase, sino que certifique el cumplimiento de las reglas de negocio.

## Principios Fundamentales

1.  **Diseño Profesional**: Las pruebas son ciudadanos de primera clase. Deben ser legibles, mantenibles y seguir patrones establecidos.
2.  **Triple Cobertura Obligatoria**:
    -   **Casos de Éxito**: Validar que el sistema hace lo que debe hacer cuando los datos son correctos.
    -   **Casos de Error**: Validar que el sistema responde correctamente ante entradas inválidas o fallos de dependencias.
    -   **Casos de Borde (Edge Cases)**: Probar límites (valores nulos, rangos extremos, cambios de día/mes, desbordamientos).
3.  **Prioridad de Lógica de Negocio**: Al solucionar un test fallido, **NUNCA** se debe modificar el test simplemente para que pase si eso implica relajar o ignorar una regla de negocio. El foco es asegurar que el código funcional cumpla con la regla establecida.
4.  **Aislamiento y Mocks**: Las pruebas unitarias deben probar la lógica de la unidad, mockeando todas las dependencias externas para evitar ruidos de infraestructura.

## Metodología por Plataforma

### Backend (NestJS / Jest)
- Se debe usar `jest` con los patrones definidos en el skill `jest-nestjs`.
- Cada servicio crítico debe tener una suite que valide las restricciones de integridad y lógica.
- **Regla de Oro**: Si una prueba de backend falla, verifica primero si la lógica de negocio en el servicio o controlador se ha desviado del requerimiento original.

### Frontend (Vue / Vitest)
- Se debe usar `vitest` con los patrones definidos en el skill `test-vue-composable`.
- Probar composables de forma independiente usando `withSetup` cuando sea necesario.
- Validar la reactividad de las propiedades computadas y los observadores ante cambios de estado.

## Gestión de Pruebas Fallidas

Cuando un test detecta un error durante el desarrollo o corrección:

1.  **NO "TOCAR" EL TEST**: No modifiques los valores esperados (`expect`) a menos que el requerimiento haya cambiado explícitamente.
2.  **Análisis de Regla**: Identifica qué regla de negocio está intentando proteger el test.
3.  **Corrección de Raíz**: Modifica el código de la funcionalidad para que cumpla con la regla y, por consecuencia, el test pase de forma natural.
4.  **Cuidado con las Fechas**: Presta especial atención a los mocks de tiempo (`Settings.now` en Luxon) para evitar que el tiempo real del sistema cause inconsistencias.

## Lista de Verificación de Calidad

- [ ] ¿He cubierto el camino feliz (éxito)?
- [ ] ¿He probado al menos 2 casos de error comunes?
- [ ] ¿He identificado y probado casos de borde (ej. transiciones de fecha, valores vacíos)?
- [ ] ¿Los tests prueban la lógica de negocio y no solo la sintaxis del lenguaje?
- [ ] Al corregir un fallo, ¿he mantenido la integridad de la regla de negocio original?
- [ ] ¿La suite de pruebas es determinística (no depende de factores externos como la hora actual)?

## Relación con otros Skills

- Usa `business-logic-assurance` para descubrir las reglas antes de testear.
- Usa `jest-nestjs` para la implementación técnica en backend.
- Usa `test-vue-composable` para la implementación técnica en frontend.
