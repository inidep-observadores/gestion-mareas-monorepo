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
    container: 'border-success bg-success/10 dark:border-success/30 dark:bg-success/15',
    icon: 'text-success',
  },
  error: {
    container: 'border-error bg-error/10 dark:border-error/30 dark:bg-error/15',
    icon: 'text-error',
  },
  warning: {
    container: 'border-warning bg-warning/10 dark:border-warning/30 dark:bg-warning/15',
    icon: 'text-warning',
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
