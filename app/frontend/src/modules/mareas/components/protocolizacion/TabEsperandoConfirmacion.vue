<template>
  <div class="space-y-6">
    
    <div class="flex flex-col xl:flex-row xl:items-center justify-between gap-4 mb-4">
      <div>
        <h2 class="text-sm font-black uppercase tracking-widest text-text">Mareas Enviadas a Protocolizar</h2>
        <p class="text-xs text-text-muted">Aguardando la confirmación de fecha, número y año por parte de la autoridad.</p>
      </div>
      <div class="flex flex-col md:flex-row flex-wrap md:items-center gap-4">
        <!-- Filtros por Año -->
        <div class="flex flex-wrap items-center gap-3">
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">
            Filtrar por año de origen:
          </span>
          <div class="flex flex-wrap items-center gap-2">
            <button 
                @click="showOlderYears = !showOlderYears"
                class="flex items-center gap-2 px-4 py-2 rounded-full border transition-all duration-300 active:scale-95 group relative overflow-hidden"
                :class="!showOlderYears ? 'bg-surface-muted/30 border-border text-text-muted/60' : 'bg-surface shadow-sm hover:shadow-md border-primary/30'"
            >
                <div class="w-1.5 h-1.5 rounded-full transition-all duration-300" :class="!showOlderYears ? 'bg-border' : 'bg-primary'"></div>
                <span class="text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-colors" :class="!showOlderYears ? 'text-text-muted/60' : 'text-text'">
                    Otros años anteriores
                </span>
            </button>
            <button 
                @click="showPreviousYear = !showPreviousYear"
                class="flex items-center gap-2 px-4 py-2 rounded-full border transition-all duration-300 active:scale-95 group relative overflow-hidden"
                :class="!showPreviousYear ? 'bg-surface-muted/30 border-border text-text-muted/60' : 'bg-surface shadow-sm hover:shadow-md border-primary/30'"
            >
                <div class="w-1.5 h-1.5 rounded-full transition-all duration-300" :class="!showPreviousYear ? 'bg-border' : 'bg-primary'"></div>
                <span class="text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-colors" :class="!showPreviousYear ? 'text-text-muted/60' : 'text-text'">
                    Año anterior
                </span>
            </button>
            <button 
                @click="showCurrentYear = !showCurrentYear"
                class="flex items-center gap-2 px-4 py-2 rounded-full border transition-all duration-300 active:scale-95 group relative overflow-hidden"
                :class="!showCurrentYear ? 'bg-surface-muted/30 border-border text-text-muted/60' : 'bg-surface shadow-sm hover:shadow-md border-primary/30'"
            >
                <div class="w-1.5 h-1.5 rounded-full transition-all duration-300" :class="!showCurrentYear ? 'bg-border' : 'bg-primary'"></div>
                <span class="text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-colors" :class="!showCurrentYear ? 'text-text-muted/60' : 'text-text'">
                    Año actual
                </span>
            </button>
          </div>
        </div>
        <SearchInput v-model="searchQuery" class="w-full md:w-64" placeholder="Buscar marea, buque, observador..." />
      </div>
    </div>

    <!-- Data Table / Grid -->
    <div v-if="filteredAndSortedMareas.length > 0">
      <!-- VISTA MÓVIL: TARJETAS COMPACTAS -->
      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3 xl:hidden">
        <div 
          v-for="marea in filteredAndSortedMareas" 
        :key="marea.id"
        class="border rounded-2xl p-5 shadow-sm space-y-4 hover:shadow-md transition-all"
        :class="isOlderYear(marea) ? 'bg-red-50/50 border-red-200/50 dark:bg-red-900/10 dark:border-red-700/30' : isPreviousYear(marea) ? 'bg-amber-50/50 border-amber-200/50 dark:bg-amber-900/10 dark:border-amber-700/30' : 'bg-surface border-border'"
      >
        <div class="flex flex-col h-full">
          <!-- Top Row -->
          <div class="flex justify-between items-start mb-3">
            <span class="text-xs font-mono font-black text-text border border-border bg-surface-muted px-2.5 py-1 rounded-lg tracking-widest shadow-sm">
              {{ formatMareaCode(marea) }}
            </span>
          </div>

          <!-- Main Info -->
          <div class="mb-3 flex-1">
            <div class="flex items-center gap-2 mb-1">
              <ShipIcon class="w-3.5 h-3.5 text-primary shrink-0" />
              <h4 class="text-sm font-black text-text">{{ marea.buque?.nombreBuque || marea.buque_nombre }}</h4>
            </div>
            <div class="flex flex-col gap-0.5 ml-5">
              <p class="text-[10px] font-black text-text-muted uppercase tracking-tight">
                {{ marea.pesqueria?.nombre || 'General' }}
              </p>
              <p class="text-[9px] font-bold text-text-muted/70 italic leading-none">
                {{ marea.buque?.tipoFlota?.nombre || marea.buque?.tipoBuque || 'Flota desconocida' }}
              </p>
            </div>
            <p class="text-xs font-bold text-text-muted truncate mt-1 ml-5">
              {{ marea.observadorPrincipal ? (marea.observadorPrincipal.nombre + ' ' + marea.observadorPrincipal.apellido) : (marea.observador || 'Sin Observador') }}
            </p>
          </div>

          <!-- Divider -->
          <div class="my-4 border-t border-border/50"></div>

          <!-- Footer (Button) -->
          <button 
            @click="openModal(marea)"
            class="flex items-center justify-center gap-2 w-full py-2 bg-primary text-primary-fg rounded-xl text-[10px] font-black uppercase tracking-widest shadow-md shadow-primary/10 hover:opacity-90 transition-all"
          >
            Confirmar Datos
          </button>
        </div>
      </div>
      </div>
      
      <!-- Totales (Mobile) -->
      <div class="mt-4 p-4 bg-surface-muted border border-border rounded-xl text-center shadow-sm xl:hidden">
        <span class="text-[11px] font-black uppercase tracking-widest text-text-muted">
          Total Mareas: <span class="text-text">{{ filteredAndSortedMareas.length }}</span>
        </span>
      </div>

      <!-- VISTA ESCRITORIO: TABLA -->
      <div class="hidden xl:block overflow-x-auto bg-surface border border-border rounded-2xl shadow-sm mt-4">
        <table class="w-full text-left">
          <thead class="bg-surface-muted/50 text-[10px] font-black uppercase tracking-widest text-text-muted border-b border-border">
            <tr>
              <th @click="toggleSort('marea')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Marea
                  <ChevronDownIcon v-if="sortBy === 'marea'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th @click="toggleSort('buque')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Buque
                  <ChevronDownIcon v-if="sortBy === 'buque'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th @click="toggleSort('pesqueria')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Pesquería / Flota
                  <ChevronDownIcon v-if="sortBy === 'pesqueria'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th @click="toggleSort('observador')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Observador
                  <ChevronDownIcon v-if="sortBy === 'observador'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th class="px-5 py-3 text-center">Acción</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr 
              v-for="marea in filteredAndSortedMareas" 
              :key="marea.id" 
              class="group transition-all"
              :class="isOlderYear(marea) ? 'bg-red-50/50 dark:bg-red-900/10 hover:bg-red-100/50 dark:hover:bg-red-900/20' : isPreviousYear(marea) ? 'bg-amber-50/50 dark:bg-amber-900/10 hover:bg-amber-100/50 dark:hover:bg-amber-900/20' : 'odd:bg-surface-muted/30 hover:bg-primary/5'"
            >
              <td class="px-5 py-3">
                <span class="text-[11px] font-mono font-bold text-text-muted uppercase leading-none">{{ formatMareaCode(marea) }}</span>
              </td>
              <td class="px-5 py-3">
                <div class="flex items-center gap-2.5">
                  <div class="w-7 h-7 rounded-lg bg-surface-muted flex items-center justify-center text-text-muted group-hover:bg-primary/10 group-hover:text-primary transition-colors shrink-0">
                    <ShipIcon class="w-3.5 h-3.5" />
                  </div>
                  <span class="text-sm font-bold text-text leading-tight truncate">{{ marea.buque?.nombreBuque || marea.buque_nombre }}</span>
                </div>
              </td>
              <td class="px-5 py-3">
                <div class="flex flex-col">
                  <span class="text-[11px] font-black text-text-muted uppercase tracking-tight leading-tight">
                    {{ marea.pesqueria?.nombre || 'General' }}
                  </span>
                  <span class="text-[9px] font-bold text-primary/70 italic leading-none mt-0.5">
                    {{ marea.buque?.tipoFlota?.nombre || marea.buque?.tipoBuque || 'Flota desconocida' }}
                  </span>
                </div>
              </td>
              <td class="px-5 py-3">
                <span class="text-xs font-bold text-text-muted truncate">{{ marea.observadorPrincipal ? (marea.observadorPrincipal.nombre + ' ' + marea.observadorPrincipal.apellido) : (marea.observador || 'Sin Observador') }}</span>
              </td>
              <td class="px-5 py-3 text-center">
                <button 
                  @click="openModal(marea)"
                  class="inline-flex items-center justify-center gap-2 px-4 py-1.5 bg-primary text-primary-fg rounded-xl text-[10px] font-black uppercase tracking-widest shadow-sm shadow-primary/10 hover:opacity-90 transition-all"
                >
                  Confirmar Datos
                </button>
              </td>
            </tr>
          </tbody>
          <tfoot class="bg-surface-muted/30 border-t border-border">
            <tr>
              <td colspan="5" class="px-5 py-3 text-[11px] font-black uppercase tracking-widest text-text-muted text-right">
                Total Mareas: <span class="text-text">{{ filteredAndSortedMareas.length }}</span>
              </td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else class="text-center py-20 bg-surface border border-dashed border-border rounded-2xl">
      <div class="w-16 h-16 rounded-full bg-surface-muted border border-border flex items-center justify-center mx-auto mb-4">
         <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-text-muted" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M22 12h-4l-3 9L9 3l-3 9H2" />
         </svg>
      </div>
      <h3 class="text-sm font-black text-text uppercase tracking-widest">No hay mareas para mostrar</h3>
      <p class="text-xs text-text-muted max-w-sm mx-auto mt-2">No se encontraron resultados que coincidan con la búsqueda, o no hay mareas esperando confirmación.</p>
    </div>

    <!-- Confirm Modal -->
    <ModalConfirmarProtocolizacion 
      :show="showModal"
      :marea="selectedMarea"
      @close="closeModal"
      @confirmed="onConfirmed"
    />

  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import ModalConfirmarProtocolizacion from './ModalConfirmarProtocolizacion.vue'
