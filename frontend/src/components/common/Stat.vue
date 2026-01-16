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
    classes.push('border border-border rounded-2xl p-6 transition-all')
  } else if (props.variant === 'filled') {
    const colorMap = {
      primary: 'bg-primary/10 text-primary border border-primary/20',
      secondary: 'bg-surface text-text border border-border',
      success: 'bg-success/10 text-success border border-success/20',
      error: 'bg-error/10 text-error border border-error/20',
      warning: 'bg-warning/10 text-warning border border-warning/20',
      info: 'bg-primary/10 text-primary border border-primary/20',
    }
    classes.push(colorMap[props.color], 'rounded-2xl p-6')
  }

  return classes.join(' ')
})

const figureClasses = computed(() => {
  const colorMap = {
    primary: 'text-primary',
    secondary: 'text-text-muted',
    success: 'text-success',
    error: 'text-error',
    warning: 'text-warning',
    info: 'text-primary',
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
  return 'text-text-muted'
})

const valueClasses = computed(() => {
  const sizeMap = {
    sm: 'text-2xl',
    md: 'text-3xl',
    lg: 'text-4xl',
  }
  const trendMap = {
    up: 'text-success dark:text-success',
    down: 'text-error dark:text-error',
    neutral: 'text-text',
  }
  return `${sizeMap[props.size]} font-bold ${trendMap[props.trend]}`
})

const descClasses = computed(() => {
  const trendMap = {
    up: 'text-success dark:text-success',
    down: 'text-error dark:text-error',
    neutral: 'text-text-muted',
  }
  return `text-sm ${trendMap[props.trend]}`
})

const progressContainerClasses = computed(() => {
  return 'h-2 bg-border/40 rounded-full overflow-hidden'
})

const progressBarClasses = computed(() => {
  const colorMap = {
    primary: 'bg-primary',
    secondary: 'bg-text-muted',
    success: 'bg-success',
    error: 'bg-error',
    warning: 'bg-warning',
    info: 'bg-primary',
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
