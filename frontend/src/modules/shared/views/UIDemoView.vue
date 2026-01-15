<template>
  <div class="p-8">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-text mb-2">UI Style Guide (Temas Dinámicos)</h1>
      <p class="text-text-muted">Prueba los diferentes temas y el modo oscuro para verificar la consistencia visual.</p>
    </div>

    <!-- Controles de Tema -->
    <div class="bg-surface border border-border p-6 rounded-2xl shadow-sm mb-8">
      <h2 class="text-xl font-semibold mb-4 text-text">Configuración de Tema</h2>
      <div class="flex flex-wrap gap-4 items-center">
        <div class="flex gap-2">
            <button 
                v-for="color in colors" 
                :key="color.id"
                @click="themeStore.setPrimaryColor(color.id)"
                :class="[
                    'px-4 py-2 rounded-lg font-medium transition-all border',
                    themeStore.primaryColor === color.id 
                        ? 'border-primary bg-primary/10 text-primary shadow-sm' 
                        : 'border-border bg-surface text-text-muted hover:bg-background'
                ]"
            >
                {{ color.name }}
            </button>
        </div>
        
        <div class="h-8 w-px bg-border mx-2"></div>

        <button 
          @click="themeStore.toggleDarkMode"
          class="flex items-center gap-2 px-4 py-2 bg-surface border border-border rounded-lg hover:bg-background transition-colors text-text"
        >
          <component :is="themeStore.darkMode ? SunIcon : MoonIcon" class="w-5 h-5" />
          {{ themeStore.darkMode ? 'Modo Claro' : 'Modo Oscuro' }}
        </button>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      <!-- Sección Botones -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm">
        <h3 class="text-lg font-bold mb-4 text-primary border-b border-border pb-2">Botones (Semánticos)</h3>
        <div class="space-y-6">
          <div>
            <p class="text-xs font-medium text-text-muted uppercase mb-3">Variante Primary</p>
            <div class="flex flex-wrap gap-3">
              <Button variant="primary" size="sm">Pequeño</Button>
              <Button variant="primary">Mediano (Base)</Button>
              <Button variant="primary" :disabled="true">Desactivado</Button>
            </div>
          </div>
          <div>
            <p class="text-xs font-medium text-text-muted uppercase mb-3">Variante Outline</p>
            <div class="flex flex-wrap gap-3">
              <Button variant="outline" size="sm">Pequeño</Button>
              <Button variant="outline">Mediano (Base)</Button>
            </div>
          </div>
        </div>
      </section>

      <!-- Sección Badges -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm">
        <h3 class="text-lg font-bold mb-4 text-primary border-b border-border pb-2">Badges (Semánticos)</h3>
        <div class="space-y-6">
           <div>
            <p class="text-xs font-medium text-text-muted uppercase mb-3">Identidad (Primary)</p>
            <div class="flex flex-wrap gap-3">
              <Badge color="primary" variant="solid">Solid Primary</Badge>
              <Badge color="primary" variant="light">Light Primary</Badge>
            </div>
          </div>
          <div>
            <p class="text-xs font-medium text-text-muted uppercase mb-3">Otros Estados (FlyonUI compatible)</p>
            <div class="flex flex-wrap gap-3">
              <Badge color="success" variant="light">Completado</Badge>
              <Badge color="warning" variant="light">Pendiente</Badge>
              <Badge color="error" variant="light">Rechazado</Badge>
            </div>
          </div>
        </div>
      </section>

      <!-- Sección Tipografía -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm md:col-span-2">
         <h3 class="text-lg font-bold mb-4 text-primary border-b border-border pb-2">Tipografía Dinámica</h3>
         <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div class="space-y-2">
                <p class="text-5xl font-extrabold text-text">Título Gigante</p>
                <p class="text-3xl font-bold text-text">Título de Sección</p>
                <p class="text-xl font-medium text-text">Subtítulo Informativo</p>
                <p class="text-base text-text">Este es un párrafo de ejemplo para visualizar cómo cambia la fuente sans-serif según el tema seleccionado. El texto debe ser legible y estallar con la nueva personalidad.</p>
            </div>
            <div class="bg-background p-6 rounded-xl border border-border">
                <p class="text-sm font-semibold uppercase text-text-muted mb-4">Vista en un Contenedor Gris</p>
                <div class="bg-surface p-4 rounded-lg border border-border shadow-sm">
                    <p class="text-text font-medium">Card Interno</p>
                    <p class="text-sm text-text-muted">Los bordes se redondean más en el tema naranja.</p>
                </div>
            </div>
         </div>
      </section>

      <!-- Sección Componentes de Selección Simple -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm md:col-span-2">
        <h3 class="text-lg font-bold mb-4 text-primary border-b border-border pb-2">Componentes de Búsqueda y Fecha</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <!-- Search Input -->
          <div class="space-y-3">
            <p class="text-xs font-bold text-text-muted uppercase tracking-wider">Búsqueda Dinámica</p>
            <SearchInput v-model="searchText" placeholder="Buscar algo..." />
          </div>
          
          <!-- Searchable Select -->
          <div class="space-y-3">
            <p class="text-xs font-bold text-text-muted uppercase tracking-wider">Selector Buscable</p>
            <SearchableSelect 
              v-model="selectValue" 
              :options="demoOptions" 
              placeholder="Seleccionar categoría..."
              :icon="BoxIcon"
            />
          </div>

          <!-- Date Picker -->
          <div class="space-y-3">
            <p class="text-xs font-bold text-text-muted uppercase tracking-wider">Selector de Fecha</p>
            <DatePicker v-model="dateValue" placeholder="Elegir fecha" :icon="CalenderIcon" />
          </div>
        </div>
      </section>

      <!-- Sección Componentes Avanzados -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm md:col-span-2">
        <h3 class="text-lg font-bold mb-4 text-primary border-b border-border pb-2">Controles de Media y Selección Múltiple</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <!-- Multiple Select -->
          <div class="space-y-3">
            <p class="text-xs font-bold text-text-muted uppercase tracking-wider">Selección Múltiple (Tags)</p>
            <MultipleSelect v-model="multiSelected" :options="multiOptions" />
          </div>

          <!-- Dropzone -->
          <div class="space-y-3">
            <p class="text-xs font-bold text-text-muted uppercase tracking-wider">Carga de Archivos (Dropzone)</p>
            <Dropzone uploadUrl="#" />
          </div>
        </div>
      </section>

      <!-- Sección Timeline (Puro Tailwind) -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm md:col-span-2">
        <h3 class="text-lg font-bold mb-4 text-primary border-b border-border pb-2">Timeline (Puro Tailwind)</h3>
        <div class="alert-timeline py-2">
          <ol class="relative border-l-2 border-border ml-3">
            <li v-for="(event, idx) in timelineEvents" :key="idx" class="mb-8 ml-6">
              <span class="absolute flex items-center justify-center w-6 h-6 bg-surface rounded-full -left-[13px] ring-4 ring-background shadow-sm border border-border">
                <component :is="event.icon" class="w-3.5 h-3.5 text-primary" />
              </span>
              <div class="p-4 bg-background/50 rounded-2xl border border-border hover:bg-background transition-all group">
                <div class="flex justify-between items-start mb-2">
                  <span class="text-xs font-black uppercase tracking-tight text-text">{{ event.title }}</span>
                  <time class="text-[10px] font-black uppercase tracking-wider text-text-muted bg-surface px-2.5 py-1 rounded-lg border border-border">{{ event.date }}</time>
                </div>
                <p class="text-[11px] text-text-muted leading-relaxed font-medium italic">
                  {{ event.desc }}
                </p>
              </div>
            </li>
          </ol>
        </div>
      </section>

      <!-- Sección Steps y Accordion (Puro Tailwind) -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm md:col-span-2">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
          <!-- Steps -->
          <div>
            <h3 class="text-lg font-bold mb-6 text-primary border-b border-border pb-2">Steps (Nativo)</h3>
            <div class="flex flex-col gap-8 ml-4">
              <div v-for="(step, idx) in steps" :key="idx" class="flex gap-4 relative">
                <!-- Línea conectora -->
                <div v-if="idx < steps.length - 1" class="absolute left-4 top-10 w-0.5 h-6 bg-border"></div>
                
                <div 
                  class="w-8 h-8 rounded-full flex items-center justify-center shrink-0 border-2 transition-colors duration-500"
                  :class="idx <= activeStep ? 'bg-primary border-primary text-primary-fg' : 'bg-surface border-border text-text-muted'"
                >
                  <span class="text-xs font-bold">{{ idx + 1 }}</span>
                </div>
                <div>
                  <p class="text-sm font-bold transition-colors" :class="idx <= activeStep ? 'text-text' : 'text-text-muted'">{{ step.title }}</p>
                  <p class="text-xs text-text-muted">{{ step.desc }}</p>
                </div>
              </div>
            </div>
            <div class="mt-8 flex gap-2">
              <Button size="sm" variant="outline" @click="activeStep = Math.max(0, activeStep - 1)">Anterior</Button>
              <Button size="sm" variant="primary" @click="activeStep = Math.min(steps.length - 1, activeStep + 1)">Siguiente</Button>
            </div>
          </div>

          <!-- Accordion -->
          <div>
            <h3 class="text-lg font-bold mb-6 text-primary border-b border-border pb-2">Accordion (Nativo)</h3>
            <div class="space-y-3">
              <div 
                v-for="(item, idx) in accordionItems" 
                :key="idx"
                class="border border-border rounded-xl overflow-hidden transition-all"
                :class="{ 'shadow-theme-md bg-background/30': activeAccordion === idx }"
              >
                <button 
                  @click="activeAccordion = activeAccordion === idx ? null : idx"
                  class="w-full flex items-center justify-between p-4 text-left hover:bg-background/20 transition-colors"
                >
                  <span class="text-sm font-bold text-text">{{ item.title }}</span>
                  <component 
                    :is="BoxIcon" 
                    class="w-4 h-4 transition-transform duration-300"
                    :class="{ 'rotate-180': activeAccordion === idx }"
                  />
                </button>
                <div 
                  v-show="activeAccordion === idx"
                  class="p-4 border-t border-border bg-surface/50 text-xs text-text-muted animate-in slide-in-from-top-2 duration-300"
                >
                  <p>{{ item.content }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Sección Modals y Tooltips -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm md:col-span-2">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
          <!-- Modals Demo -->
          <div>
            <h3 class="text-lg font-bold mb-6 text-primary border-b border-border pb-2">Modals (BaseModal)</h3>
            <div class="flex flex-wrap gap-4">
              <Button variant="primary" @click="showModal = true">Abrir Modal Info</Button>
              <Button variant="outline" @click="showModalDanger = true">Abrir Modal Peligro</Button>
            </div>
          </div>

          <!-- Tooltips Demo -->
          <div>
            <h3 class="text-lg font-bold mb-6 text-primary border-b border-border pb-2">Tooltips (CSS Nativo)</h3>
            <div class="flex flex-wrap gap-6 pt-2">
              <div class="group relative inline-block">
                <Button variant="outline" size="sm">Hover Arriba</Button>
                <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-1.5 bg-black text-white text-[10px] rounded-lg opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap shadow-theme-lg z-50">
                  Este es un tooltip nativo
                  <!-- Triángulo -->
                  <div class="absolute top-full left-1/2 -translate-x-1/2 border-8 border-transparent border-t-black"></div>
                </div>
              </div>

              <div class="group relative inline-block">
                <Button variant="primary" size="sm">Hover Derecha</Button>
                <div class="absolute left-full top-1/2 -translate-y-1/2 ml-2 px-3 py-1.5 bg-primary text-primary-fg text-[10px] rounded-lg opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none whitespace-nowrap shadow-theme-lg z-50">
                   Información importante aquí
                  <div class="absolute right-full top-1/2 -translate-y-1/2 border-8 border-transparent border-r-primary"></div>
                </div>
              </div>
            </div>
            <p class="text-[10px] text-text-muted mt-4 italic">Implementados solo con Tailwind (group-hover/absolute).</p>
          </div>
        </div>
      </section>
    </div>

    <!-- Modals Host -->
    <BaseModal :show="showModal" @close="showModal = false" title="Guía de Estilos: Información">
      <div class="space-y-4">
        <p class="text-sm text-text-muted leading-relaxed">Este modal utiliza el componente `BaseModal` refactorizado para el sistema dinámico.</p>
        <Stat title="Impacto del Diseño" value="100%" description="Consistencia total" color="success" trend="up" />
        <div class="flex justify-end gap-2">
           <Button variant="outline" size="sm" @click="showModal = false">Entendido</Button>
        </div>
      </div>
    </BaseModal>

    <BaseModal :show="showModalDanger" @close="showModalDanger = false" variant="danger" title="¡Acción Crítica!">
       <div class="space-y-4">
        <p class="text-sm text-text-muted leading-relaxed">Los modales de peligro utilizan fondos rojos translúcidos y desenfoque de fondo para mayor énfasis visual.</p>
        <Alert variant="error" title="Cuidado" message="Esta acción no se puede deshacer en un entorno real." />
        <div class="flex justify-end gap-2 mt-6">
           <Button variant="outline" size="sm" @click="showModalDanger = false">Cerrar</Button>
           <Button variant="primary" size="sm" class="bg-error border-none text-error-fg hover:opacity-90">Proceder</Button>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useThemeStore, type ColorTheme } from '@/modules/shared/stores/theme.store'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
