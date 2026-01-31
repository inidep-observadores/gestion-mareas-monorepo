---
name: test-vue-composable
description: Guía para pruebas unitarias de Vue 3 Composables usando Vitest. Utiliza esta habilidad al escribir pruebas para la lógica de Vue y determinar la estrategia de prueba correcta según si el composable es independiente, depende de ganchos de ciclo de vida (onMounted) o utiliza inyección de dependencias (provide/inject).
---

# Guía de Pruebas de Vue Composables (Vitest)

## 1. Determinar el Tipo de Composable

Analiza el código fuente del composable para determinar la estrategia de prueba:

1.  **Independiente**: Utiliza solo APIs de Reactividad (`ref`, `computed`, `watch`). No utiliza ganchos de ciclo de vida ni `inject`.
2.  **Dependiente (Ciclo de Vida)**: Utiliza ganchos de ciclo de vida (ej., `onMounted`, `onUnmounted`).
3.  **Dependiente (Inyección)**: Utiliza `inject` para recuperar dependencias.

## 2. Seleccionar la Estrategia de Prueba

### A. Composables Independientes
Pruébalos directamente invocando la función y verificando el estado devuelto. No es necesario simular la instancia de Vue.

* **Patrón**: Importar composable -> Llamarlo -> Verificar `result.value`.

### B. Composables Dependientes (Ciclo de Vida)
Requieren un contexto de componente para activar ganchos como `onMounted`. Utiliza la función de ayuda `withSetup`.

1.  **Prerrequisito**: Asegúrate de que exista `test-utils.ts` (o similar) que contenga la función `withSetup`.
2.  **Patrón**: Importar `withSetup` -> Llamar `withSetup(() => useComposable())` -> Desestructurar resultado -> Verificar.

### C. Composables Dependientes (Inyección)
Requieren un contexto de proveedor. Utiliza la función de ayuda `useInjectedSetup`.

1.  **Prerrequisito**: Asegúrate de que `test-utils.ts` contenga la función `useInjectedSetup`.
2.  **Patrón**: Definir arreglo de configuración de inyección -> Llamar `useInjectedSetup` -> Verificar -> **Llamar unmount()**.