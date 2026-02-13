<template>
    <BaseModal :show="show" @close="close" maxWidth="7xl"
        :title="`Verificación de Trayectoria - ${vesselName || 'Buque'}`">
        <div class="h-[80vh] w-full relative overflow-hidden bg-surface-muted rounded-2xl border border-border">
            <!-- Loading Overlay -->
            <div v-if="loading"
                class="absolute inset-0 z-[2000] bg-surface/80 backdrop-blur-sm flex flex-col items-center justify-center">
                <LoadingSpinner size="lg" class="text-primary" />
                <span class="mt-4 text-xs font-black uppercase tracking-widest text-text-muted">Cargando
                    trayectoria...</span>
            </div>

            <!-- Coverage Alert Overlay -->
            <div v-if="!loading && coverageStatus !== 'COMPLETE'"
                class="absolute top-20 left-1/2 -translate-x-1/2 z-[1500] w-full max-w-lg animate-in slide-in-from-top duration-500">
                <Alert v-if="coverageStatus === 'NO_DATA'" variant="error" title="SIN DATOS DE SEGUIMIENTO"
                    message="No se encontraron posiciones para el buque en el rango de tiempo del evento." />
                <Alert v-else-if="coverageStatus === 'PARTIAL_DATA'" variant="warning" title="DATOS INCOMPLETOS"
                    :message="coverageMessage" />
            </div>

            <!-- Map -->
            <MapMonitor v-if="fleetData" ref="mapMonitor" class="w-full h-full" :fleet="fleetData"
                :activeLayers="mapLayers" @update:mouse-coords="mouseCoords = $event" @seek-vessel="handleSeekVessel" />

            <!-- HUD Layer -->
            <div class="absolute inset-0 z-[1000] pointer-events-none p-6">
                <!-- Top Right: Mouse Coordinates -->
                <div class="absolute top-6 right-6 pointer-events-auto">
                    <MouseCoordinates :coords="mouseCoords" />
                </div>

                <!-- Top Left: Back/Close (Alternative) -->
                <div class="absolute top-6 left-6 pointer-events-auto">
                    <!-- Vessel Card -->
                    <VesselInfoCard v-if="vesselData" :vesselName="vesselData.name"
                        :mareaCode="vesselData.mareaCode || '--'"
                        :position="{ lat: currentPoint?.lat || 0, lon: currentPoint?.lon || 0 }"
                        :timestamp="currentPoint?.timestamp?.toString() || ''" :speed="currentPoint?.speed || 0"
                        :course="currentPoint?.course || 0" :lastUpdate="vesselData.lastUpdate"
                        :hideLayerControls="true" />
                </div>

                <!-- Bottom Controls -->
                <div class="absolute bottom-6 left-6 right-6 flex flex-col gap-2">

                    <!-- Player -->
                    <div class="w-full flex justify-center pb-4 pointer-events-auto">
                        <div class="w-full max-w-md">
                            <TimelinePlayer v-if="vesselData && vesselData.points.length"
                                :currentIndex="vesselData.currentIndex" :maxIndex="vesselData.points.length - 1"
                                :currentTime="currentPoint?.timestamp?.toString() || ''" :isPlaying="isPlaying"
                                :speed="playbackSpeed" :startDate="startDateStr" :endDate="endDateStr"
                                @update:index="handlePlayerIndexUpdate" @update:speed="handleSpeedChange"
                                @toggle-play="togglePlay" @prev="handlePlayerPrev" @next="handlePlayerNext"
                                @skip-start="vesselData.currentIndex = 0"
                                @skip-end="vesselData.currentIndex = vesselData.points.length - 1" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </BaseModal>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import MapMonitor, { type VesselTrajectory } from '@/modules/monitor/components/MapMonitor.vue'
