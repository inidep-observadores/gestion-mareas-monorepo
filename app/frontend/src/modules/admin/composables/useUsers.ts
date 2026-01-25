import { ref, computed } from 'vue'
import type { User } from '@/modules/auth/types/auth.types'
import usersAdminApi, { type CreateUserDto, type UpdateUserDto } from '../services/users.service'
import { toast } from 'vue-sonner'
import { ROLE_LABELS } from '../constants/roles.constants'

export function useUsers() {
    const users = ref<User[]>([])
    const isLoading = ref(true)
    const searchQuery = ref('')
    const isSaving = ref(false)
    const showModal = ref(false)
    const selectedUser = ref<User | null>(null)

    const fetchUsers = async () => {
        isLoading.value = true
        try {
            users.value = await usersAdminApi.getUsers()
        } catch (error) {
            toast.error('Error al cargar usuarios')
        } finally {
            isLoading.value = false
        }
    }

    const filteredUsers = computed(() => {
        if (!searchQuery.value) return users.value
        const lower = searchQuery.value.toLowerCase()
        return users.value.filter(u =>
            u.fullName.toLowerCase().includes(lower) ||
            u.email.toLowerCase().includes(lower)
        )
    })

    const openCreateModal = () => {
        selectedUser.value = null
        showModal.value = true
    }

    const openEditModal = (user: User) => {
        selectedUser.value = { ...user } // Clone
        showModal.value = true
    }

    const closeModal = () => {
        showModal.value = false
        selectedUser.value = null
    }

    const handleSave = async (data: UpdateUserDto & { id?: string }) => {
        isSaving.value = true
        try {
            const { id, ...payload } = data

            if (!payload.password) delete payload.password

            if (id) {
                await usersAdminApi.updateUser(id, payload)
                toast.success('Usuario actualizado correctamente')
            } else {
                await usersAdminApi.createUser(payload as CreateUserDto)
                toast.success('Usuario creado correctamente')
            }
            await fetchUsers()
            closeModal()
        } catch (error: any) {
            console.error('Save error:', error)
            const errorMessage = error.response?.data?.message || 'Error al guardar usuario'

            if (Array.isArray(errorMessage)) {
                errorMessage.forEach(msg => toast.error(msg))
            } else {
                toast.error(errorMessage)
            }
        } finally {
            isSaving.value = false
        }
    }

    const handleToggleStatus = async (user: User) => {
        try {
            await usersAdminApi.toggleStatus(user.id)
            toast.success(`Usuario ${user.isActive ? 'desactivado' : 'activado'} correctamente`)
            await fetchUsers()
        } catch (error: any) {
            const errorMessage = error.response?.data?.message || 'Error al cambiar estado'
            toast.error(errorMessage)
        }
    }

    return {
        // State
        users,
        isLoading,
        searchQuery,
        isSaving,
        showModal,
        selectedUser,
        // Computed
        filteredUsers,
        // Methods
        fetchUsers,
        openCreateModal,
        openEditModal,
        closeModal,
        handleSave,
        handleToggleStatus
    }
}
