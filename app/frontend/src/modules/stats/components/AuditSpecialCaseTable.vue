<template>
   <div class="border border-border rounded-xl overflow-hidden">
      <!-- Header acordeón -->
      <button @click="open = !open"
         class="w-full flex items-center justify-between px-4 py-3 hover:bg-surface-muted/30 transition-colors group">
         <div class="flex items-center gap-3">
            <component :is="open ? ChevronDownIcon : ChevronRightIcon"
               class="w-4 h-4 text-text-muted group-hover:text-primary transition-colors" />
            <div class="text-left">
               <p class="text-xs font-black text-text uppercase tracking-tight">{{ title }}</p>
               <p class="text-[9px] text-text-muted font-medium mt-0.5">{{ subtitle }}</p>
            </div>
         </div>
         <span class="px-2 py-0.5 rounded border text-[9px] font-black tabular-nums" :class="badgeClass">
            {{ items.length }}
         </span>
      </button>

      <!-- Tabla -->
      <div v-if="open" class="border-t border-border overflow-x-auto">
         <table class="w-full text-left border-collapse min-w-[600px]">
            <thead>
               <tr class="bg-surface-muted/20">
                  <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Marea</th>
                  <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Buque</th>
                  <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Pesquería / Flota</th>
                  <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Observador</th>
                  <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-20">Días Nav.</th>
                  <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-28">{{ eventLabel }}</th>
                  <th v-if="showMotivo" class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Motivo</th>
               </tr>
            </thead>
            <tbody class="divide-y divide-border/50">
               <tr v-for="item in items" :key="item.id" class="hover:bg-primary/5 transition-colors">
                  <td class="px-4 py-2 text-xs font-black text-text tabular-nums">{{ item.id_marea }}</td>
                  <td class="px-4 py-2 text-xs font-bold text-text">{{ item.buque }}</td>
                  <td class="px-4 py-2">
                     <div class="flex flex-col">
                        <span class="text-[10px] font-black text-text uppercase tracking-tight">{{ item.pesqueria }}</span>
                        <span class="text-[9px] font-bold text-text-muted">{{ item.flota }}</span>
                     </div>
                  </td>
                  <td class="px-4 py-2 text-xs font-bold text-text">{{ item.observador }}</td>
                  <td class="px-4 py-2 text-center">
                     <span class="text-xs font-black tabular-nums"
                        :class="item.diasNavegados > 0 ? 'text-text' : 'text-text-muted/40'">
                        {{ item.diasNavegados > 0 ? item.diasNavegados : '—' }}
                     </span>
                  </td>
                  <td class="px-4 py-2 text-center">
                     <span class="text-[10px] font-bold text-text-muted tabular-nums">
                        {{ item.fechaEvento ? formatDate(item.fechaEvento) : '—' }}
                     </span>
                  </td>
                  <td v-if="showMotivo" class="px-4 py-2">
                     <span class="text-[10px] text-text-muted italic">{{ item.motivo || '—' }}</span>
                  </td>
               </tr>
            </tbody>
         </table>
      </div>
   </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ChevronDownIcon, ChevronRightIcon } from 'lucide-vue-next'
import type { AuditSpecialMarea } from '../services/stats.service'

defineProps<{
   title: string
   subtitle: string
   badgeClass: string
   items: AuditSpecialMarea[]
   eventLabel: string
   showMotivo?: boolean
}>()

const open = ref(false)

const formatDate = (d: string) =>
   new Date(d).toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit', year: '2-digit' })
</script>
