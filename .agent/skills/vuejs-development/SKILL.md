---
name: vuejs-development
description: Habilidad integral de desarrollo en Vue.js que cubre la Composition API, el sistema de reactividad, componentes, directivas y patrones modernos de Vue 3 basados en la documentación oficial de Vue.js.
category: frontend
tags: [vue, vuejs, composition-api, reactividad, componentes, directivas, sfc]
version: 1.0.0
---

# Habilidad de Desarrollo en Vue.js

Esta habilidad proporciona una guía completa para construir aplicaciones modernas en Vue.js utilizando la Composition API, el sistema de reactividad, archivos de componente único (SFC), directivas y ganchos (hooks) de ciclo de vida basados en la documentación oficial.

## Cuándo usar esta habilidad

Úsala cuando:
- Construyas aplicaciones de página única (SPAs) con Vue.js.
- Crees interfaces de usuario interactivas con datos reactivos.
- Desarrolles arquitecturas basadas en componentes.
- Implementes formularios, obtención de datos y gestión de estado.
- Optimices el rendimiento de aplicaciones Vue.
- Integres con TypeScript para un desarrollo seguro en tipos.

## Conceptos Core

### Sistema de Reactividad

El sistema de reactividad de Vue es el mecanismo central que rastrea las dependencias y actualiza automáticamente el DOM cuando los datos cambian.

**Estado Reactivo con ref():**
```javascript
import { ref } from 'vue'

const count = ref(0)
console.log(count.value) // 0
count.value++
```

**Objetos Reactivos con reactive():**
```javascript
import { reactive } from 'vue'

const state = reactive({
  name: 'Vue',
  version: 3
})
state.name = 'Vue.js'
```

### Composition API

La Composition API proporciona un conjunto de APIs basadas en funciones para organizar la lógica del componente.

**Componente Básico con <script setup>:**
```vue
<script setup>
import { ref, computed, onMounted } from 'vue'

const props = defineProps({
  title: String
})

const count = ref(0)
const doubled = computed(() => count.value * 2)

onMounted(() => {
  console.log('Componente montado')
})
</script>
```

### Ganchos de Ciclo de Vida

Los ganchos de ciclo de vida te permiten ejecutar código en etapas específicas:
- `onBeforeMount`, `onMounted`
- `onBeforeUpdate`, `onUpdated`
- `onBeforeUnmount`, `onUnmounted`
