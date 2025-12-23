<script setup lang="ts">
import { computed } from 'vue';
import SigmaLogo from './SigmaLogo.vue';

interface Props {
  variant?: 'landing' | 'auth' | 'sidebar';
  title?: string;
  subtitle?: string;
  logoWidth?: string;
  theme?: 'light' | 'dark';
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'auth',
  title: 'SIGMA',
  subtitle: 'SISTEMA DE GESTIÓN DE MAREAS'
});

const containerClass = computed(() => {
  return {
    'landing': 'branding-landing',
    'auth': 'branding-auth',
    'sidebar': 'branding-sidebar'
  }[props.variant];
});

const defaultLogoWidth = computed(() => {
  if (props.logoWidth) return props.logoWidth;
  return {
    'landing': '240px',
    'auth': '80px',
    'sidebar': '44px'
  }[props.variant];
});

const derivedLogoTheme = computed(() => {
  if (props.theme) return props.theme;
  // Por defecto, la barra lateral usa tema claro
  if (props.variant === 'sidebar') return 'light';
  return 'dark';
});
</script>

<template>
  <div :class="['sigma-branding', containerClass]">
    <SigmaLogo :width="defaultLogoWidth" :theme="derivedLogoTheme" />
    <div class="text-wrapper">
      <h1 class="branding-title">{{ title }}</h1>
      <p class="branding-subtitle">{{ subtitle }}</p>
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
  color: #94a3b8;
  font-weight: 500;
  text-transform: uppercase;
}

/* --- VARIANT: LANDING --- */
.branding-landing {
  flex-direction: row;
  justify-content: center;
  gap: 2rem;
}

.branding-landing .text-wrapper {
  align-items: center;
  text-align: center;
}

.branding-landing .branding-title {
  font-size: 3rem;
  letter-spacing: 0.5rem;
  font-weight: 100;
  transition: all 0.8s ease;
  /* Extra safety to ensure the box itself doesn't show */
  background-origin: border-box;
}

/* Landing Dark */
.theme-dark .branding-landing .branding-title {
  background: linear-gradient(to bottom, #ffffff, #85e8ff);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
  /* Use filter drop-shadow instead of text-shadow for clipped backgrounds */
  filter: drop-shadow(0 0 10px rgba(0, 242, 255, 0.4));
}

/* Landing Light */
.theme-light .branding-landing .branding-title {
  background: linear-gradient(to bottom, #1e40af, #3b82f6);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
}

.branding-landing .branding-subtitle {
  font-size: 0.75rem;
  letter-spacing: 0.2rem;
  margin-top: 0.5rem;
  transition: color 0.8s ease;
}

.theme-dark .branding-landing .branding-subtitle {
  color: #a0aec0;
}

.theme-light .branding-landing .branding-subtitle {
  color: #64748b;
}

@media (min-width: 768px) {
  .branding-landing .branding-title {
    font-size: 6rem;
    letter-spacing: 1rem;
  }
  .branding-landing .branding-subtitle {
    font-size: 0.9rem;
    letter-spacing: 0.4rem;
  }
}

@media (max-width: 768px) {
  .branding-landing {
    flex-direction: column;
    text-align: center;
    gap: 1rem;
  }
  .branding-landing .text-wrapper {
    align-items: center;
  }
}

/* --- VARIANT: AUTH --- */
.branding-auth {
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.branding-auth .branding-title {
  font-size: 1.75rem;
  margin-bottom: 0.25rem;
  transition: all 0.8s ease;
}

.theme-dark .branding-auth .branding-title {
  background: linear-gradient(to right, #f8fafc, #cbd5e1);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
}

.theme-light .branding-auth .branding-title {
  background: linear-gradient(to right, #0f172a, #334155);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
}

.branding-auth .branding-subtitle {
  font-size: 0.85rem;
  line-height: 1.4;
  text-transform: none;
  transition: color 0.8s ease;
}

.theme-dark .branding-auth .branding-subtitle {
  color: #94a3b8;
}

.theme-light .branding-auth .branding-subtitle {
  color: #64748b;
}

/* --- VARIANT: SIDEBAR --- */
.branding-sidebar {
  gap: 0.75rem;
}

.branding-sidebar .branding-title {
  font-size: 1.25rem;
  font-weight: 900;
  letter-spacing: -0.05em;
  color: #0f172a; /* Slate 900 */
}

.branding-sidebar .branding-subtitle {
  font-size: 9px;
  letter-spacing: 0.1em;
  color: #64748b; /* Slate 500 */
  margin-top: 2px;
}
</style>
