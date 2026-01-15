<template>
  <button
    :class="[
      'inline-flex items-center justify-center font-medium gap-2 rounded-lg transition',
      sizeClasses[size],
      variantClasses[variant],
      className,
      { 'cursor-not-allowed opacity-50': disabled },
    ]"
    @click="onClick"
    :disabled="disabled"
  >
    <span v-if="startIcon" class="flex items-center">
      <component :is="startIcon" />
    </span>
    <slot></slot>
    <span v-if="endIcon" class="flex items-center">
      <component :is="endIcon" />
    </span>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface ButtonProps {
  size?: 'xs' | 'sm' | 'md' | 'lg'
  variant?: 'primary' | 'outline' | 'soft' | 'ghost' | 'link' | 'success' | 'error' | 'warning'
  startIcon?: object
  endIcon?: object
  onClick?: () => void
  className?: string
  disabled?: boolean
}

const props = withDefaults(defineProps<ButtonProps>(), {
  size: 'md',
  variant: 'primary',
  className: '',
  disabled: false,
})

const sizeClasses = {
  xs: 'px-2 py-1 text-xs',
  sm: 'px-3 py-2 text-sm',
  md: 'px-4 py-2.5 text-sm',
  lg: 'px-6 py-4 text-base',
}

const variantClasses = {
  primary: 'bg-primary text-primary-fg shadow-theme-sm hover:opacity-90 active:scale-[0.98]',
  outline: 'bg-transparent text-text border border-border hover:bg-surface-muted transition-colors',
  soft: 'bg-primary/10 text-primary hover:bg-primary/20 transition-colors',
  ghost: 'bg-transparent text-text hover:bg-surface-muted transition-colors',
  link: 'bg-transparent text-primary hover:underline px-0 py-0 h-auto',
  success: 'bg-success text-success-fg hover:opacity-90 shadow-theme-sm',
  error: 'bg-error text-error-fg hover:opacity-90 shadow-theme-sm',
  warning: 'bg-warning text-warning-fg hover:opacity-90 shadow-theme-sm',
}

const onClick = () => {
  if (!props.disabled && props.onClick) {
    props.onClick()
  }
}
</script>
