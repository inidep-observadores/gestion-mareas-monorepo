<template>
  <button
    @click="$emit('click')"
    class="flex items-center gap-2.5 px-4 py-2 rounded-full border transition-all duration-300 active:scale-95 group relative overflow-hidden"
    :class="[
      !active
        ? 'bg-gray-50/30 border-gray-100 text-gray-400 dark:bg-gray-800/10 dark:border-gray-800 dark:text-gray-700'
        : `bg-white dark:bg-gray-900 shadow-sm hover:shadow-md ${borderClass}`
    ]"
  >
    <!-- Bullet indicador -->
    <div 
      class="w-1.5 h-1.5 rounded-full transition-all duration-300"
      :class="[!active ? 'bg-gray-300 dark:bg-gray-700' : colorClass.replace('text-', 'bg-')] "
    ></div>

    <div class="flex items-center gap-2">
      <component 
        :is="icon" 
        class="w-4 h-4 transition-colors" 
        :class="[!active ? 'text-gray-300 dark:text-gray-700' : colorClass]" 
      />
      <span 
        class="text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-colors"
        :class="[!active ? 'text-gray-400 dark:text-gray-600' : 'text-gray-800 dark:text-gray-100']"
      >
        {{ label }}
      </span>
    </div>

    <!-- Badge de valor -->
    <div 
      class="ml-2 px-2 py-0.5 rounded-md text-[10px] font-black transition-all"
      :class="[
          !active 
          ? 'bg-gray-100 text-gray-400 dark:bg-gray-800 dark:text-gray-700' 
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
