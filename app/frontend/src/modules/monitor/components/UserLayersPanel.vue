<template>
  <section class="p-4">
    <div class="flex items-center justify-between mb-3">
      <h3 class="text-[10px] font-black uppercase tracking-widest text-text-muted/60">Capas Importadas</h3>
      <button type="button" @click="fileInput?.click()" :disabled="importing"
        class="px-2.5 py-1 rounded-lg bg-primary/10 text-primary text-[10px] font-black uppercase tracking-wider hover:bg-primary/20 transition-colors disabled:opacity-50">
        + Importar
      </button>
      <input ref="fileInput" type="file" accept=".geojson,.json,application/geo+json,application/json" multiple
        class="hidden" @change="onFilesSelected" />
    </div>

    <p v-if="loaded && !layers.length" class="text-xs text-text-muted/80 leading-relaxed">
      Importe archivos GeoJSON para superponerlos al mapa. Se guardan en este navegador.
    </p>

    <div class="space-y-2">
      <div v-for="layer in layers" :key="layer.id"
        class="flex items-center gap-1.5 p-2 rounded-lg bg-text/5 border transition-all"
        :class="layer.isVisible ? 'border-primary/30' : 'border-border/10'">
        <label class="relative w-2.5 h-8 rounded shrink-0 cursor-pointer overflow-hidden" :style="{ backgroundColor: layer.color }"
          title="Cambiar color">
          <input type="color" :value="layer.color" class="absolute inset-0 opacity-0 cursor-pointer"
            @change="setColor(layer.id, ($event.target as HTMLInputElement).value)" />
        </label>
        <div class="flex-1 min-w-0">
          <div class="text-xs font-bold text-text truncate" :title="layer.name">{{ layer.name }}</div>
          <div class="text-[10px] text-text-muted/70 uppercase font-bold">GeoJSON</div>
        </div>
        <button type="button" @click="toggleDescriptions(layer.id)" class="p-1.5 rounded-lg hover:bg-surface-muted transition-colors"
          :class="layer.showDescriptions ? 'text-primary' : 'text-text-muted/40'"
          :title="layer.showDescriptions ? 'Ocultar descripciones' : 'Mostrar descripciones'">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
          </svg>
        </button>
        <BaseSwitch :modelValue="layer.isVisible" @update:modelValue="toggleVisibility(layer.id)" />
        <button type="button" @click="confirmRemove(layer.id, layer.name)"
          class="p-1.5 rounded-lg text-error hover:bg-error/10 transition-colors" title="Eliminar capa">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor"
            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M3 6h18M8 6V4h8v2M19 6l-1 14H6L5 6M10 11v6M14 11v6" />
          </svg>
        </button>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { toast } from 'vue-sonner'
import BaseSwitch from '@/components/ui/BaseSwitch.vue'
import { useUserMapLayers } from '../composables/useUserMapLayers'

const { layers, loaded, importFile, remove, toggleVisibility, toggleDescriptions, setColor } = useUserMapLayers()

const fileInput = ref<HTMLInputElement | null>(null)
const importing = ref(false)

const onFilesSelected = async (e: Event) => {
  const input = e.target as HTMLInputElement
  const files = Array.from(input.files ?? [])
  input.value = ''
  if (!files.length) return

  importing.value = true
  for (const file of files) {
    try {
      const layer = await importFile(file)
      toast.success(`Capa "${layer.name}" importada`)
    } catch (err) {
      toast.error(`${file.name}: ${err instanceof Error ? err.message : 'No se pudo importar'}`)
    }
  }
  importing.value = false
}

const confirmRemove = async (id: string, name: string) => {
  if (!window.confirm(`¿Eliminar la capa "${name}"? Se borrará de este navegador.`)) return
  try {
    await remove(id)
  } catch {
    toast.error('No se pudo eliminar la capa')
  }
}
</script>
