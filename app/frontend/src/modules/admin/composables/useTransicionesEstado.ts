import { ref, computed } from 'vue'
import { toast } from 'vue-sonner'
import type { TransicionEstado, EstadoMareaResumen } from '../interfaces/transicion-estado.interface'
import transicionesEstadoApi from '../services/transiciones-estado.service'

export function useTransicionesEstado() {
    const transiciones = ref<TransicionEstado[]>([])
    const estados = ref<EstadoMareaResumen[]>([])

    const isLoading = ref(false)
    const isSaving = ref(false)
    const searchQuery = ref('')

    const isModalOpen = ref(false)
    const currentTransicion = ref<Partial<TransicionEstado> | null>(null)
    const isDeleting = ref(false)
    const deleteTargetId = ref<string | null>(null)

    const fetchTransiciones = async () => {
        isLoading.value = true
        try {
            transiciones.value = await transicionesEstadoApi.getAll()
        } catch {
            toast.error('Error al cargar transiciones de estado')
        } finally {
            isLoading.value = false
        }
    }

    const fetchEstados = async () => {
        try {
            estados.value = await transicionesEstadoApi.getEstados()
        } catch {
            toast.error('Error al cargar estados de marea')
        }
    }

    const filteredTransiciones = computed(() => {
        if (!searchQuery.value) return transiciones.value
        const q = searchQuery.value.toLowerCase()
        return transiciones.value.filter(t =>
            t.accion.toLowerCase().includes(q) ||
            t.etiqueta.toLowerCase().includes(q) ||
            t.estadoOrigen?.nombre.toLowerCase().includes(q) ||
            t.estadoDestino?.nombre.toLowerCase().includes(q) ||
            t.estadoOrigen?.codigo.toLowerCase().includes(q) ||
            t.estadoDestino?.codigo.toLowerCase().includes(q)
        )
    })

    const openCreateModal = () => {
        currentTransicion.value = {
            estadoOrigenId: '',
            estadoDestinoId: '',
            accion: '',
            etiqueta: '',
            claseBoton: 'primary',
            requiereObs: false,
            activo: true,
        }
        isModalOpen.value = true
    }

    const openEditModal = (transicion: TransicionEstado) => {
        currentTransicion.value = { ...transicion }
        isModalOpen.value = true
    }

    const closeModal = () => {
        isModalOpen.value = false
        currentTransicion.value = null
    }

    const handleSave = async (data: Partial<TransicionEstado>) => {
        isSaving.value = true
        try {
            const allowedFields: (keyof TransicionEstado)[] = [
                'estadoOrigenId', 'estadoDestinoId', 'accion', 'etiqueta',
                'claseBoton', 'requiereObs', 'activo',
            ]
            const payload: any = {}
            allowedFields.forEach(field => {
                if (data[field] !== undefined) payload[field] = data[field]
            })

            if (currentTransicion.value?.id) {
                await transicionesEstadoApi.update(currentTransicion.value.id, payload)
                toast.success('Transición actualizada correctamente')
            } else {
                await transicionesEstadoApi.create(payload)
                toast.success('Transición creada correctamente')
            }
            await fetchTransiciones()
            closeModal()
        } catch (error: any) {
            if (error.validationErrors) {
                Object.values(error.validationErrors).forEach(msg => toast.error(msg as string))
            } else {
                toast.error(error.message || 'Error al guardar la transición')
            }
        } finally {
            isSaving.value = false
        }
    }

    const handleDelete = async (id: string) => {
        isDeleting.value = true
        deleteTargetId.value = id
        try {
            await transicionesEstadoApi.delete(id)
            toast.success('Transición eliminada correctamente')
            await fetchTransiciones()
        } catch (error: any) {
            toast.error(error.message || 'Error al eliminar la transición')
        } finally {
            isDeleting.value = false
            deleteTargetId.value = null
        }
    }

    return {
        transiciones,
        estados,
        isLoading,
        isSaving,
        isDeleting,
        deleteTargetId,
        searchQuery,
        isModalOpen,
        currentTransicion,
        filteredTransiciones,
        fetchTransiciones,
        fetchEstados,
        openCreateModal,
        openEditModal,
        closeModal,
        handleSave,
        handleDelete,
    }
}
