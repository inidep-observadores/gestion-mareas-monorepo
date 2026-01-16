<template>
  <span :class="[baseStyles, sizeClass, colorStyles]">
    <span v-if="startIcon" class="mr-1">
      <component :is="startIcon" />
    </span>
    <slot></slot>
    <span v-if="endIcon" class="ml-1">
      <component :is="endIcon" />
    </span>
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

type BadgeVariant = 'light' | 'solid'
type BadgeSize = 'sm' | 'md'
type BadgeColor = 'primary' | 'success' | 'error' | 'warning' | 'info' | 'light' | 'dark'

interface BadgeProps {
  variant?: BadgeVariant
  size?: BadgeSize
  color?: BadgeColor
  startIcon?: object
  endIcon?: object
}

const props = withDefaults(defineProps<BadgeProps>(), {
  variant: 'light',
  color: 'primary',
  size: 'md',
})

const baseStyles =
  'inline-flex items-center px-2.5 py-0.5 justify-center gap-1 rounded-full font-medium capitalize'

const sizeStyles = {
  sm: 'text-theme-xs',
  md: 'text-sm',
}

const variants = {
  light: {
    primary: 'bg-primary/10 text-primary',
    success: 'bg-success/10 text-success',
    error: 'bg-error/10 text-error',
    warning: 'bg-warning/10 text-warning',
    info: 'bg-info/10 text-info',
    light: 'bg-surface-muted text-text-muted',
    dark: 'bg-text-muted/20 text-text',
  },
  solid: {
    primary: 'bg-primary text-primary-fg',
    success: 'bg-success text-success-fg',
    error: 'bg-error text-error-fg',
    warning: 'bg-warning text-warning-fg',
    info: 'bg-info text-info-fg',
    light: 'bg-surface-muted text-text',
    dark: 'bg-text-muted text-white',
  },
}

const sizeClass = computed(() => sizeStyles[props.size])
const colorStyles = computed(() => variants[props.variant][props.color])
</script>
