import { ref, computed } from 'vue'
import type { Observador } from '../interfaces/observador.interface'
import observadoresApi, { type CreateObservadorDto, type UpdateObservadorDto } from '../services/observadores.service'
import { toast } from 'vue-sonner'

export function useObservadores() {
    const observadores = ref<Observador[]>([])
    const isLoading = ref(true)
    const searchQuery = ref('')
    const isSaving = ref(false)
    const showModal = ref(false)
    const selectedObservador = ref<Observador | null>(null)

    const fetchObservadores = async () => {
        isLoading.value = true
        try {
            observadores.value = await observadoresApi.getObservadores()
        } catch (error) {
            toast.error('Error al cargar observadores')
        } finally {
            isLoading.value = false
        }
    }

    const filteredObservadores = computed(() => {
        if (!searchQuery.value) return observadores.value
        const lower = searchQuery.value.toLowerCase()
        return observadores.value.filter(o =>
            o.nombre.toLowerCase().includes(lower) ||
            o.apellido.toLowerCase().includes(lower) ||
            o.codigoInterno.toString().includes(lower)
        )
    })

    const openCreateModal = () => {
        selectedObservador.value = null
        showModal.value = true
    }

    const openEditModal = (observador: Observador) => {
        selectedObservador.value = { ...observador }
        showModal.value = true
    }

    const closeModal = () => {
        showModal.value = false
        selectedObservador.value = null
    }

    const handleSave = async (data: UpdateObservadorDto & { id?: string }) => {
        isSaving.value = true
        try {
            const { id, ...payload } = data

            if (id) {
                await observadoresApi.updateObservador(id, payload)
                toast.success('Observador actualizado correctamente')
            } else {
                await observadoresApi.createObservador(payload as CreateObservadorDto)
                toast.success('Observador creado correctamente')
            }
            await fetchObservadores()
            closeModal()
        } catch (error: any) {
            console.error('Save error:', error)
            const errorMessage = error.response?.data?.message || 'Error al guardar observador'
            if (Array.isArray(errorMessage)) {
                errorMessage.forEach(msg => toast.error(msg))
            } else {
                toast.error(errorMessage)
            }
        } finally {
            isSaving.value = false
        }
    }


    return {
        // State
        observadores,
        isLoading,
        searchQuery,
        isSaving,
        showModal,
        selectedObservador,
        // Computed
        filteredObservadores,
        // Methods
        fetchObservadores,
        openCreateModal,
        openEditModal,
        closeModal,
        handleSave,
    }
}