import mareasService from '../../services/mareas.service'
import { toast } from 'vue-sonner'
import { ShipIcon, ChevronDownIcon } from '@/icons'
import SearchInput from '@/components/ui/SearchInput.vue'
import { useConfigStore } from '@/modules/shared/stores/config.store'

const configStore = useConfigStore()
const showOlderYears = ref(false)
const showPreviousYear = ref(true)
const showCurrentYear = ref(true)

const props = defineProps<{
  mareas: any[]
}>()

const emit = defineEmits(['refresh', 'update:count'])

const showModal = ref(false)
const selectedMarea = ref<any>(null)
const searchQuery = ref('')
const sortBy = ref('marea')
const sortOrder = ref<'asc'|'desc'>('desc')

import { watch } from 'vue'

const toggleSort = (key: string) => {
  if (sortBy.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = key
    sortOrder.value = 'asc'
  }
}

const isPreviousYear = (marea: any) => {
  const anio = Number(marea.anio_marea || marea.anioMarea || 0)
  return anio === configStore.selectedYear - 1
}

const isOlderYear = (marea: any) => {
  const anio = Number(marea.anio_marea || marea.anioMarea || 0)
  return anio > 0 && anio < configStore.selectedYear - 1
}

const filteredAndSortedMareas = computed(() => {
  let list = [...props.mareas]

  list = list.filter(m => {
    const anio = Number(m.anio_marea || m.anioMarea || 0)
    if (anio === configStore.selectedYear && !showCurrentYear.value) return false
    if (anio === configStore.selectedYear - 1 && !showPreviousYear.value) return false
    if (anio > 0 && anio < configStore.selectedYear - 1 && !showOlderYears.value) return false
    return true
  })

  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(m => {
      const code = formatMareaCode(m).toLowerCase()
      const buque = (m.buque?.nombreBuque || m.buque_nombre || '').toLowerCase()
      const obs = (m.observadorPrincipal ? (m.observadorPrincipal.nombre + ' ' + m.observadorPrincipal.apellido) : (m.observador || '')).toLowerCase()
      const pesqueria = (m.pesqueria?.nombre || '').toLowerCase()
      return code.includes(q) || buque.includes(q) || obs.includes(q) || pesqueria.includes(q)
    })
  }

  return list.sort((a, b) => {
    let valA: any = ''
    let valB: any = ''

    if (sortBy.value === 'marea') {
      const anioA = a.anio_marea || a.anioMarea || 0
      const anioB = b.anio_marea || b.anioMarea || 0
      if (anioA !== anioB) return (anioA - anioB) * (sortOrder.value === 'asc' ? 1 : -1)
      valA = a.nro_marea || a.nroMarea || 0
      valB = b.nro_marea || b.nroMarea || 0
    } else if (sortBy.value === 'buque') {
      valA = (a.buque?.nombreBuque || a.buque_nombre || '').toLowerCase()
      valB = (b.buque?.nombreBuque || b.buque_nombre || '').toLowerCase()
    } else if (sortBy.value === 'pesqueria') {
      valA = (a.pesqueria?.nombre || '').toLowerCase()
      valB = (b.pesqueria?.nombre || '').toLowerCase()
    } else if (sortBy.value === 'observador') {
      valA = (a.observadorPrincipal ? (a.observadorPrincipal.nombre + ' ' + a.observadorPrincipal.apellido) : (a.observador || '')).toLowerCase()
      valB = (b.observadorPrincipal ? (b.observadorPrincipal.nombre + ' ' + b.observadorPrincipal.apellido) : (b.observador || '')).toLowerCase()
    }

    if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1
    if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1
    return 0
  })
})

watch(() => filteredAndSortedMareas.value.length, (newVal) => {
  emit('update:count', newVal)
}, { immediate: true })

const openModal = (marea: any) => {
  selectedMarea.value = marea
  showModal.value = true
}

const formatMareaCode = (marea: any) => {
  const tipo = marea.tipo_marea || marea.tipoMarea || 'MC'
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = (marea.anio_marea || marea.anioMarea || 2026).toString().slice(-2)
  return `${tipo}-${nro}-${anio}`
}

const closeModal = () => {
  showModal.value = false
  selectedMarea.value = null
}

const onConfirmed = () => {
  closeModal()
  emit('refresh')
}
</script>
