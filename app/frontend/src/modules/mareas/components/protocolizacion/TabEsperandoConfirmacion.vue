<template>
  <div class="space-y-6">
    
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-4">
      <div>
        <h2 class="text-sm font-black uppercase tracking-widest text-text">Mareas Enviadas a Protocolizar</h2>
        <p class="text-xs text-text-muted">Aguardando la confirmación de fecha, número y año por parte de la autoridad.</p>
      </div>
      <div class="flex items-center gap-4">
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
        class="bg-surface border border-border rounded-2xl p-5 shadow-sm space-y-4 hover:shadow-md transition-shadow"
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
            <tr v-for="marea in filteredAndSortedMareas" :key="marea.id" class="group odd:bg-surface-muted/30 hover:bg-primary/5 transition-all">
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

const props = defineProps<{
  mareas: any[]
}>()

const emit = defineEmits(['refresh'])

const showModal = ref(false)
const selectedMarea = ref<any>(null)
const searchQuery = ref('')
const sortBy = ref('marea')
const sortOrder = ref<'asc'|'desc'>('desc')

const toggleSort = (key: string) => {
  if (sortBy.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = key
    sortOrder.value = 'asc'
  }
}

const filteredAndSortedMareas = computed(() => {
  let list = [...props.mareas]

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
