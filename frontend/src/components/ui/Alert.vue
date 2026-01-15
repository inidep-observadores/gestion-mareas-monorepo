<template>
  <div :class="['rounded-xl border p-4', variantClasses[variant].container]">
    <div class="flex items-start gap-3">
      <div :class="['-mt-0.5', variantClasses[variant].icon]">
        <component :is="icons[variant]" />
      </div>

      <div>
        <h4 class="mb-1 text-sm font-semibold text-text">
          {{ title }}
        </h4>

        <p class="text-sm text-text-muted">{{ message }}</p>

        <router-link
          v-if="showLink"
          :to="linkHref"
          class="inline-block mt-3 text-sm font-medium text-primary hover:underline transition-all"
        >
          {{ linkText }}
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { SuccessIcon, ErrorIcon, WarningIcon, InfoCircleIcon } from '@/icons'
import { computed } from 'vue'

interface AlertProps {
  variant: 'success' | 'error' | 'warning' | 'info'
  title: string
  message: string
  showLink?: boolean
  linkHref?: string
  linkText?: string
}

const props = withDefaults(defineProps<AlertProps>(), {
  showLink: false,
  linkHref: '#',
  linkText: 'Ver más',
})

const variantClasses = {
  success: {
    container: 'border-green-500 bg-green-500/10 dark:border-green-500/30 dark:bg-green-500/15',
    icon: 'text-green-600',
  },
  error: {
    container: 'border-red-500 bg-red-500/10 dark:border-red-500/30 dark:bg-red-500/15',
    icon: 'text-red-600',
  },
  warning: {
    container: 'border-orange-500 bg-orange-500/10 dark:border-orange-500/30 dark:bg-orange-500/15',
    icon: 'text-orange-600',
  },
  info: {
    container: 'border-primary bg-primary/10 dark:border-primary/30 dark:bg-primary/15',
    icon: 'text-primary',
  },
}

const icons = {
  success: SuccessIcon,
  error: ErrorIcon,
  warning: WarningIcon,
  info: InfoCircleIcon,
}
</script>
