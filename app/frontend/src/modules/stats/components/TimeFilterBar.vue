<template>
  <div
    class="bg-surface border border-border rounded-2xl shadow-theme-sm overflow-hidden animate-in fade-in slide-in-from-top-4 duration-500">
    <div class="flex flex-col md:flex-row items-stretch md:items-center">

      <!-- Label Section -->
      <div
        class="px-6 py-4 bg-surface-muted/30 border-b md:border-b-0 md:border-r border-border flex items-center gap-3 shrink-0">
        <div class="p-2 bg-primary/10 rounded-lg text-primary">
          <CalendarIcon class="w-5 h-5" />
        </div>
        <div>
          <span class="text-[10px] font-black text-text-muted uppercase tracking-widest block leading-none">Filtrar
            por</span>
          <span class="text-xs font-bold text-text uppercase tracking-tight">Periodo de Tiempo</span>
        </div>
      </div>

      <!-- Filters Area -->
      <div class="flex-1 flex flex-wrap items-center gap-4 p-4">

        <!-- Mes Selector -->
        <div class="flex flex-col gap-1.5 min-w-[170px]">
          <label class="text-[9px] font-black text-text-muted uppercase tracking-widest px-1">Mes Específico</label>
          <select v-model="localMonth" @change="handleMonthChange"
            class="bg-surface border border-border rounded-xl px-3 py-2 text-xs font-bold text-text focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none appearance-none cursor-pointer transition-all hover:bg-surface-muted/50">
            <option :value="null">Seleccionar Mes...</option>
            <option v-for="(name, index) in monthNames" :key="index" :value="index">
              {{ name }}
            </option>
          </select>
        </div>

        <!-- Trimestre Selector -->
        <div class="flex flex-col gap-1.5 min-w-[120px]">
          <label class="text-[9px] font-black text-text-muted uppercase tracking-widest px-1">Trimestre</label>
          <div class="flex gap-1 bg-surface-muted p-1 rounded-xl border border-border">
            <button v-for="q in [1, 2, 3, 4]" :key="q" @click="handleQuarterChange(q)" :class="[
              'px-2.5 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-wider transition-all duration-200',
              localQuarter === q ? 'bg-primary text-primary-fg shadow-sm' : 'text-text-muted hover:text-text hover:bg-surface'
            ]">
              T{{ q }}
            </button>
          </div>
        </div>

        <!-- Spacer Divider -->
        <div class="hidden lg:block w-px h-8 bg-border mx-2"></div>

        <!-- Rango Manual (DatePicker) -->
        <div class="flex-1 flex flex-col gap-1.5 min-w-0 sm:min-w-[340px]">
          <label class="text-[9px] font-black text-text-muted uppercase tracking-widest px-1">Rango
            Personalizado</label>
          <div class="flex flex-col sm:flex-row sm:items-center gap-2">
            <div class="flex-1 sm:max-w-[170px]">
              <DatePicker v-model="localStartDate" placeholder="Desde" @update:modelValue="handleRangeChange" />
            </div>
            <div class="hidden sm:block text-text-muted opacity-30">
              <ArrowRightIcon class="w-3 h-3" />
            </div>
            <div class="flex-1 sm:max-w-[170px]">
              <DatePicker v-model="localEndDate" placeholder="Hasta" @update:modelValue="handleRangeChange" />
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="flex items-center gap-2 ml-auto pt-4 md:pt-0">
          <button @click="resetFilters"
            class="flex items-center gap-2 px-4 py-2 rounded-xl border border-border text-[10px] font-black uppercase tracking-widest text-text-muted hover:bg-surface-muted hover:text-text transition-all active:scale-95 shadow-theme-xs bg-surface"
            title="Ver año completo">
            <RefreshCcwIcon class="w-3.5 h-3.5" />
            Reiniciar
          </button>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import {
  CalendarIcon,
  ArrowRightIcon,
  RefreshCcwIcon
} from 'lucide-vue-next'
import DatePicker from '@/components/common/DatePicker.vue'

interface Props {
  year: number
  startDate?: string | null
  endDate?: string | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
  (e: 'update:filter', dates: { startDate: string | null; endDate: string | null }): void
}>()

const monthNames = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
]

const localMonth = ref<number | null>(null)
const localQuarter = ref<number | null>(null)
const localStartDate = ref<string | null>(props.startDate || null)
const localEndDate = ref<string | null>(props.endDate || null)

// Watch for internal sync if needed (though we handle by user interaction)
watch(() => props.startDate, (val) => { localStartDate.value = val || null })
watch(() => props.endDate, (val) => { localEndDate.value = val || null })

const handleMonthChange = () => {
  if (localMonth.value === null) return

  localQuarter.value = null
  const start = new Date(props.year, localMonth.value, 1)
  const end = new Date(props.year, localMonth.value + 1, 0)

  localStartDate.value = start.toISOString()
  localEndDate.value = end.toISOString()

  emitUpdate()
}

const handleQuarterChange = (q: number) => {
  if (localQuarter.value === q) {
    localQuarter.value = null
    resetFilters()
    return
  }

  localQuarter.value = q
  localMonth.value = null

  const startMonth = (q - 1) * 3
  const endMonth = startMonth + 2

  const start = new Date(props.year, startMonth, 1)
  const end = new Date(props.year, endMonth + 1, 0)

  localStartDate.value = start.toISOString()
  localEndDate.value = end.toISOString()

  emitUpdate()
}

const handleRangeChange = () => {
  localMonth.value = null
  localQuarter.value = null
  emitUpdate()
}

const resetFilters = () => {
  localMonth.value = null
  localQuarter.value = null
  localStartDate.value = null
  localEndDate.value = null
  emitUpdate()
}

const emitUpdate = () => {
  emit('update:filter', {
    startDate: localStartDate.value,
    endDate: localEndDate.value
  })
}
</script>

<style scoped>
/* Custom select appearance to match design system */
select {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 1rem;
}
</style>
