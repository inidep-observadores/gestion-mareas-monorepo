<template>
    <div class="flex flex-col h-full">
        <!-- Timeline Content -->
        <div v-if="loading" class="flex-1 flex flex-col items-center justify-center gap-3 py-12">
            <div class="w-8 h-8 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
            <p class="text-[10px] font-black uppercase text-text-muted tracking-widest">Cargando historial...</p>
        </div>

        <div v-else-if="items.length === 0" class="flex-1 flex flex-col items-center justify-center p-12 text-center">
            <div
                class="w-16 h-16 rounded-3xl bg-surface-muted flex items-center justify-center mb-4 border border-border">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-text-muted/40" viewBox="0 0 24 24"
                    fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                    <circle cx="12" cy="7" r="4" />
                </svg>
            </div>
            <p class="text-sm font-bold text-text mb-1">Sin actividad registrada</p>
            <p class="text-xs text-text-muted">No se encontraron registros para este observador en el periodo seleccionado.</p>
        </div>

        <div v-else class="flex-1 overflow-y-auto custom-scrollbar p-6">
            <div class="relative pl-8 border-l-2 border-border/50 ml-4 space-y-8">

                <div v-for="(item, idx) in items" :key="idx" class="relative">
                    <!-- Dot / Marker -->
                    <div class="absolute -left-[41px] top-0 w-5 h-5 rounded-full border-4 border-surface shadow-sm z-10 transition-transform hover:scale-125"
                        :class="[
                            item.type === 'TRIP' ? (item.isNavegando ? 'bg-info' : 'bg-primary') :
                            item.type === 'NOVEDAD' ? (item.codigo === 'DISPONIBLE' ? 'bg-emerald-500' : 'bg-amber-500') :
                            item.type === 'LAND' ? 'bg-text-muted/30' : 'bg-surface border-border'
                        ]"></div>

                    <!-- TRIP ITEM -->
                    <div v-if="item.type === 'TRIP'" class="group">
                        <div class="flex flex-col gap-1">
                            <div class="flex items-center gap-2">
                                <span class="text-[10px] font-black uppercase tracking-widest text-primary">{{
                                    item.mareaCode }}</span>
                                <span v-if="item.ignoreStats"
                                    class="text-[8px] font-black bg-surface-muted text-text-muted px-1.5 py-0.5 rounded-md border border-border">ESPERANDO
                                    ZARPADA</span>
                                <span v-if="item.isNavegando"
                                    class="text-[8px] font-black bg-info/10 text-info px-1.5 py-0.5 rounded-md animate-pulse">EN
                                    NAVEGACION</span>
                            </div>
                            <div @click="openMareaDetail(item.id)"
                                class="flex flex-col rounded-2xl border border-border bg-surface p-4 shadow-sm group-hover:shadow-md group-hover:border-primary/20 transition-all cursor-pointer active:scale-[0.98]">
                                <div class="flex justify-between items-start mb-3">
                                    <div>
                                        <div class="flex items-center gap-2">
                                            <h4 class="text-sm font-black text-text leading-tight">{{ item.vessel }}
                                            </h4>
                                            <span v-if="item.fishery || item.fleet"
                                                class="text-[9px] font-bold text-primary uppercase tracking-widest italic leading-none">
                                                ( {{ [item.fishery, item.fleet].filter(Boolean).join(' - ') }} )
                                            </span>
                                        </div>
                                        <p
                                            class="text-[10px] font-bold text-text-muted uppercase tracking-tighter mt-0.5">
                                            {{ formatDate(item.start) }} — {{ formatDate(item.end) }}
                                        </p>
                                    </div>
                                    <div class="text-right">
                                        <div class="text-lg font-black text-text leading-none">{{ item.totalDays }}
                                        </div>
                                        <div class="text-[8px] font-black text-text-muted uppercase tracking-tighter">
                                            Días totales</div>
                                    </div>
                                </div>

                                <div class="flex items-center justify-between pt-3 border-t border-border/50">
                                    <div class="flex items-center gap-2">
                                        <div class="flex flex-col">
                                            <span
                                                class="text-[9px] font-black text-text-muted uppercase">Navegados</span>
                                            <span class="text-xs font-black text-primary">{{ item.navigatedDays
                                                }}d</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- NOVEDAD ITEM (DISPONIBLE / NO DISPONIBLE) -->
                    <div v-if="item.type === 'NOVEDAD'" class="group">
                        <div @click="openNovedadDetail(item)"
                            class="flex items-center justify-between gap-3 px-4 py-2.5 rounded-xl border border-border bg-surface hover:border-primary/40 hover:shadow-xs transition-all cursor-pointer active:scale-[0.99]"
                            :class="item.codigo === 'DISPONIBLE' ? 'border-l-4 border-l-emerald-500' : 'border-l-4 border-l-amber-500'"
                        >
                            <div class="flex flex-col min-w-0">
                                <!-- Período formateado y Chips de Días -->
                                <div class="flex items-center gap-2 flex-wrap">
                                    <span class="text-xs font-black text-text leading-tight">
                                        {{ formatPeriodoNovedad(item) }}
                                    </span>

                                    <!-- Chip de días hasta zarpar o días disponible actual -->
                                    <span v-if="item.codigo === 'DISPONIBLE' && item.diasHastaSiguienteMarea !== undefined"
                                        class="px-2 py-0.5 text-[9px] font-black rounded-md tracking-wider uppercase"
                                        :class="item.tieneMareaPosterior 
                                            ? 'bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border border-emerald-500/20' 
                                            : 'bg-primary/10 text-primary border border-primary/20'"
                                    >
                                        {{ item.tieneMareaPosterior ? `${item.diasHastaSiguienteMarea}d hasta zarpar` : `${item.diasHastaSiguienteMarea}d disponible hoy` }}
                                    </span>

                                    <!-- Chip de días de no disponibilidad -->
                                    <span v-else-if="item.codigo === 'NO_DISPONIBLE' && item.diasNoDisponible"
                                        class="px-2 py-0.5 text-[9px] font-black rounded-md tracking-wider uppercase bg-amber-500/10 text-amber-600 dark:text-amber-400 border border-amber-500/20"
                                    >
                                        {{ item.diasNoDisponible }}d no disponible
                                    </span>

                                    <!-- Indicador de archivos adjuntos -->
                                    <span v-if="item.archivos && item.archivos.length > 0"
                                        class="inline-flex items-center gap-1 text-[9px] font-bold text-text-muted bg-surface-muted px-1.5 py-0.5 rounded border border-border"
                                        title="Contiene archivos adjuntos"
                                    >
                                        <PaperclipIcon class="w-3 h-3 text-primary" />
                                        {{ item.archivos.length > 1 ? item.archivos.length : '' }}
                                    </span>
                                </div>

                                <!-- Fecha de registro -->
                                <p class="text-[10px] font-bold text-text-muted mt-0.5">
                                    Registrada el {{ formatDate(item.fechaRegistro || item.fechaCreacion) }}
                                </p>
                            </div>

                            <!-- Flecha sutil indicando interactividad -->
                            <div class="shrink-0 text-text-muted/40 group-hover:text-primary transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="9 18 15 12 9 6" />
                                </svg>
                            </div>
                        </div>
                    </div>

                    <!-- LAND ITEM -->
                    <div v-if="item.type === 'LAND'" class="py-2">
                        <div class="flex items-center gap-3 text-text-muted/60">
                            <div class="h-px bg-border/50 flex-1"></div>
                            <div class="flex items-center gap-2 flex-wrap justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 text-text-muted/70" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                    stroke-linejoin="round">
                                    <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                                    <polyline points="9 22 9 12 15 12 15 22" />
                                </svg>
                                <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">
                                    {{ item.days }} días en tierra
                                    <template v-if="item.diasDisponible !== null && item.diasDisponible !== undefined">
                                        ({{ item.diasDisponible }}d disponible)
                                    </template>
                                </span>

                                <!-- Alerta sutil si no declaró disponibilidad -->
                                <span v-if="item.sinAvisoDisponibilidad"
                                    class="inline-flex items-center gap-1 px-2 py-0.5 text-[9px] font-bold rounded-md bg-amber-500/10 text-amber-600 dark:text-amber-400 border border-amber-500/20"
                                    title="No se registró aviso formal de disponibilidad previo al embarque."
                                >
                                    <span>⚠️</span> Sin aviso de disponibilidad
                                </span>
                            </div>
                            <div class="h-px bg-border/50 flex-1"></div>
                        </div>
                    </div>

                    <!-- YEAR TOTAL -->
                    <div v-if="item.type === 'YEAR_TOTAL'" class="mt-4 mb-8">
                        <div
                            class="px-4 py-2 bg-surface-muted rounded-xl border border-border inline-flex flex-col items-center min-w-[120px]">
                            <span class="text-[8px] font-black text-text-muted uppercase tracking-[0.2em]">Total {{
                                item.year }}</span>
                            <span class="text-xl font-black text-text leading-tight">{{ item.totalDays }}</span>
                            <span class="text-[8px] font-black text-text-muted uppercase tracking-widest">Días de
                                Marea</span>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- Marea Detail Modal -->
        <MareaQuickDetailModal :is-open="showDetailModal" :marea-id="selectedMareaId"
            @close="showDetailModal = false" />

        <!-- Novedad Detail Modal (Solo lectura con actividad reciente) -->
        <NovedadDetailModal :show="showNovedadModal" :novedad="selectedNovedad"
            @close="showNovedadModal = false" />
    </div>
