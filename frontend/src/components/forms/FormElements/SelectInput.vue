<template>
  <div class="space-y-6">
    <!-- Single Select Input -->
    <div>
      <label class="mb-1.5 block text-sm font-medium text-text-muted">
        Select Input
      </label>
      <div class="relative z-20 bg-transparent">
        <select
          v-model="singleSelect"
          class="dark:bg-dark-900 h-11 w-full appearance-none rounded-lg border border-border bg-transparent bg-none px-4 py-2.5 pr-11 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-primary focus:ring-primary/10 dark:border-border dark:bg-transparent dark:text-text dark:placeholder:text-text-muted/30 dark:focus:border-primary/50"
          :class="{ 'text-text': singleSelect }"
        >
          <option value="" disabled>Select Option</option>
          <option value="marketing" class="text-gray-700 dark:bg-gray-900 dark:text-gray-400">
            Marketing
          </option>
          <option value="template" class="text-gray-700 dark:bg-gray-900 dark:text-gray-400">
            Template
          </option>
          <option value="development" class="text-gray-700 dark:bg-gray-900 dark:text-gray-400">
            Development
          </option>
        </select>
        <span
          class="absolute z-30 text-gray-700 -translate-y-1/2 pointer-events-none right-4 top-1/2 dark:text-gray-400"
        >
          <svg
            class="stroke-current"
            width="20"
            height="20"
            viewBox="0 0 20 20"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M4.79175 7.396L10.0001 12.6043L15.2084 7.396"
              stroke=""
              stroke-width="1.5"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
        </span>
      </div>
    </div>

    <!-- Multiple Select Input -->
    <div>
      <MultipleSelect v-model="selectedItems" :options="optionss" class="w-full" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import MultipleSelect from './MultipleSelect.vue'

const optionss = [
  { value: 'apple', label: 'Apple' },
  { value: 'banana', label: 'Banana' },
  { value: 'cherry', label: 'Cherry' },
  { value: 'date', label: 'Date' },
  { value: 'elderberry', label: 'Elderberry' },
  { value: 'graphs', label: 'Graphs' },
]

const selectedItems = ref([])

const singleSelect = ref('')

const options = ref([
  { text: 'Option 1', selected: false },
  { text: 'Option 2', selected: false },
  { text: 'Option 3', selected: false },
  { text: 'Option 4', selected: false },
])

const selected = computed(() => options.value.filter((option) => option.selected))
</script>
