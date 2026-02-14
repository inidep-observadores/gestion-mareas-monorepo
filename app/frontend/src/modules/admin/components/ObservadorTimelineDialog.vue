<template>
    <BaseModal :show="show" title="Historial del Observador" @close="emit('close')" maxWidth="2xl" variant="default">
        <div class="flex flex-col h-[70vh]">
            <!-- Header Info -->
            <div class="px-6 py-4 bg-surface-muted/30 border-b border-border flex items-center gap-4 shrink-0">
                <div
                    class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center border border-primary/20">
                    <span class="text-sm font-black text-primary">{{ initials }}</span>
                </div>
                <div>
                    <h2 class="text-base font-black text-text uppercase tracking-tight leading-none">{{ observadorName
                        }}</h2>
                    <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter mt-1">Historial Operativo
                        ({{ year }} - {{ year - 1 }})</p>
                </div>
            </div>

            <!-- Timeline Content -->
            <div v-if="loading" class="flex-1 flex flex-col items-center justify-center gap-3">
                <div class="w-8 h-8 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
                <p class="text-[10px] font-black uppercase text-text-muted tracking-widest">Cargando historial...</p>
            </div>

            <div v-else-if="items.length === 0"
                class="flex-1 flex flex-col items-center justify-center p-12 text-center">
                <div
                    class="w-16 h-16 rounded-3xl bg-surface-muted flex items-center justify-center mb-4 border border-border">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-text-muted/40" viewBox="0 0 24 24"
                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                        stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                </div>
                <p class="text-sm font-bold text-text mb-1">Sin actividad registrada</p>
                <p class="text-xs text-text-muted">No se encontraron mareas para este observador en el periodo
                    seleccionado.</p>
            </div>

            <div v-else class="flex-1 overflow-y-auto custom-scrollbar p-6">
                <div class="relative pl-8 border-l-2 border-border/50 ml-4 space-y-8">

                    <div v-for="(item, idx) in items" :key="idx" class="relative">
                        <!-- Dot / Marker -->
                        <div class="absolute -left-[41px] top-0 w-5 h-5 rounded-full border-4 border-surface shadow-sm z-10 transition-transform hover:scale-125"
                            :class="[
                                item.type === 'TRIP' ? (item.isNavegando ? 'bg-info' : 'bg-primary') :
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
                                            <h4 class="text-sm font-black text-text leading-tight">{{ item.vessel }}
                                            </h4>
                                            <p
                                                class="text-[10px] font-bold text-text-muted uppercase tracking-tighter mt-0.5">
                                                {{ formatDate(item.start) }} — {{ formatDate(item.end) }}
                                            </p>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-lg font-black text-text leading-none">{{ item.totalDays }}
                                            </div>
                                            <div
                                                class="text-[8px] font-black text-text-muted uppercase tracking-tighter">
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

                        <!-- LAND ITEM -->
                        <div v-if="item.type === 'LAND'" class="py-2">
                            <div class="flex items-center gap-3 text-text-muted/60">
                                <div class="h-px bg-border/50 flex-1"></div>
                                <div class="flex items-center gap-1.5">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24"
                                        fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"
                                        stroke-linejoin="round">
                                        <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                                        <polyline points="9 22 9 12 15 12 15 22" />
                                    </svg>
                                    <span class="text-[10px] font-black uppercase tracking-widest">{{ item.days }} días
                                        en tierra</span>
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

            <!-- Footer Actions -->
            <div class="p-4 border-t border-border flex justify-end shrink-0">
                <button @click="emit('close')"
                    class="px-6 py-2.5 bg-surface text-text-muted text-[10px] font-black uppercase tracking-widest rounded-xl border border-border hover:bg-surface-muted transition-all">
                    Cerrar
                </button>
            </div>
        </div>
    </BaseModal>

    <!-- Marea Detail Modal -->
    <MareaQuickDetailModal :is-open="showDetailModal" :marea-id="selectedMareaId" @close="showDetailModal = false" />
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue'
import observadoresApi from '../services/observadores.service'
import { toast } from 'vue-sonner'

const props = defineProps<{
    show: boolean
    observadorId?: string | null
    observadorName?: string
    year: number
}>()

const emit = defineEmits(['close'])

const items = ref<any[]>([])
const loading = ref(false)

// Marea Detail Modal State
const showDetailModal = ref(false)
const selectedMareaId = ref<string | null>(null)

const openMareaDetail = (mareaId: string) => {
    selectedMareaId.value = mareaId
    showDetailModal.value = true
}

const initials = computed(() => {
    if (!props.observadorName) return '?'
    return props.observadorName
        .split(' ')
        .filter(Boolean)
        .map(n => n[0])
        .join('')
        .slice(0, 2)
        .toUpperCase()
})

const loadHistorial = async () => {
    if (!props.observadorId) return
    loading.value = true
    try {
        items.value = await observadoresApi.getHistorial(props.observadorId, props.year)
    } catch (error) {
        console.error('Error cargando historial:', error)
        toast.error('No se pudo cargar el historial del observador')
        emit('close')
    } finally {
        loading.value = false
    }
}

watch(() => props.show, (newShow) => {
    if (newShow) {
        loadHistorial()
    } else {
        items.value = []
    }
}, { immediate: true })

const formatDate = (dateStr: string) => {
    if (!dateStr) return '-'
    const date = new Date(dateStr)
    return date.toLocaleDateString('es-AR', {
        day: '2-digit',
        month: 'short',
        year: '2-digit'
    }).replace('.', '')
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
