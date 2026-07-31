<template>
  <router-link 
    :to="to"
    class="group relative overflow-hidden bg-surface rounded-3xl border-2 border-border p-6 transition-all duration-300 hover:border-info/50 hover:shadow-xl hover:shadow-info/5 hover:-translate-y-1"
  >
    <!-- Background Gradient Accent -->
    <div 
      class="absolute top-0 right-0 -mr-16 -mt-16 w-32 h-32 rounded-full blur-3xl opacity-0 transition-opacity duration-300 group-hover:opacity-20"
      :class="gradientClass"
    ></div>

    <div class="relative z-10 space-y-4">
      <!-- Icon Wrapper -->
      <div 
        class="inline-flex p-3 rounded-2xl transition-colors duration-300"
        :class="iconWrapperClass"
      >
        <component :is="icon" class="w-6 h-6" />
      </div>

      <!-- Content -->
      <div>
        <h3 class="text-lg font-bold text-text group-hover:text-info transition-colors duration-300">
          {{ title }}
        </h3>
        <p class="mt-1 text-sm text-text-muted leading-relaxed">
          {{ description }}
        </p>
      </div>

      <!-- Footer Action -->
      <div class="pt-2 flex items-center text-xs font-bold uppercase tracking-widest text-info opacity-0 -translate-x-2 transition-all duration-300 group-hover:opacity-100 group-hover:translate-x-0">
        <span>Acceder ahora</span>
        <svg class="w-4 h-4 ml-2 transition-transform duration-300 group-hover:translate-x-1" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
        </svg>
      </div>
    </div>
  </router-link>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  title: string;
  description: string;
  to: any;
  icon: any;
  color?: 'primary' | 'info' | 'warning' | 'success' | 'error';
}

const props = withDefaults(defineProps<Props>(), {
  color: 'info'
});

const gradientClass = computed(() => {
  const bgColors = {
    primary: 'bg-primary',
    info: 'bg-info',
    warning: 'bg-warning',
    success: 'bg-success',
    error: 'bg-error'
  };
  return bgColors[props.color];
});

const iconWrapperClass = computed(() => {
  const classes = {
    primary: 'bg-primary/10 text-primary group-hover:bg-primary group-hover:text-white',
    info: 'bg-info/10 text-info group-hover:bg-info group-hover:text-white',
    warning: 'bg-warning/10 text-warning group-hover:bg-warning group-hover:text-white',
    success: 'bg-success/10 text-success group-hover:bg-success group-hover:text-white',
    error: 'bg-error/10 text-error group-hover:bg-error group-hover:text-white'
  };
  return classes[props.color];
});
</script>
