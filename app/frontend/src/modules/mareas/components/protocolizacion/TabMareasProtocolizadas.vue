<template>
  <div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-4">
      <div>
        <h2 class="text-sm font-black uppercase tracking-widest text-text">Historial de Mareas Protocolizadas</h2>
        <p class="text-xs text-text-muted">Mareas que han finalizado correctamente su ciclo de protocolización.</p>
      </div>
      <div class="flex items-center gap-4">
        <SearchInput v-model="searchQuery" class="w-full md:w-64" placeholder="Buscar marea, buque, observador..." />
      </div>
    </div>

    <!-- Data Grid -->
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

          <!-- Footer (Protocolización Data) -->
          <div class="flex items-center justify-between">
            <div class="flex flex-col">
              <span class="text-[9px] font-black text-text-muted/60 uppercase tracking-widest">Nro Protocolo</span>
              <span class="text-[11px] font-black text-text">
                {{ marea.nroProtocolizacion || marea.nro_protocolizacion }}-{{ marea.anioProtocolizacion || marea.anio_protocolizacion }}
              </span>
            </div>
            <div class="text-right flex flex-col">
              <span class="text-[9px] font-black text-text-muted/60 uppercase tracking-widest">Efectivizada en</span>
              <span class="text-[10px] font-bold text-primary">
                {{ formatDate(marea.fechaProtocolizacion || marea.fecha_protocolizacion) }}
              </span>
            </div>
          </div>
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
              <th @click="toggleSort('protocolo')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Nro Protocolo
                  <ChevronDownIcon v-if="sortBy === 'protocolo'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
              <th @click="toggleSort('fechaProtocolizacion')" class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                <div class="flex items-center gap-1">
                  Fecha
                  <ChevronDownIcon v-if="sortBy === 'fechaProtocolizacion'" class="w-3 h-3 text-primary transition-transform duration-300" :class="{ 'rotate-180': sortOrder === 'asc' }" />
                </div>
              </th>
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
              <td class="px-5 py-3">
                <span class="text-[11px] font-black text-text">
                  {{ marea.nroProtocolizacion || marea.nro_protocolizacion }}-{{ marea.anioProtocolizacion || marea.anio_protocolizacion }}
                </span>
              </td>
              <td class="px-5 py-3">
                <span class="text-[10px] font-bold text-primary">
                  {{ formatDate(marea.fechaProtocolizacion || marea.fecha_protocolizacion) }}
                </span>
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
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
            <polyline points="22 4 12 14.01 9 11.01" />
         </svg>
      </div>
      <h3 class="text-sm font-black text-text uppercase tracking-widest">No hay mareas para mostrar</h3>
      <p class="text-xs text-text-muted max-w-sm mx-auto mt-2">No se encontraron resultados o las mareas aparecerán aquí una vez que completen el proceso de protocolización.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { ShipIcon, ChevronDownIcon } from '@/icons'
import SearchInput from '@/components/ui/SearchInput.vue'

const props = defineProps<{
  mareas: any[]
}>()

const formatMareaCode = (marea: any) => {
  const tipo = marea.tipo_marea || marea.tipoMarea || 'MC'
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = (marea.anio_marea || marea.anioMarea || 2026).toString().slice(-2)
  return `${tipo}-${nro}-${anio}`
}

const searchQuery = ref('')
const sortBy = ref('fechaProtocolizacion')
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
      const protocolo = `${m.nroProtocolizacion || m.nro_protocolizacion}-${m.anioProtocolizacion || m.anio_protocolizacion}`.toLowerCase()
      return code.includes(q) || buque.includes(q) || obs.includes(q) || pesqueria.includes(q) || protocolo.includes(q)
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
    } else if (sortBy.value === 'protocolo') {
      const nroA = Number(a.nroProtocolizacion || a.nro_protocolizacion || 0)
      const nroB = Number(b.nroProtocolizacion || b.nro_protocolizacion || 0)
      const anioA = Number(a.anioProtocolizacion || a.anio_protocolizacion || 0)
      const anioB = Number(b.anioProtocolizacion || b.anio_protocolizacion || 0)
      if (anioA !== anioB) return (anioA - anioB) * (sortOrder.value === 'asc' ? 1 : -1)
      valA = nroA
      valB = nroB
    } else if (sortBy.value === 'fechaProtocolizacion') {
      valA = new Date(a.fechaProtocolizacion || a.fecha_protocolizacion || 0).getTime()
      valB = new Date(b.fechaProtocolizacion || b.fecha_protocolizacion || 0).getTime()
    }

    if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1
    if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1
    return 0
  })
})

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  return new Date(dateString).toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })
}
</script>
