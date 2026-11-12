<template>
  <div class="relative w-full select-none pt-2 pb-1">
    <!-- Pista base -->
    <div class="relative h-2 w-full rounded-full bg-border/60">
      <!-- Pista activa entre los dos extremos -->
      <div
        class="absolute h-full rounded-full bg-primary transition-all duration-75"
        :style="{
          left: `${percentMin}%`,
          width: `${percentMax - percentMin}%`
        }"
      ></div>
    </div>

    <!-- Controles de rango transparentes superpuestos -->
    <input
      type="range"
      :min="min"
      :max="max"
      :step="step"
      :value="modelValue[0]"
      @input="onInputMin($event)"
      class="range-thumb-input"
    />
    <input
      type="range"
      :min="min"
      :max="max"
      :step="step"
      :value="modelValue[1]"
      @input="onInputMax($event)"
      class="range-thumb-input"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

const props = withDefaults(
  defineProps<{
    modelValue: [number, number];
    min?: number;
    max?: number;
    step?: number;
    minDistance?: number;
  }>(),
  {
    min: 0,
    max: 180,
    step: 1,
    minDistance: 0,
  }
);

const emit = defineEmits<{
  (e: 'update:modelValue', value: [number, number]): void;
}>();

const percentMin = computed(() => {
  const range = props.max - props.min;
  if (range <= 0) return 0;
  return Math.max(0, Math.min(100, ((props.modelValue[0] - props.min) / range) * 100));
});

const percentMax = computed(() => {
  const range = props.max - props.min;
  if (range <= 0) return 100;
  return Math.max(0, Math.min(100, ((props.modelValue[1] - props.min) / range) * 100));
});

const onInputMin = (e: Event) => {
  const val = Number((e.target as HTMLInputElement).value);
  const currentMax = props.modelValue[1];
  const newMin = Math.min(val, currentMax - props.minDistance);
  emit('update:modelValue', [newMin, currentMax]);
};

const onInputMax = (e: Event) => {
  const val = Number((e.target as HTMLInputElement).value);
  const currentMin = props.modelValue[0];
  const newMax = Math.max(val, currentMin + props.minDistance);
  emit('update:modelValue', [currentMin, newMax]);
};
</script>

<style scoped>
.range-thumb-input {
  position: absolute;
  top: 8px;
  left: 0;
  width: 100%;
  height: 8px;
  pointer-events: none;
  appearance: none;
  background: transparent;
  margin: 0;
}

.range-thumb-input::-webkit-slider-thumb {
  pointer-events: auto;
  appearance: none;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: var(--color-primary, #0284c7);
  border: 2px solid white;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.25);
  cursor: ew-resize;
  transition: transform 0.1s ease;
}

.range-thumb-input::-webkit-slider-thumb:hover {
  transform: scale(1.15);
}

.range-thumb-input::-webkit-slider-thumb:active {
  transform: scale(1.25);
}

.range-thumb-input::-moz-range-thumb {
  pointer-events: auto;
  appearance: none;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: var(--color-primary, #0284c7);
  border: 2px solid white;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.25);
  cursor: ew-resize;
  transition: transform 0.1s ease;
}

.range-thumb-input::-moz-range-thumb:hover {
  transform: scale(1.15);
}

.range-thumb-input::-moz-range-thumb:active {
  transform: scale(1.25);
}
</style>
