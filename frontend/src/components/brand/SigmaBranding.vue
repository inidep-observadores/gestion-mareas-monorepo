<script setup lang="ts">
import { computed } from 'vue';
import SigmaLogo from './SigmaLogo.vue';

interface Props {
  variant?: 'landing' | 'auth' | 'sidebar' | 'simple';
  title?: string;
  subtitle?: string;
  theme?: 'light' | 'dark';
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'auth',
  theme: 'light'
});

// Computed properties for styling based on variant
const logoSize = computed(() => {
  switch (props.variant) {
    case 'landing': return '64px';
    case 'sidebar': return '32px';
    case 'simple': return '40px';
    case 'auth':
    default: return '80px';
  }
});

const logoTheme = computed(() => {
  // Always force dark theme for logo inside the dark container to ensure glow visibility
  return 'dark';
});

const titleSizeClass = computed(() => {
  switch (props.variant) {
    case 'landing': return 'text-4xl sm:text-5xl';
    case 'sidebar': return 'text-lg';
    case 'simple': return 'text-xl';
    case 'auth':
    default: return 'text-2xl';
  }
});

const subtitleSizeClass = computed(() => {
  switch (props.variant) {
    case 'landing': return 'text-lg sm:text-xl';
    case 'sidebar': return 'text-xs';
    case 'simple': return 'text-sm';
    case 'auth':
    default: return 'text-sm';
  }
});

const brandNameSize = computed(() => {
   switch (props.variant) {
    case 'landing': return 'text-3xl';
    case 'sidebar': return 'text-sm';
    case 'simple': return 'text-lg';
    case 'auth':
    default: return 'text-xl';
  }
});
</script>

<template>
  <div :class="['flex items-center gap-5', $attrs.class]">
    <!-- Logo Container: Visible ONLY in Light Mode -->
    <div v-if="theme === 'light'" class="relative flex items-center justify-center p-4 rounded-[2rem] bg-slate-900/90 backdrop-blur-xl border border-white/10 shadow-2xl shadow-black/20 flex-shrink-0 animate-fade-in">
      <SigmaLogo theme="dark" :width="logoSize" />
    </div>

    <!-- Logo without Container: Visible in Dark Mode -->
    <div v-else class="flex-shrink-0 animate-fade-in">
       <SigmaLogo theme="dark" :width="logoSize" />
    </div>
    
    <div class="flex flex-col">
      <h1
        v-if="title"
        class="font-black tracking-tight text-text leading-tight"
        :class="titleSizeClass"
      >
        {{ title }}
      </h1>
      <h1 v-else class="flex flex-col leading-none">
        <span class="font-black tracking-tighter text-text uppercase" :class="brandNameSize">Gestión de</span>
        <span class="font-black tracking-tighter text-primary uppercase" :class="brandNameSize">Mareas</span>
      </h1>

      <p
        v-if="subtitle"
        class="text-text-muted font-medium"
        :class="subtitleSizeClass"
      >
        {{ subtitle }}
      </p>
    </div>
  </div>
</template>

<style scoped>
.sigma-branding {
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
}

.text-wrapper {
  display: flex;
  flex-direction: column;
  text-align: left;
}

.branding-title {
  margin: 0;
  font-weight: 700;
  line-height: 1;
}

.branding-subtitle {
  margin: 0;
  font-weight: 500;
  text-transform: uppercase;
}

/* --- VARIANT: AUTH --- */
.branding-auth {
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.branding-auth .branding-title {
  font-size: 1.75rem;
  margin-bottom: 0.25rem;
  /* Gradiente sutil usando colores semánticos de texto */
  background: linear-gradient(to right, var(--color-text), var(--color-text-muted));
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
}

.branding-auth .branding-subtitle {
  font-size: 0.85rem;
  line-height: 1.4;
  text-transform: none;
  color: var(--color-text-muted);
}

/* --- VARIANT: SIDEBAR --- */
.branding-sidebar {
  gap: 0.75rem;
}

.branding-sidebar .branding-title {
  font-size: 1.25rem;
  font-weight: 900;
  letter-spacing: -0.05em;
  color: var(--color-text);
}

.branding-sidebar .branding-subtitle {
  font-size: 9px;
  letter-spacing: 0.1em;
  color: var(--color-text-muted);
  margin-top: 2px;
}
</style>
