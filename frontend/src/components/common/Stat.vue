<template>
  <div class="stat" :class="statClasses">
    <!-- Icon/Avatar -->
    <div v-if="icon || avatar" class="stat-figure" :class="figureClasses">
      <component v-if="icon" :is="icon" :class="iconClasses" />
      <Avatar v-else-if="avatar" v-bind="avatar" />
    </div>

    <!-- Content -->
    <div class="stat-content">
      <div v-if="title" class="stat-title" :class="titleClasses">
        {{ title }}
      </div>
      <div class="stat-value" :class="valueClasses">
        {{ value }}
      </div>
      <div v-if="description" class="stat-desc" :class="descClasses">
        {{ description }}
      </div>

      <!-- Progress bar -->
      <div v-if="progress !== undefined" class="stat-progress mt-2">
        <div class="progress" :class="progressContainerClasses">
          <div
            class="progress-bar"
            :class="progressBarClasses"
            :style="{ width: `${progress}%` }"
            role="progressbar"
            :aria-valuenow="progress"
            aria-valuemin="0"
            aria-valuemax="100"
          ></div>
        </div>
      </div>

      <!-- Actions -->
      <div v-if="$slots.actions" class="stat-actions mt-3">
        <slot name="actions"></slot>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, type Component } from 'vue'
import Avatar from './Avatar.vue'
import type { AvatarProps } from './Avatar.vue'

export interface StatProps {
  title?: string
  value: string | number
  description?: string
  icon?: Component
  avatar?: AvatarProps
  variant?: 'default' | 'bordered' | 'filled'
  color?: 'primary' | 'secondary' | 'success' | 'error' | 'warning' | 'info'
  size?: 'sm' | 'md' | 'lg'
  progress?: number
  progressColor?: 'primary' | 'secondary' | 'success' | 'error' | 'warning' | 'info'
  trend?: 'up' | 'down' | 'neutral'
}

const props = withDefaults(defineProps<StatProps>(), {
  variant: 'default',
  color: 'primary',
  size: 'md',
  trend: 'neutral',
  progressColor: 'primary',
})

const statClasses = computed(() => {
  const classes: string[] = []

  if (props.variant === 'bordered') {
    classes.push('border border-gray-200 dark:border-gray-800 rounded-2xl p-6')
  } else if (props.variant === 'filled') {
    const colorMap = {
      primary: 'bg-brand-50 dark:bg-brand-900/20',
      secondary: 'bg-gray-50 dark:bg-gray-900/20',
      success: 'bg-success-50 dark:bg-success-900/20',
      error: 'bg-error-50 dark:bg-error-900/20',
      warning: 'bg-warning-50 dark:bg-warning-900/20',
      info: 'bg-info-50 dark:bg-info-900/20',
    }
    classes.push(colorMap[props.color], 'rounded-2xl p-6')
  }

  return classes.join(' ')
})

const figureClasses = computed(() => {
  const colorMap = {
    primary: 'text-brand-500',
    secondary: 'text-gray-500',
    success: 'text-success-500',
    error: 'text-error-500',
    warning: 'text-warning-500',
    info: 'text-info-500',
  }
  return colorMap[props.color]
})

const iconClasses = computed(() => {
  const sizeMap = {
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-12 h-12',
  }
  return sizeMap[props.size]
})

const titleClasses = computed(() => {
  return 'text-gray-500 dark:text-gray-400'
})

const valueClasses = computed(() => {
  const sizeMap = {
    sm: 'text-2xl',
    md: 'text-3xl',
    lg: 'text-4xl',
  }
  const trendMap = {
    up: 'text-success-600 dark:text-success-400',
    down: 'text-error-600 dark:text-error-400',
    neutral: 'text-gray-800 dark:text-white',
  }
  return `${sizeMap[props.size]} font-bold ${trendMap[props.trend]}`
})

const descClasses = computed(() => {
  const trendMap = {
    up: 'text-success-600 dark:text-success-400',
    down: 'text-error-600 dark:text-error-400',
    neutral: 'text-gray-500 dark:text-gray-400',
  }
  return `text-sm ${trendMap[props.trend]}`
})

const progressContainerClasses = computed(() => {
  return 'h-2 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden'
})

const progressBarClasses = computed(() => {
  const colorMap = {
    primary: 'bg-brand-500',
    secondary: 'bg-gray-500',
    success: 'bg-success-500',
    error: 'bg-error-500',
    warning: 'bg-warning-500',
    info: 'bg-info-500',
  }
  return `${colorMap[props.progressColor]} transition-all duration-300`
})
</script>

<style scoped>
@import 'tailwindcss/theme';

.stat {
  @apply flex gap-4;
}

.stat-figure {
  @apply flex-shrink-0;
}

.stat-content {
  @apply flex-1 min-w-0;
}

.stat-title {
  @apply text-sm font-medium mb-1;
}

.stat-value {
  @apply mb-1;
}

.stat-desc {
  @apply flex items-center gap-1;
}

.stat-actions {
  @apply flex gap-2;
}
</style>
