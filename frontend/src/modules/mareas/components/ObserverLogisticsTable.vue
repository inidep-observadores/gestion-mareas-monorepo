<template>
  <div class="rounded-2xl border border-border bg-surface p-6 shadow-theme-xs h-full flex flex-col">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h2 class="text-sm font-black text-text uppercase tracking-widest flex items-center gap-2">
          <div class="w-1.5 h-4 bg-primary rounded-full"></div>
          Logística y Talento (Observadores)
        </h2>
        <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter mt-1">Monitoreo de disponibilidad y esfuerzo</p>
      </div>
      <div class="text-[10px] font-black text-text-muted uppercase tracking-widest">Últimos 12 meses</div>
    </div>

    <div class="flex-1 overflow-x-auto custom-scrollbar">
      <table class="w-full text-left border-separate border-spacing-y-2">
        <thead>
          <tr class="text-[10px] font-black text-text-muted uppercase tracking-widest">
            <th class="pb-2 pl-4">Observador</th>
            <th class="pb-2">Días Mar Año</th>
            <th class="pb-2">Estado</th>
            <th class="pb-2 pr-4 text-right">En Tierra</th>
          </tr>
        </thead>
        <tbody>
          <tr 
            v-for="obs in observers" 
            :key="obs.id"
            class="group bg-surface-muted hover:bg-surface transition-duration-400 rounded-xl shadow-theme-xs border border-transparent hover:border-border"
          >
            <!-- Observer Info -->
            <td class="py-4 pl-4 rounded-l-xl">
              <div class="flex items-center gap-3">
                 <div
                   class="w-10 h-10 rounded-xl bg-primary/10 flex items-center justify-center text-primary font-black text-xs shadow-sm border border-primary/20"
                 >
                   {{ obs.nombre.split(' ').map((n) => n[0]).join('') }}
                 </div>
                 <div class="text-xs font-black text-text uppercase tracking-wide">
                   {{ obs.nombre }}
                 </div>
              </div>
            </td>

            <!-- Sea Days Progress (Target 180) -->
            <td class="py-4">
               <div class="w-full max-w-35">
                 <div class="flex justify-between text-[10px] font-black uppercase mb-1.5">
                    <span class="text-text">{{ obs.diasMar }}d</span>
                    <span class="text-text-muted">/ {{ diasNavegadosAnuales }} IDEAL</span>
                 </div>
                 <div class="h-2 w-full bg-surface rounded-full overflow-hidden border border-border relative">
                    <div
                      class="h-full transition-all duration-1000 ease-out rounded-full shadow-sm"
                      :class="[obs.diasMar >= diasNavegadosAnuales ? 'bg-warning' : 'bg-primary']"
                      :style="{ width: Math.min((obs.diasMar / diasNavegadosAnualesSafe) * 100, 100) + '%' }"
                    ></div>
                    <!-- Target Marker -->
                    <div class="absolute top-0 right-0 h-full w-px bg-white/30"></div>
                 </div>
               </div>
            </td>

            <!-- Status Tag -->
            <td class="py-4">
              <span
                class="inline-flex items-center px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest border"
                :class="statusStyles[obs.estado]"
              >
                <span class="w-1.5 h-1.5 rounded-full mr-2" :class="statusDotStyles[obs.estado]"></span>
                {{ obs.estado }}
              </span>
            </td>

            <!-- Land Days -->
            <td class="py-4 pr-4 text-right rounded-r-xl">
               <div class="flex flex-col items-end">
                  <span 
                    class="text-xs font-black tabular-nums"
                    :class="obs.diasTierra > diasExcesoTierra ? 'text-warning' : 'text-text'"
                  >
                    {{ obs.diasTierra }} <span class="text-[9px] text-text-muted uppercase font-black">Días</span>
                  </span>
                  <span v-if="obs.diasTierra > diasExcesoTierra" class="text-[8px] font-black text-warning uppercase tracking-tighter">Exceso detectado</span>
               </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- View All Action -->
    <div class="mt-6 pt-4 border-t border-border flex justify-center">
       <button class="flex items-center gap-2 text-[10px] font-black text-primary hover:text-primary/80 uppercase tracking-widest transition-colors group">
          Ver plantilla completa
          <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 transition-transform group-hover:translate-x-1" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
          </svg>
       </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { storeToRefs } from 'pinia'
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'

const businessRulesStore = useBusinessRulesStore()
const { rules } = storeToRefs(businessRulesStore)

const diasNavegadosAnuales = computed(() => rules.value.DIAS_NAVEGADOS_ANUALES || 0)
const diasNavegadosAnualesSafe = computed(() => rules.value.DIAS_NAVEGADOS_ANUALES || 1)
const diasExcesoTierra = computed(() => rules.value.DIAS_EXCESO_TIERRA || 0)

interface Observer {
  id: number
  nombre: string
  diasMar: number
  estado: 'Navegando' | 'Disponible' | 'Licencia'
  diasTierra: number
}

const observers: Observer[] = [
  { id: 1, nombre: 'Juan Pérez', diasMar: 185, estado: 'Navegando', diasTierra: 0 },
  { id: 2, nombre: 'María García', diasMar: 142, estado: 'Disponible', diasTierra: 15 },
  { id: 3, nombre: 'Carlos Rodríguez', diasMar: 175, estado: 'Disponible', diasTierra: 42 },
  { id: 4, nombre: 'Ana López', diasMar: 88, estado: 'Navegando', diasTierra: 0 },
  { id: 5, nombre: 'Roberto Gómez', diasMar: 120, estado: 'Licencia', diasTierra: 10 },
]

const statusStyles = {
  Navegando: 'bg-primary/5 text-primary border-primary/20',
  Disponible: 'bg-success/5 text-success border-success/20',
  Licencia: 'bg-surface text-text-muted border-border',
}

const statusDotStyles = {
  Navegando: 'bg-primary shadow-[0_0_8px_rgba(var(--color-primary-rgb),0.5)] animate-pulse',
  Disponible: 'bg-success shadow-[0_0_8px_rgba(var(--color-success-rgb),0.5)]',
  Licencia: 'bg-text-muted opacity-40',
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
  border-radius: 10px;
}
</style>