</template>

<script setup lang="ts">
import { formatDateUI } from '@/utils/date.utils'
import { ref, watch } from 'vue'
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue'
import NovedadDetailModal from './NovedadDetailModal.vue'
import observadoresApi from '../services/observadores.service'
import { PaperclipIcon } from '@/icons'
import { toast } from 'vue-sonner'

const props = defineProps<{
    observadorId: string | null
    year?: number
}>()

const items = ref<any[]>([])
const loading = ref(false)

// Marea Detail Modal State
const showDetailModal = ref(false)
const selectedMareaId = ref<string | null>(null)

// Novedad Detail Modal State
const showNovedadModal = ref(false)
const selectedNovedad = ref<any | null>(null)

const openMareaDetail = (mareaId: string) => {
    selectedMareaId.value = mareaId
    showDetailModal.value = true
}

const openNovedadDetail = (novedad: any) => {
    selectedNovedad.value = novedad
    showNovedadModal.value = true
}

const loadHistorial = async () => {
    if (!props.observadorId) return
    loading.value = true
    try {
        const [historialData] = await Promise.all([
            observadoresApi.getHistorial(props.observadorId, props.year)
        ])
        items.value = historialData
    } catch (error) {
        console.error('Error cargando historial:', error)
        toast.error('No se pudo cargar el historial del observador')
    } finally {
        loading.value = false
    }
}

watch(() => [props.observadorId, props.year], () => {
    if (props.observadorId) {
        loadHistorial()
    } else {
        items.value = []
    }
}, { immediate: true })

const formatDate = (dateStr?: string | Date | null) => {
    if (!dateStr) return '-'
    return formatDateUI(dateStr as string)
}

const formatPeriodoNovedad = (item: any) => {
    const isDisp = item.codigo === 'DISPONIBLE'
    const prefix = isDisp ? 'Disponible' : 'No disponible'
    const hasInicio = !!item.fechaInicio
    const hasFin = !!item.fechaFin

    if (hasInicio && hasFin) {
        return `${prefix} entre ${formatDate(item.fechaInicio)} y ${formatDate(item.fechaFin)}`
    }
    if (hasInicio) {
        return `${prefix} a partir del ${formatDate(item.fechaInicio)}`
    }
    if (hasFin) {
        return `${prefix} hasta el ${formatDate(item.fechaFin)}`
    }
    return `${prefix} sin fechas definidas`
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
    background: var(--color-border);
    border-radius: 10px;
}
</style>
