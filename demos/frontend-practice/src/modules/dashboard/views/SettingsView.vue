<script setup lang="ts">
import { ref, inject } from 'vue';
import { Settings, User, Bell, Shield, Palette, Database, Sun, Moon, Monitor } from 'lucide-vue-next';

const { activeTheme, themePreference, setTheme } = inject('theme') as any;
const activeTab = ref('Perfil');

const tabs = [
  { name: 'Perfil', icon: User },
  { name: 'Notificaciones', icon: Bell },
  { name: 'Seguridad', icon: Shield },
  { name: 'Apariencia', icon: Palette },
  { name: 'Base de Datos', icon: Database },
];
</script>

<template>
  <div class="max-w-4xl space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
    <!-- Header Section -->
    <div>
      <h1 class="text-3xl font-extrabold text-slate-900 dark:text-white tracking-tight">Configuración del Sistema</h1>
      <p class="text-slate-500 dark:text-slate-400 mt-2 font-medium">Gestione sus preferencias y parámetros institucionales.</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
      <!-- Navigation Menu -->
      <div class="space-y-2">
        <button v-for="tab in tabs" 
          :key="tab.name"
          @click="activeTab = tab.name"
          :class="['w-full text-left px-5 py-3 rounded-2xl font-bold transition-all flex items-center gap-3', 
                  activeTab === tab.name 
                    ? 'bg-slate-900 text-white shadow-lg shadow-slate-200 dark:shadow-none dark:bg-blue-600' 
                    : 'text-slate-500 hover:bg-slate-50 dark:hover:bg-slate-800']"
        >
          <component :is="tab.icon" :size="20" />
          {{ tab.name }}
        </button>
      </div>

      <!-- Settings Content -->
      <div class="md:col-span-2 space-y-6">
        <!-- Content for 'Perfil' (Mockup original) -->
        <div v-if="activeTab === 'Perfil'" class="bg-white dark:bg-slate-900 p-8 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm space-y-8 transition-colors">
          <div class="flex items-center space-x-6 pb-6 border-b border-slate-50 dark:border-slate-800">
            <div class="w-20 h-20 bg-blue-50 dark:bg-blue-900/30 rounded-2xl flex items-center justify-center text-blue-600 dark:text-blue-400 text-3xl font-black">
              US
            </div>
            <div>
              <h3 class="text-xl font-bold text-slate-900 dark:text-white">Usuario Sistema</h3>
              <p class="text-slate-400 font-medium">Configuración de cuenta institucional</p>
              <button class="mt-3 text-xs font-bold text-blue-600 dark:text-blue-400 hover:underline px-0 bg-transparent border-none cursor-pointer">Cambiar Foto</button>
            </div>
          </div>

          <div class="space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div class="space-y-2">
                <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest pl-1">Nombre Completo</label>
                <input type="text" disabled placeholder="Administrador Sistema" class="w-full bg-slate-50 dark:bg-slate-800 border-none rounded-xl px-4 py-3 text-sm font-semibold text-slate-600 dark:text-slate-300">
              </div>
              <div class="space-y-2">
                <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest pl-1">Correo Electrónico</label>
                <input type="email" disabled placeholder="admin@obs.com" class="w-full bg-slate-50 dark:bg-slate-800 border-none rounded-xl px-4 py-3 text-sm font-semibold text-slate-600 dark:text-slate-300">
              </div>
            </div>

            <div class="pt-6">
              <button class="bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-white px-6 py-3 rounded-xl font-bold text-sm hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors border-none cursor-pointer">
                Editar Información
              </button>
            </div>
          </div>
        </div>

        <!-- Content for 'Apariencia' (Funcional) -->
        <div v-if="activeTab === 'Apariencia'" class="bg-white dark:bg-slate-900 p-8 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm space-y-8 transition-colors">
          <div>
            <h3 class="text-xl font-bold text-slate-900 dark:text-white">Tema de la Aplicación</h3>
            <p class="text-slate-500 dark:text-slate-400 mt-1 font-medium">Elija cómo prefiere ver la interfaz de SIGMA.</p>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <button 
              @click="setTheme('light')"
              :class="['flex flex-col items-center gap-4 p-6 rounded-2xl border-2 transition-all', 
                      themePreference === 'light' ? 'border-blue-500 bg-blue-50/50 dark:bg-blue-900/20' : 'border-slate-100 dark:border-slate-800 hover:border-slate-200 dark:hover:border-slate-700 bg-transparent']"
            >
              <div class="p-3 bg-white dark:bg-slate-800 rounded-xl shadow-sm">
                <Sun :size="24" class="text-amber-500" />
              </div>
              <span class="font-bold text-slate-900 dark:text-white">Claro</span>
            </button>

            <button 
              @click="setTheme('dark')"
              :class="['flex flex-col items-center gap-4 p-6 rounded-2xl border-2 transition-all', 
                      themePreference === 'dark' ? 'border-blue-500 bg-blue-50/50 dark:bg-blue-900/20' : 'border-slate-100 dark:border-slate-800 hover:border-slate-200 dark:hover:border-slate-700 bg-transparent']"
            >
              <div class="p-3 bg-white dark:bg-slate-800 rounded-xl shadow-sm">
                <Moon :size="24" class="text-blue-600 dark:text-blue-400" />
              </div>
              <span class="font-bold text-slate-900 dark:text-white">Oscuro</span>
            </button>

            <button 
              @click="setTheme('system')"
              :class="['flex flex-col items-center gap-4 p-6 rounded-2xl border-2 transition-all', 
                      themePreference === 'system' ? 'border-blue-500 bg-blue-50/50 dark:bg-blue-900/20' : 'border-slate-100 dark:border-slate-800 hover:border-slate-200 dark:hover:border-slate-700 bg-transparent']"
            >
              <div class="p-3 bg-white dark:bg-slate-800 rounded-xl shadow-sm">
                <Monitor :size="24" class="text-slate-600 dark:text-slate-400" />
              </div>
              <span class="font-bold text-slate-900 dark:text-white">Sistema</span>
            </button>
          </div>

          <div class="p-4 bg-slate-50 dark:bg-slate-800/50 rounded-2xl">
            <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
              <strong>Nota:</strong> El modo sistema sincroniza automáticamente la apariencia con la configuración de su dispositivo. Las animaciones de fondo (Cielo Diurno/Estrellado) se activarán en las pantallas de inicio y autenticación.
            </p>
          </div>
        </div>

        <div v-if="activeTab === 'Perfil'" class="bg-amber-50/50 dark:bg-amber-900/20 border border-amber-100 dark:border-amber-900/40 p-6 rounded-3xl">
          <div class="flex items-start gap-4">
            <Shield class="text-amber-600 dark:text-amber-400 mt-1" :size="20" />
            <div>
              <h4 class="text-amber-900 dark:text-amber-200 font-bold mb-1">Zona de Seguridad</h4>
              <p class="text-amber-700/80 dark:text-amber-400/80 text-sm leading-relaxed">
                Usted tiene privilegios de administración. Los cambios en los parámetros del motor de mareas requieren una validación de dos pasos.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
