<template>
    <BaseModal :show="show"
        :title="isEditing ? 'Editar Feriado' : 'Nuevo Feriado'"
        @close="closeModal" maxWidth="xl">
        <form v-form-nav @submit.prevent="handleSubmit" class="space-y-6" novalidate>
            <fieldset class="space-y-6">
                <div class="grid grid-cols-1 gap-4">
                    <div>
                        <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Fecha</label>
                        <DatePicker v-model="form.fecha" :show-time="false"
                            :error="fieldErrors.fecha" :disabled="isEditing" />
                        <p v-if="fieldErrors.fecha" class="text-[10px] text-error font-bold uppercase mt-1">{{
                            fieldErrors.fecha }}</p>
                        <p v-if="isEditing" class="text-[10px] text-warning font-bold uppercase mt-1">La fecha no puede ser modificada en modo edición. Si necesita cambiarla, elimine y cree uno nuevo.</p>
                    </div>

                    <div>
                        <label
                            class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Nombre del Feriado</label>
                        <input v-model="form.nombre" type="text" required ref="firstInput" :class="[
                            'h-11 w-full rounded-lg border bg-surface px-4 py-2.5 text-sm transition-all outline-none',
                            fieldErrors.nombre ? 'border-error bg-error/5' : 'border-border focus:border-primary focus:ring-3 focus:ring-primary/10'
                        ]" />
                        <p v-if="fieldErrors.nombre" class="text-[10px] text-error font-bold uppercase mt-1">{{
                            fieldErrors.nombre }}</p>
                    </div>

                    <div>
                        <label
                            class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Tipo</label>
                        <select v-model="form.tipo" required :class="[
                            'h-11 w-full rounded-lg border bg-surface px-4 text-sm transition-all outline-none appearance-none cursor-pointer',
                            fieldErrors.tipo ? 'border-error bg-error/5' : 'border-border focus:border-primary focus:ring-3 focus:ring-primary/10'
                        ]">
                            <option value="" disabled selected>Seleccione un tipo de feriado</option>
                            <option value="inamovible">Inamovible</option>
                            <option value="trasladable">Trasladable</option>
                            <option value="puente">Puente Turístico</option>
                            <option value="nolaborable">Día No Laborable</option>
                            <option value="otro">Otro</option>
                        </select>
                        <p v-if="fieldErrors.tipo" class="text-[10px] text-error font-bold uppercase mt-1">{{
                            fieldErrors.tipo }}</p>
                    </div>

                    <div v-if="isEditing">
                        <label
                            class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Origen</label>
                        <input v-model="form.origen" type="text" disabled class="h-11 w-full rounded-lg border bg-surface-muted px-4 py-2.5 text-sm text-text-muted outline-none cursor-not-allowed border-border" />
                    </div>
                </div>
            </fieldset>

            <div class="mt-8 flex flex-col-reverse sm:grid sm:grid-cols-2 sm:gap-3">
                <button type="button" class="mt-3 flex items-center justify-center w-full px-4 py-3 text-xs font-black uppercase tracking-widest transition-all rounded-lg shadow-theme-xs active:scale-95 sm:mt-0 text-text-muted bg-surface border border-border hover:bg-surface-muted hover:text-text sm:col-start-1" @click="closeModal">
                    Cancelar
                </button>
                <button type="submit"
                    data-allow-enter
                    class="flex items-center justify-center w-full px-4 py-3 text-xs font-black uppercase tracking-widest text-primary-fg transition-all rounded-lg bg-primary shadow-lg shadow-primary/20 hover:bg-primary-hover active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed sm:col-start-2"
                    :disabled="isSaving">
                    <span v-if="isSaving"
                        class="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent"></span>
                    {{ isSaving ? 'Guardando...' : 'Guardar' }}
                </button>
            </div>
        </form>
    </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed, nextTick } from 'vue';
import type { Feriado } from '../interfaces/feriados.interface';
import { toast } from 'vue-sonner';
import BaseModal from '@/components/common/BaseModal.vue';
import DatePicker from '@/components/common/DatePicker.vue';

const props = defineProps<{
    show: boolean;
    feriado?: Feriado | null;
    isSaving?: boolean;
}>();

const emit = defineEmits(['close', 'save']);

const isEditing = computed(() => !!props.feriado);
const fieldErrors = ref<Record<string, string>>({});

const initialForm = {
    fecha: '',
    nombre: '',
    tipo: '',
    origen: 'MANUAL',
};

const form = ref({ ...initialForm });
const firstInput = ref<HTMLInputElement | null>(null);

watch(
    () => props.feriado,
    (newFeriado) => {
        fieldErrors.value = {};
        if (newFeriado) {
            form.value = {
                fecha: new Date(newFeriado.fecha).toISOString().split('T')[0],
                nombre: newFeriado.nombre,
                tipo: newFeriado.tipo,
                origen: newFeriado.origen,
            };
        } else {
            form.value = { ...initialForm };
        }

        if (props.show) {
            nextTick(() => {
                firstInput.value?.focus();
            });
        }
    },
    { immediate: true }
);

watch(() => props.show, (val) => {
    if (val && !isEditing.value) {
        nextTick(() => {
            firstInput.value?.focus();
        });
    }
});

const closeModal = () => {
    fieldErrors.value = {};
    emit('close');
};

const validate = () => {
    fieldErrors.value = {};
    let isValid = true;

    if (!form.value.fecha) {
        fieldErrors.value.fecha = 'La fecha es obligatoria';
        isValid = false;
    }

    if (!form.value.nombre) {
        fieldErrors.value.nombre = 'El nombre es obligatorio';
        isValid = false;
    }

    if (!form.value.tipo) {
        fieldErrors.value.tipo = 'El tipo de feriado es obligatorio';
        isValid = false;
    }

    return isValid;
};

const handleSubmit = async () => {
    if (!validate()) {
        toast.error('Por favor, revise los errores en el formulario');
        return;
    }
    const data = { ...form.value };
    emit('save', data);
};
</script>
