<template>
  <button
    @click="$emit('click')"
    class="flex items-center gap-2.5 px-4 py-2 rounded-full border transition-all duration-300 active:scale-95 group relative overflow-hidden"
    :class="[
      !active
        ? 'bg-surface-muted/30 border-border text-text-muted/60'
        : `bg-surface shadow-sm hover:shadow-md ${borderClass}`
    ]"
  >
    <!-- Bullet indicador -->
    <div 
      class="w-1.5 h-1.5 rounded-full transition-all duration-300"
      :class="[!active ? 'bg-border' : colorClass.replace('text-', 'bg-')] "
    ></div>

    <div class="flex items-center gap-2">
      <component 
        :is="icon" 
        class="w-4 h-4 transition-colors" 
        :class="[!active ? 'text-text-muted/40' : colorClass]" 
      />
      <span 
        class="text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-colors"
        :class="[!active ? 'text-text-muted/60' : 'text-text']"
      >
        {{ label }}
      </span>
    </div>

    <!-- Badge de valor -->
    <div 
      class="ml-2 px-2 py-0.5 rounded-md text-[10px] font-black transition-all"
      :class="[
          !active 
          ? 'bg-surface-muted text-text-muted/50' 
          : `${bgClass} ${colorClass}`
      ]"
    >
      {{ value }}
    </div>
  </button>
</template>

<script setup lang="ts">
defineProps<{
  label: string
  value: number | string
  icon: any
  active: boolean
  colorClass: string
  bgClass: string
  borderClass: string
}>()

defineEmits(['click'])
</script>
