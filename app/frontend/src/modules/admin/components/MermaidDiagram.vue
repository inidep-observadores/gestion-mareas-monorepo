<template>
  <div class="relative w-full overflow-auto">
    <div v-if="isRendering" class="flex items-center justify-center py-16 text-text-muted">
      <span class="w-5 h-5 border-2 border-primary border-t-transparent rounded-full animate-spin mr-3" />
      <span class="text-sm font-medium">Generando diagrama...</span>
    </div>
    <div v-show="!isRendering" ref="svgRef" class="mermaid-output flex justify-center" />
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'

const props = defineProps<{ definition: string }>()

const svgRef = ref<HTMLDivElement | null>(null)
const isRendering = ref(false)
let idCounter = 0

const renderDiagram = async () => {
  if (!svgRef.value || !props.definition.trim()) return
  isRendering.value = true
  svgRef.value.innerHTML = ''
  try {
    const mermaid = (await import('mermaid')).default
    const elkLayouts = (await import('@mermaid-js/layout-elk')).default
    mermaid.registerLayoutLoaders(elkLayouts)
    mermaid.initialize({
      startOnLoad: false,
      theme: 'neutral',
      fontFamily: 'system-ui, sans-serif',
      flowchart: { curve: 'basis', padding: 24, useMaxWidth: true },
    })
    const { svg } = await mermaid.render(`mermaid-${++idCounter}`, props.definition)
    if (svgRef.value) svgRef.value.innerHTML = svg
  } catch (e) {
    console.error('[MermaidDiagram]', e)
    if (svgRef.value) {
      svgRef.value.innerHTML =
        '<p style="color:#ef4444;font-size:12px;padding:1rem">Error al generar el diagrama.</p>'
    }
  } finally {
    isRendering.value = false
  }
}

onMounted(renderDiagram)
watch(() => props.definition, renderDiagram)
</script>
