<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest flex items-center gap-2">
          <div class="w-1.5 h-4 bg-emerald-500 rounded-full"></div>
          Monitor de Eficiencia (SLA)
        </h2>
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter mt-1">Cumplimiento de objetivos institucionales</p>
      </div>
      <div class="flex gap-2">
         <div class="px-3 py-1 bg-emerald-50 dark:bg-emerald-900/20 rounded-full border border-emerald-100 dark:border-emerald-800/50">
            <span class="text-[10px] font-black text-emerald-600 dark:text-emerald-400 uppercase">92% Global</span>
         </div>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 flex-1">
      <!-- Indices de Entrega -->
      <div class="space-y-6">
        <div class="flex items-center justify-between">
           <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Entrega de Datos</h3>
           <span class="text-[10px] font-bold text-gray-400 uppercase italic">Meta: &lt; {{ plazoEntregaDatos }} días</span>
        </div>
        
        <div class="space-y-4">
           <div v-for="item in deliveryStats" :key="item.month" class="group">
              <div class="flex items-center justify-between mb-2">
                 <span class="text-[10px] font-black text-gray-500 uppercase">{{ item.month }}</span>
                 <div class="flex items-center gap-2">
                    <span class="text-xs font-black text-gray-900 dark:text-white tabular-nums">{{ item.days }}d</span>
                    <span 
                      class="text-[10px] font-black px-1.5 py-0.5 rounded text-white"
                      :class="item.days <= plazoEntregaDatos ? 'bg-emerald-500' : 'bg-red-500'"
                    >
                      {{ item.days <= plazoEntregaDatos ? 'OK' : 'FAIL' }}
                    </span>
                 </div>
              </div>
              <div class="h-1.5 w-full bg-gray-50 dark:bg-gray-800 rounded-full overflow-hidden border border-gray-100 dark:border-gray-700/30">
                 <div 
                   class="h-full transition-all duration-1000"
                   :style="{ width: (item.days / 20 * 100) + '%', backgroundColor: item.days <= plazoEntregaDatos ? '#10b981' : '#ef4444' }"
                 ></div>
              </div>
           </div>
        </div>
      </div>

      <!-- Indices de Procesamiento -->
      <div class="space-y-6">
        <div class="flex items-center justify-between">
           <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Procesamiento Informe</h3>
           <span class="text-[10px] font-bold text-gray-400 uppercase italic">Meta: &lt; {{ plazoConfeccionInforme }} días</span>
        </div>

        <div class="space-y-4">
           <div v-for="item in processingStats" :key="item.month" class="group">
              <div class="flex items-center justify-between mb-2">
                 <span class="text-[10px] font-black text-gray-500 uppercase">{{ item.month }}</span>
                 <div class="flex items-center gap-2">
                    <span class="text-xs font-black text-gray-900 dark:text-white tabular-nums">{{ item.days }}d</span>
                    <span 
                      class="text-[10px] font-black px-1.5 py-0.5 rounded text-white"
                      :class="item.days <= plazoConfeccionInforme ? 'bg-indigo-500' : 'bg-orange-500'"
                    >
                      {{ item.days <= plazoConfeccionInforme ? 'OK' : 'LIMIT' }}
                    </span>
                 </div>
              </div>
              <div class="h-1.5 w-full bg-gray-50 dark:bg-gray-800 rounded-full overflow-hidden border border-gray-100 dark:border-gray-700/30">
                 <div 
                   class="h-full transition-all duration-1000"
                   :style="{ width: (item.days / 10 * 100) + '%', backgroundColor: item.days <= plazoConfeccionInforme ? '#6366f1' : '#f97316' }"
                 ></div>
              </div>
           </div>
        </div>
      </div>
    </div>

    <!-- Footnote -->
    <div class="mt-8 pt-4 border-t border-gray-50 dark:border-gray-800/50 flex justify-between items-center">
       <div class="flex items-center gap-2 text-[10px] font-bold text-gray-400 uppercase">
          <div class="w-2 h-2 rounded-full bg-emerald-500"></div>
          Cálculo basado en días corridos (D+N)
       </div>
       <button class="text-[10px] font-black text-indigo-500 hover:text-indigo-600 uppercase tracking-widest">Configurar Umbrales</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { storeToRefs } from 'pinia'
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'

const businessRulesStore = useBusinessRulesStore()
const { rules } = storeToRefs(businessRulesStore)
const plazoEntregaDatos = computed(() => rules.value.PLAZO_ENTREGA_DATOS || 0)
const plazoConfeccionInforme = computed(() => rules.value.PLAZO_CONFECCION_INFORME || 0)

const deliveryStats = [
  { month: 'Mayo', days: 12.4 },
  { month: 'Abril', days: 18.2 },
  { month: 'Marzo', days: 14.1 },
  { month: 'Febrero', days: 15.0 },
]

const processingStats = [
  { month: 'Mayo', days: 5.2 },
  { month: 'Abril', days: 6.8 },
  { month: 'Marzo', days: 8.5 },
  { month: 'Febrero', days: 4.9 },
]
</script>
