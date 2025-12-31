import { ref, computed } from 'vue'
import { toast } from 'vue-sonner'
import type { Buque, TipoFlota, Puerto, Pesqueria, ArtePesca } from '../interfaces/buque.interface'
import buquesApi from '../services/buques.service'

export function useBuques() {
    const buques = ref<Buque[]>([])
    const tiposFlota = ref<TipoFlota[]>([])
    const puertos = ref<Puerto[]>([])
    const pesquerias = ref<Pesqueria[]>([])
    const artesPesca = ref<ArtePesca[]>([])

    const isLoading = ref(false)
    const isSaving = ref(false)
    const searchQuery = ref('')

    const isModalOpen = ref(false)
    const currentBuque = ref<Partial<Buque> | null>(null)

    const fetchBuques = async () => {
        isLoading.value = true
        try {
            buques.value = await buquesApi.getBuques()
        } catch (error) {
            toast.error('Error al cargar buques')
        } finally {
            isLoading.value = false
        }
    }

    const fetchCatalogs = async () => {
        try {
            const [tf, p, pesq, artes] = await Promise.all([
                buquesApi.getTiposFlota(),
                buquesApi.getPuertos(),
                buquesApi.getPesquerias(),
                buquesApi.getArtesPesca()
            ])
            tiposFlota.value = tf
            puertos.value = p
            pesquerias.value = pesq
            artesPesca.value = artes
        } catch (error) {
            toast.error('Error al cargar catálogos')
        }
    }

    const filteredBuques = computed(() => {
        if (!searchQuery.value) return buques.value
        const query = searchQuery.value.toLowerCase()
        return buques.value.filter(b =>
            b.nombreBuque.toLowerCase().includes(query) ||
            b.matricula.toLowerCase().includes(query)
        )
    })

    const openCreateModal = () => {
        currentBuque.value = {
            nombreBuque: '',
            matricula: '',
            activo: true
        }
        isModalOpen.value = true
    }

    const openEditModal = (buque: Buque) => {
        currentBuque.value = { ...buque }
        isModalOpen.value = true
    }

    const closeModal = () => {
        isModalOpen.value = false
        currentBuque.value = null
    }

    const handleSave = async (data: Partial<Buque>) => {
        isSaving.value = true
        try {
            // Limpiar datos para el backend usando una lista blanca (whitelist)
            // Esto evita enviar objetos de relación o campos no permitidos (forbidNonWhitelisted)
            const allowedFields: (keyof Buque)[] = [
                'nombreBuque', 'matricula', 'codigoInterno', 'tipoFlotaId',
                'arteHabitualId', 'pesqueriaHabitualId', 'diasMareaEstimada',
                'esloraM', 'potenciaHp', 'puertoBaseId', 'empresaNombre',
                'empresaLocalidad', 'empresaTelefono', 'empresaFax',
                'empresaCorreoPrincipal', 'empresaCorreoSecundario',
                'armadorNombre', 'armadorTelefono', 'agenciaMaritimaNombre',
                'activo', 'fechaAlta', 'fechaBaja', 'observaciones'
            ]

            const payload: any = {}
            const numericFields: (keyof Buque)[] = ['codigoInterno', 'diasMareaEstimada', 'esloraM', 'potenciaHp']

            allowedFields.forEach(field => {
                let value = data[field]

                // Si es un campo numérico, intentar convertir a número si es un string
                if (numericFields.includes(field)) {
                    if (typeof value === 'string' && value.trim() !== '') {
                        const num = Number(value.replace(',', '.'))
                        value = isNaN(num) ? null : num
                    } else if (value === '' || value === undefined) {
                        value = null
                    }
                }

                // Solo incluir si NO es undefined
                if (value !== undefined) {
                    payload[field] = value
                }
            })

            if (currentBuque.value?.id) {
                await buquesApi.updateBuque(currentBuque.value.id, payload)
                toast.success('Buque actualizado correctamente')
            } else {
                await buquesApi.createBuque(payload)
                toast.success('Buque creado correctamente')
            }
            await fetchBuques()
            closeModal()
        } catch (error: any) {
            console.error('Error al guardar buque:', error)

            // Si es un AppError (ya normalizado por el interceptor)
            if (error.validationErrors) {
                Object.values(error.validationErrors).forEach(msg => toast.error(msg as string))
            } else {
                const errorMessage = error.message || 'Error al guardar buque'
                toast.error(errorMessage)
            }
        } finally {
            isSaving.value = false
        }
    }

    return {
        // State
        buques,
        tiposFlota,
        puertos,
        pesquerias,
        artesPesca,
        isLoading,
        isSaving,
        searchQuery,
        isModalOpen,
        currentBuque,

        // Computed
        filteredBuques,

        // Actions
        fetchBuques,
        fetchCatalogs,
        openCreateModal,
        openEditModal,
        closeModal,
        handleSave
    }
}
