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
            <p class="text-xs font-medium text-text-muted uppercase mb-3 text-text">Variante Primary</p>
            <div class="flex flex-wrap gap-3">
              <Button variant="primary" size="sm">Pequeño</Button>
              <Button variant="primary">Mediano (Base)</Button>
              <Button variant="primary" :disabled="true">Desactivado</Button>
            </div>
          </div>
          <div>
            <p class="text-xs font-medium text-text-muted uppercase mb-3 text-text">Variante Outline</p>
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
            <p class="text-xs font-medium text-text-muted uppercase mb-3 text-text">Identidad (Primary)</p>
            <div class="flex flex-wrap gap-3">
              <Badge color="primary" variant="solid">Solid Primary</Badge>
              <Badge color="primary" variant="light">Light Primary</Badge>
            </div>
          </div>
          <div>
            <p class="text-xs font-medium text-text-muted uppercase mb-3 text-text">Otros Estados (FlyonUI compatible)</p>
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
                <p class="text-sm font-semibold uppercase text-text-muted mb-4 text-text">Vista en un Contenedor Gris</p>
                <div class="bg-surface p-4 rounded-lg border border-border shadow-sm">
                    <p class="text-text font-medium text-text">Card Interno</p>
                    <p class="text-sm text-text-muted text-text">Los bordes se redondean más en el tema naranja.</p>
                </div>
            </div>
         </div>
      </section>

      <!-- Sección Componentes Avanzados -->
      <section class="bg-surface border border-border p-6 rounded-2xl shadow-sm md:col-span-2">
        <h3 class="text-lg font-bold mb-4 text-primary border-b border-border pb-2">Componentes Personalizados (Semánticos)</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <!-- Search Input -->
          <div class="space-y-3">
            <p class="text-xs font-bold text-text-muted uppercase tracking-wider">Búsqueda Dinámica</p>
            <SearchInput v-model="searchText" placeholder="Buscar algo..." />
            <p class="text-[10px] text-text-muted italic">Escribe para probar el botón de limpiar.</p>
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
            <p class="text-[10px] text-text-muted italic">Prueba el dropdown con scroll y hover semántico.</p>
          </div>

          <!-- Date Picker -->
          <div class="space-y-3">
            <p class="text-xs font-bold text-text-muted uppercase tracking-wider">Selector de Fecha</p>
            <DatePicker v-model="dateValue" placeholder="Elegir fecha" :icon="CalenderIcon" />
            <p class="text-[10px] text-text-muted italic">Verifica el calendario y colores de selección.</p>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useThemeStore, type ColorTheme } from '@/modules/shared/stores/theme.store'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import { BoxIcon, CalenderIcon } from '@/icons'
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

const demoOptions = [
    { value: 1, label: 'Panel Operativo' },
    { value: 2, label: 'Lista de Mareas' },
    { value: 3, label: 'Exportación de Datos' },
    { value: 4, label: 'Configuración de Sistema' },
]
</script>