import Alert from '@/components/ui/Alert.vue'
import Stat from '@/components/common/Stat.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import MultipleSelect from '@/components/forms/FormElements/MultipleSelect.vue'
import Dropzone from '@/components/forms/FormElements/Dropzone.vue'
import { BoxIcon, CalenderIcon, CheckIcon, DocsIcon, ChatIcon } from '@/icons'
import { SunIcon, MoonIcon } from 'lucide-vue-next'

const themeStore = useThemeStore()

const colors: { id: ColorTheme; name: string }[] = [
    { id: 'blue', name: 'Azul (Base)' },
    { id: 'green', name: 'Verde (Formal)' },
    { id: 'orange', name: 'Naranja (Fun)' }
]

// Estado para componentes demo
const searchText = ref('')
const selectValue = ref(null)
const dateValue = ref(new Date().toISOString())
const multiSelected = ref([])
const activeStep = ref(1)
const activeAccordion = ref<number | null>(0)
const showModal = ref(false)
const showModalDanger = ref(false)

const demoOptions = [
    { value: 1, label: 'Panel Operativo' },
    { value: 2, label: 'Lista de Mareas' },
    { value: 3, label: 'Exportación de Datos' },
    { value: 4, label: 'Configuración de Sistema' },
]

const multiOptions = [
    { value: 'observadores', label: 'Observadores' },
    { value: 'mareas', label: 'Mareas' },
    { value: 'buques', label: 'Buques' },
    { value: 'especies', label: 'Especies' },
]

const timelineEvents = [
  { title: 'Detección de Alerta', date: 'Hace 2h', desc: 'Se detectó una inconsistencia en la marea M-023.', icon: DocsIcon },
  { title: 'Asignación Técnica', date: 'Hace 1h', desc: 'El supervisor asignó el caso a un revisor técnico.', icon: ChatIcon },
  { title: 'Resolución Parcial', date: 'Ahora', desc: 'Se cargaron las notas de descargo iniciales.', icon: CheckIcon },
]

const steps = [
  { title: 'Configuración', desc: 'Ajuste inicial de parámetros' },
  { title: 'Validación', desc: 'Revisión técnica de datos' },
  { title: 'Publicación', desc: 'Envío a base central' },
]

const accordionItems = [
  { title: '¿Cómo funciona el tema dinámico?', content: 'Utiliza variables CSS inyectadas por el ThemeProvider que Tailwind v4 consume directamente.' },
  { title: '¿Es compatible con el modo oscuro?', content: 'Sí, todos los colores semánticos tienen su variante oscura definida para una transición suave.' },
]
</script>