import VesselInfoCard from '@/modules/monitor/components/VesselInfoCard.vue'
import TimelinePlayer from '@/modules/monitor/components/TimelinePlayer.vue'
import MouseCoordinates from '@/modules/monitor/components/MouseCoordinates.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import Alert from '@/components/ui/Alert.vue'
import httpClient from '@/config/http/http.client'
import type { LatLng } from 'leaflet'

const props = defineProps<{
    show: boolean
    vesselId: string
    referenceDate: string | Date
    endDate?: string | Date
    vesselName: string
    mareaId?: string
    mareaCode?: string
}>()

const emit = defineEmits(['close'])

const loading = ref(false)
const fleetData = ref<Record<string, VesselTrajectory>>({})
const mouseCoords = ref<LatLng | null>(null)
const mapMonitor = ref<InstanceType<typeof MapMonitor> | null>(null)

// Coverage validation
const coverageStatus = ref<'COMPLETE' | 'PARTIAL_DATA' | 'NO_DATA'>('COMPLETE')
const coverageMessage = ref('')
const COVERAGE_TOLERANCE_MS = 2 * 60 * 60 * 1000 // 2 hours tolerance

// Playback state
const isPlaying = ref(false)
const playbackSpeed = ref(1)
let playbackInterval: ReturnType<typeof setInterval> | null = null

const mapLayers = {
    veda: false,
    vieira: false,
    centolla: false,
    points: true, // Always show points for detailed verification
    showAllVessels: true,
    showVesselNames: true
}

const vesselData = computed(() => {
    if (!props.vesselId) return null
    return fleetData.value[props.vesselId]
})

const currentPoint = computed(() => {
    if (!vesselData.value) return null
    return vesselData.value.points[vesselData.value.currentIndex] || null
})

const startDateStr = computed(() => {
    if (!vesselData.value?.points.length) return '--'
    return vesselData.value.points[0].timestamp.toString().split('T')[0]
})

const endDateStr = computed(() => {
    if (!vesselData.value?.points.length) return '--'
    return vesselData.value.points[vesselData.value.points.length - 1].timestamp.toString().split('T')[0]
})

const close = () => {
    stopPlayback()
    emit('close')
}

