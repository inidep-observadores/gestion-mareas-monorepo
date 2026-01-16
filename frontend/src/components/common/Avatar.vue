<template>
  <div class="avatar" :class="avatarClasses">
    <div v-if="src" class="w-full">
      <img :src="src" :alt="alt" />
    </div>
    <div v-else-if="initials" class="text-content">
      {{ initials }}
    </div>
    <div v-else class="text-content">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="w-6 h-6"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"
        />
      </svg>
    </div>

    <!-- Status indicator -->
    <span v-if="status" class="avatar-status" :class="statusClasses"></span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

export interface AvatarProps {
  src?: string
  alt?: string
  initials?: string
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  shape?: 'circle' | 'rounded' | 'square'
  variant?: 'solid' | 'soft' | 'outline'
  color?: 'primary' | 'secondary' | 'success' | 'error' | 'warning' | 'info'
  status?: 'online' | 'offline' | 'away' | 'busy'
  statusPosition?: 'top' | 'bottom'
}

const props = withDefaults(defineProps<AvatarProps>(), {
  size: 'md',
  shape: 'circle',
  variant: 'solid',
  color: 'primary',
  statusPosition: 'bottom',
})

const avatarClasses = computed(() => {
  const classes: string[] = []

  // Size classes
  const sizeMap = {
    xs: 'w-8 h-8 text-xs',
    sm: 'w-10 h-10 text-sm',
    md: 'w-12 h-12 text-base',
    lg: 'w-14 h-14 text-lg',
    xl: 'w-16 h-16 text-xl',
  }
  classes.push(sizeMap[props.size])

  // Shape classes
  if (props.shape === 'circle') {
    classes.push('rounded-full')
  } else if (props.shape === 'rounded') {
    classes.push('rounded-lg')
  }

  // Variant and color classes
  if (!props.src) {
    const colorMap = {
      primary: 'bg-brand-500 text-white',
      secondary: 'bg-gray-500 text-white',
      success: 'bg-success-500 text-white',
      error: 'bg-error-500 text-white',
      warning: 'bg-warning-500 text-white',
      info: 'bg-info-500 text-white',
    }

    if (props.variant === 'solid') {
      classes.push(colorMap[props.color])
    } else if (props.variant === 'soft') {
      const softColorMap = {
        primary: 'bg-brand-100 text-brand-700 dark:bg-brand-900/30 dark:text-brand-300',
        secondary: 'bg-gray-100 text-gray-700 dark:bg-gray-900/30 dark:text-gray-300',
        success: 'bg-success-100 text-success-700 dark:bg-success-900/30 dark:text-success-300',
        error: 'bg-error-100 text-error-700 dark:bg-error-900/30 dark:text-error-300',
        warning: 'bg-warning-100 text-warning-700 dark:bg-warning-900/30 dark:text-warning-300',
        info: 'bg-info-100 text-info-700 dark:bg-info-900/30 dark:text-info-300',
      }
      classes.push(softColorMap[props.color])
    } else if (props.variant === 'outline') {
      const outlineColorMap = {
        primary: 'border-2 border-brand-500 text-brand-500',
        secondary: 'border-2 border-gray-500 text-gray-500',
        success: 'border-2 border-success-500 text-success-500',
        error: 'border-2 border-error-500 text-error-500',
        warning: 'border-2 border-warning-500 text-warning-500',
        info: 'border-2 border-info-500 text-info-500',
      }
      classes.push(outlineColorMap[props.color])
    }
  }

  return classes.join(' ')
})

const statusClasses = computed(() => {
  const classes: string[] = []

  // Position classes
  if (props.statusPosition === 'top') {
    classes.push('top-0 right-0')
  } else {
    classes.push('bottom-0 right-0')
  }

  // Status color classes
  const statusColorMap = {
    online: 'bg-success-500',
    offline: 'bg-gray-400',
    away: 'bg-warning-500',
    busy: 'bg-error-500',
  }

  if (props.status) {
    classes.push(statusColorMap[props.status])
  }

  return classes.join(' ')
})
</script>

<style scoped>
@import 'tailwindcss/theme';

.avatar {
  @apply relative inline-flex items-center justify-center overflow-hidden;
}

.avatar img {
  @apply w-full h-full object-cover;
}

.text-content {
  @apply flex items-center justify-center w-full h-full font-semibold;
}

.avatar-status {
  @apply absolute w-3 h-3 rounded-full border-2 border-[var(--color-surface)];

  @variant dark {
    @apply border-[var(--color-background)];
  }
}
</style>
