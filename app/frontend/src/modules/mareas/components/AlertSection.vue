<template>
  <div class="space-y-3">
    <div class="flex items-center justify-between px-1">
      <h3 class="text-sm font-bold text-text flex items-center gap-2">
        <span class="relative flex h-2 w-2">
          <span
            class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error/40 opacity-75"
          ></span>
          <span class="relative inline-flex rounded-full h-2 w-2 bg-error"></span>
        </span>
        Alertas de Gestión
      </h3>
      <span
        class="text-[10px] bg-error/10 text-error px-2 py-0.5 rounded-full font-bold uppercase tracking-wider"
      >
        {{ alerts.length }} ACTIVAS
      </span>
    </div>

    <div
      v-for="alert in alerts"
      :key="alert.id"
      class="group relative bg-surface border-l-4 border-l-error border border-border p-4 rounded-r-xl shadow-sm hover:shadow-md transition-all cursor-pointer"
    >
      <div class="flex gap-4">
        <div class="mt-1">
          <div
            :class="[
              'p-2 rounded-lg',
              alert.type === 'delay'
                ? 'bg-error/10 text-error'
                : 'bg-warning/10 text-warning',
            ]"
          >
            <svg
              v-if="alert.type === 'delay'"
              xmlns="http://www.w3.org/2000/svg"
              class="w-5 h-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            <svg
              v-else
              xmlns="http://www.w3.org/2000/svg"
              class="w-5 h-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
              />
            </svg>
          </div>
        </div>
        <div class="flex-1">
          <h4 class="text-sm font-bold text-text leading-tight mb-1">
            {{ alert.title }}
          </h4>
          <p class="text-xs text-text-muted">
            {{ alert.message }}
          </p>
          <div class="mt-2 flex items-center justify-between">
            <span class="text-[10px] font-bold text-text-muted uppercase tracking-wider opacity-60">
              {{ alert.time }}
            </span>
            <button
              class="text-[10px] font-black text-primary opacity-0 group-hover:opacity-100 transition-opacity uppercase tracking-widest"
            >
              ATENDER AHORA →
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const alerts = [
  {
    id: 1,
    type: 'delay',
    title: 'Marea 2025-042 Retrasada',
    message: 'Lleva 15 días en estado "Revisión" sin avances detectados.',
    time: 'Hace 2 horas',
  },
  {
    id: 2,
    type: 'limit',
    title: 'Límite de Días: Carlos R.',
    message: 'El observador superó los 200 días de mar anuales (Actual: 205).',
    time: 'Hace 5 horas',
  },
]
</script>