const fetchTrajectory = async () => {
    loading.value = true
    // Calcular rango inicial y final
    const startDate = new Date(props.referenceDate)
    const endDate = props.endDate ? new Date(props.endDate) : startDate

    if (isNaN(startDate.getTime())) {
        loading.value = false
        return
    }

    // Si hay un endDate específico y parece ser solo una fecha (hora 00:00:00)
    // le asignamos el fin del día para asegurar que el rango sea inclusivo.
    if (props.endDate && endDate.getHours() === 0 && endDate.getMinutes() === 0) {
        endDate.setHours(23, 59, 59, 999)
    }

    // Ampliar 12h hacia afuera de los extremos
    const fromDate = new Date(startDate.getTime() - 6 * 60 * 60 * 1000)
    const toDate = new Date(endDate.getTime() + 6 * 60 * 60 * 1000)

    try {
        const params = {
            from: fromDate.toISOString(),
            to: toDate.toISOString()
        }

        const response = await httpClient.get(`/tracking/history/${props.vesselId}`, { params })
        const points = response.data

        // Validate Coverage
        if (!points || points.length === 0) {
            coverageStatus.value = 'NO_DATA'
        } else {
            const firstPointTime = new Date(points[0].timestamp).getTime()
            const lastPointTime = new Date(points[points.length - 1].timestamp).getTime()
            const startLimit = startDate.getTime()
            const endLimit = endDate.getTime()

            const startGap = firstPointTime - startLimit
            const endGap = endLimit - lastPointTime

            if (startGap > COVERAGE_TOLERANCE_MS || endGap > COVERAGE_TOLERANCE_MS) {
                coverageStatus.value = 'PARTIAL_DATA'

                const formatTime = (ms: number) => {
                    const hours = Math.floor(Math.abs(ms) / (1000 * 60 * 60))
                    return hours > 0 ? `${hours}h` : 'menos de 1h'
                }

                if (startGap > COVERAGE_TOLERANCE_MS && endGap > COVERAGE_TOLERANCE_MS) {
                    coverageMessage.value = `Faltan datos al inicio (gap de ${formatTime(startGap)}) y al final (gap de ${formatTime(endGap)}) del evento.`
                } else if (startGap > COVERAGE_TOLERANCE_MS) {
                    coverageMessage.value = `Faltan datos al inicio del evento (comienzan ${formatTime(startGap)} después).`
                } else {
                    coverageMessage.value = `Faltan datos al final del evento (terminan ${formatTime(endGap)} antes).`
                }
            } else {
                coverageStatus.value = 'COMPLETE'
            }
        }

        // Build single-vessel fleet object
        fleetData.value = {
            [props.vesselId]: {
                id: props.vesselId, // Use vesselId as generic ID since we might not have a marea ID for tracking events
                vesselId: props.vesselId,
                name: props.vesselName,
                color: '#3B82F6', // Default blue
                points: points,
                currentIndex: 0,
                visible: true,
                matricula: '',
                mareaCode: props.mareaCode,
                // Find closest point to refDate to set initial index
                lastKnownPoint: null
            }
        }

        // Set initial index to the reference date
        if (points.length) {
            let minDiff = Infinity
            let initialIdx = 0
            const targetTime = startDate.getTime()

            points.forEach((p: any, idx: number) => {
                const pTime = new Date(p.timestamp).getTime()
                const diff = Math.abs(pTime - targetTime)
                if (diff < minDiff) {
                    minDiff = diff
                    initialIdx = idx
                }
            })
            fleetData.value[props.vesselId].currentIndex = initialIdx
        }

        // Fit bounds after render
        setTimeout(() => {
            mapMonitor.value?.fitVesselBounds(props.vesselId)
        }, 100)

    } catch (e) {
        console.error('Error loading trajectory verification', e)
    } finally {
        loading.value = false
    }
}

watch(() => props.show, (val) => {
    if (val) {
        fleetData.value = {} // Reset
        fetchTrajectory()
    } else {
        stopPlayback()
    }
})

// Player Logic Reuse
const handleSeekVessel = ({ vesselId, index }: { vesselId: string, index: number }) => {
    if (fleetData.value[vesselId]) {
        fleetData.value[vesselId].currentIndex = index
    }
}

const handlePlayerIndexUpdate = (val: number) => {
    if (vesselData.value) vesselData.value.currentIndex = val
}

const handlePlayerPrev = () => {
    if (vesselData.value) vesselData.value.currentIndex = Math.max(0, vesselData.value.currentIndex - 1)
}

const handlePlayerNext = () => {
    if (vesselData.value) vesselData.value.currentIndex = Math.min(vesselData.value.points.length - 1, vesselData.value.currentIndex + 1)
}

const handleSpeedChange = (newSpeed: number) => {
    playbackSpeed.value = newSpeed
    if (isPlaying.value) {
        stopPlayback()
        startPlayback()
    }
}

const togglePlay = () => {
    if (isPlaying.value) stopPlayback()
    else startPlayback()
}

const startPlayback = () => {
    if (!vesselData.value || vesselData.value.points.length === 0) return

    if (vesselData.value.currentIndex >= vesselData.value.points.length - 1) {
        vesselData.value.currentIndex = 0
    }

    isPlaying.value = true
    playbackInterval = setInterval(() => {
        if (vesselData.value && vesselData.value.currentIndex < vesselData.value.points.length - 1) {
            vesselData.value.currentIndex++
        } else {
            stopPlayback()
        }
    }, 500 / playbackSpeed.value)
}

const stopPlayback = () => {
    isPlaying.value = false
    if (playbackInterval) {
        clearInterval(playbackInterval)
        playbackInterval = null
    }
}
</script>
