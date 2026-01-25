<script setup lang="ts">
import { ShieldAlert, Activity, Lock, Search, Filter } from 'lucide-vue-next';
</script>

<template>
  <div class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
    <!-- Header Section -->
    <div class="flex items-end justify-between">
      <div>
        <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">Panel de Auditoría</h1>
        <p class="text-slate-500 mt-2 font-medium">Monitoreo técnico y trazabilidad del sistema.</p>
      </div>
      
      <div class="flex space-x-3">
        <button class="flex items-center space-x-2 px-4 py-2 bg-white border border-slate-200 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-all shadow-sm">
          <Filter :size="16" />
          <span>Filtrar</span>
        </button>
        <button class="flex items-center space-x-2 px-4 py-2 bg-slate-900 text-white rounded-xl text-sm font-semibold hover:bg-slate-800 transition-all shadow-lg shadow-slate-200">
          <Search :size="16" />
          <span>Buscar Log</span>
        </button>
      </div>
    </div>

    <!-- Stats Table/Overview Mockup -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm">
        <div class="flex items-center space-x-3 text-amber-600 mb-4">
          <div class="p-2 bg-amber-50 rounded-lg">
            <Lock :size="20" />
          </div>
          <span class="text-xs font-bold uppercase tracking-wider">Accesos</span>
        </div>
        <div class="text-2xl font-bold text-slate-900">1,240</div>
        <div class="text-xs text-slate-400 mt-1">Intentos registrados hoy</div>
      </div>

      <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm">
        <div class="flex items-center space-x-3 text-blue-600 mb-4">
          <div class="p-2 bg-blue-50 rounded-lg">
            <Activity :size="20" />
          </div>
          <span class="text-xs font-bold uppercase tracking-wider">Actividad</span>
        </div>
        <div class="text-2xl font-bold text-slate-900">458</div>
        <div class="text-xs text-slate-400 mt-1">Eventos críticos en 24h</div>
      </div>

      <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm">
        <div class="flex items-center space-x-3 text-rose-600 mb-4">
          <div class="p-2 bg-rose-50 rounded-lg">
            <ShieldAlert :size="20" />
          </div>
          <span class="text-xs font-bold uppercase tracking-wider">Alertas</span>
        </div>
        <div class="text-2xl font-bold text-slate-900">12</div>
        <div class="text-xs text-slate-400 mt-1">Requieren revisión inmediata</div>
      </div>
    </div>

    <!-- Log Table Placeholder -->
    <div class="bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden">
      <div class="p-6 border-b border-slate-50 flex items-center justify-between">
        <h3 class="font-bold text-slate-900 text-lg">Registro de Actividad Reciente</h3>
        <span class="px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-[10px] font-bold uppercase">En Vivo</span>
      </div>
      
      <div class="p-12 flex flex-col items-center justify-center text-center">
        <div class="w-16 h-16 bg-slate-50 rounded-full flex items-center justify-center text-slate-300 mb-4">
          <ShieldAlert :size="32" />
        </div>
        <h4 class="text-slate-900 font-bold mb-1">Módulo en Desarrollo</h4>
        <p class="text-slate-500 text-sm max-w-xs mx-auto">
          El motor de auditoría técnica está siendo configurado. Próximamente podrá visualizar aquí la trazabilidad completa.
        </p>
      </div>
    </div>
  </div>
</template>
