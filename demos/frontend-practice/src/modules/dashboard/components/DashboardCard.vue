<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  title: string;
  description?: string;
  icon?: any; // Componente de icono de Lucide
  iconColor?: 'blue' | 'green' | 'purple' | 'orange' | 'cyan';
}

const props = defineProps<Props>();

const iconBgClass = computed(() => {
  const colors = {
    blue: 'bg-blue-50 text-blue-600 border-blue-100',
    green: 'bg-emerald-50 text-emerald-600 border-emerald-100',
    purple: 'bg-purple-50 text-purple-600 border-purple-100',
    orange: 'bg-orange-50 text-orange-600 border-orange-100',
    cyan: 'bg-cyan-50 text-cyan-600 border-cyan-100',
  };
  return colors[props.iconColor || 'blue'];
});
</script>

<template>
  <div class="premium-card">
    <div class="flex items-start justify-between mb-4">
      <div v-if="icon" :class="['icon-container', iconBgClass]">
        <component :is="icon" :size="24" stroke-width="2" />
      </div>
      <slot name="extra"></slot>
    </div>
    
    <div class="content">
      <h3 class="card-title">{{ title }}</h3>
      <p v-if="description" class="card-description">{{ description }}</p>
      <div class="card-body">
        <slot></slot>
      </div>
    </div>
    
    <div v-if="$slots.footer" class="card-footer mt-4 pt-4 border-t border-gray-50">
      <slot name="footer"></slot>
    </div>
  </div>
</template>

<style scoped>
.premium-card {
  background: white;
  border: 1px solid rgba(241, 245, 249, 1);
  border-radius: 20px;
  padding: 1.5rem;
  box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.03);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: flex;
  flex-direction: column;
}

.premium-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 30px -4px rgba(0, 0, 0, 0.06);
  border-color: rgba(226, 232, 240, 1);
}

.icon-container {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  border-radius: 14px;
  border-width: 1px;
}

.card-title {
  color: #1e293b;
  font-size: 1.125rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  letter-spacing: -0.025em;
}

.card-description {
  color: #64748b;
  font-size: 0.875rem;
  line-height: 1.5;
}

.card-body {
  margin-top: 0.5rem;
}
</style>
