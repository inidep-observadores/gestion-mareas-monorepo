<template>
  <div class="historial-container relative">

    <!-- DESKTOP LAYOUT (Split View) -->
    <div class="hidden lg:grid lg:grid-cols-12 lg:gap-8 min-h-[600px]">

      <!-- Lotes List (Left side) -->
      <div class="lg:col-span-4 flex flex-col gap-4">
        <div class="flex items-center justify-between mb-2">
          <div>
            <h2 class="text-sm font-black uppercase tracking-widest text-text">Envíos Realizados</h2>
            <p class="text-xs text-text-muted">Historial de marea enviadas a protocolización por año operativo.</p>
          </div>
          <span class="text-xs font-bold text-text-muted bg-surface-muted px-3 py-1 rounded-full border border-border uppercase">
            {{ lotes.length }} {{ lotes.length === 1 ? 'Lote' : 'Lotes' }}
          </span>
        </div>

        <div v-if="lotes.length === 0" class="flex flex-col items-center justify-center py-20 bg-surface-muted rounded-3xl border-2 border-dashed border-border opacity-60">
          <svg xmlns="http://www.w3.org/2000/svg" class="w-16 h-16 text-text-muted mb-4 opacity-20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <p class="text-text-muted font-bold tracking-tight">No hay registros de envíos para este año.</p>
        </div>

        <div v-else class="flex-1 overflow-y-auto custom-scrollbar bg-surface rounded-2xl border border-border shadow-sm">
          <template v-for="(lote, index) in lotesProcesados" :key="lote.id">
            <!-- Separador de Fecha Discreto -->
            <div
              v-if="shouldShowDateHeader(lote, index)"
              class="px-5 py-2.5 bg-surface-muted/50 border-y border-border/30 first:border-t-0"
            >
              <span class="text-[9px] font-black text-text-muted uppercase tracking-[0.2em]">
                {{ formatDateGroup(lote.fechaEnvio) }}
              </span>
            </div>

            <div
              @click="selectLote(lote)"
              class="p-5 border-b border-border/40 cursor-pointer hover:bg-primary/5 transition-all relative group"
              :class="{ 'bg-primary/5 border-l-4 border-l-primary shadow-inner': selectedLoteId === lote.id }"
            >
              <div class="flex justify-between items-start mb-2">
                <Badge
                  :variant="lote.canal === 'EMAIL' ? 'solid' : 'light'"
                  :color="lote.canal === 'EMAIL' ? 'primary' : 'info'"
                  size="sm"
                  class="font-black text-[9px] uppercase px-2 tracking-widest"
                >
                  {{ lote.canal }}
                </Badge>
                <span class="text-[10px] font-black text-primary/40 group-hover:text-primary/60 transition-colors">
                  #{{ lote.numeroLote }}
                </span>
              </div>

              <h4 class="text-[11px] font-black text-text uppercase tracking-widest leading-snug mb-2 group-hover:text-primary transition-colors">
                Enviado por {{ lote.usuario?.fullName || 'Sistema' }}
              </h4>

              <div class="flex items-center justify-between">
                <div class="flex items-center gap-1.5">
                  <UserCircleIcon class="w-3.5 h-3.5 text-primary/60" />
                  <span class="text-[10px] text-text-muted font-bold">{{ lote.usuario?.fullName || 'Proceso de Sistema' }}</span>
                </div>
                <span class="text-[9px] font-black text-primary/80 uppercase">
                  {{ lote._count?.items || 0 }} {{ (lote._count?.items || 0) === 1 ? 'marea' : 'mareas' }}
                </span>
              </div>
            </div>
          </template>
        </div>
      </div>

      <!-- Detail Card (Right side) -->
      <div class="lg:col-span-8 relative">
        <div class="sticky top-24">
          <div v-if="!selectedLoteId" class="flex flex-col items-center justify-center p-12 bg-surface-muted rounded-3xl border border-border h-[400px] opacity-80 border-dashed">
            <div class="w-20 h-20 rounded-full bg-white dark:bg-gray-800 flex items-center justify-center shadow-inner mb-6">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-primary animate-pulse" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5" />
              </svg>
            </div>
            <p class="text-center font-black text-text-muted max-w-[200px] leading-tight tracking-tight uppercase italic">
              Seleccione un lote para ver el detalle de las mareas
            </p>
          </div>

          <div v-else-if="loadingDetail" class="flex flex-col items-center justify-center p-12 bg-surface rounded-3xl border border-border h-[400px] shadow-2xl">
            <div class="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
            <p class="font-bold text-text-muted uppercase tracking-widest text-xs">Cargando detalles...</p>
          </div>

          <div v-else-if="detalles" class="flex-1 overflow-y-auto custom-scrollbar bg-linear-to-b from-surface-muted/30 to-surface rounded-3xl border border-border flex flex-col h-full shadow-sm animate-fade-in">
            <!-- Header Detalle -->
            <div class="p-8 border-b border-border bg-surface/50">
              <div class="flex items-center justify-between mb-2 lg:hidden">
                <button @click="selectedLoteId = null" class="p-2 rounded-xl bg-surface-muted text-text-muted">
                  <ArrowLeftIcon class="w-5 h-5" />
                </button>
                <span class="text-[10px] font-black uppercase tracking-widest text-text">Detalle de Envío</span>
              </div>

              <div class="flex flex-col xl:flex-row justify-between items-start gap-8">
                <div class="min-w-0 flex-1">
                    <div class="flex flex-wrap items-center gap-3 mb-4">
                       <span class="px-3 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-widest bg-primary/10 text-primary border border-primary/20">
                         {{ detalles.canal }}
                       </span>
                    </div>
                    <h2 class="text-2xl font-black text-text leading-tight tracking-tight uppercase">
                       Lote de Protocolización #{{ detalles.numeroLote }}
                    </h2>
                    <div class="flex flex-col gap-0.5 mt-2">
                      <p class="text-[10px] font-bold text-text-muted uppercase tracking-wide">
                        {{ detalles.items.length }} {{ detalles.items.length === 1 ? 'marea enviada' : 'mareas enviadas' }} a protocolizar satisfactoriamente
                      </p>
                      <p class="text-[10px] font-black text-primary uppercase italic opacity-80">
                        Enviado por {{ detalles.usuario?.fullName || 'Sistema' }}
                      </p>
                    </div>
                 </div>
                 <div class="bg-surface p-6 rounded-2xl border-2 border-primary/10 shadow-sm flex flex-col items-center justify-center shrink-0 w-full xl:w-64">
                    <div class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2 text-center">Momento del Registro</div>
                    <div class="text-lg font-black text-text text-center">{{ formatDateGroup(detalles.fechaEnvio) }}</div>
                 </div>
              </div>

              <!-- Sección de Notas o Aclaraciones (Prominente) -->
              <div v-if="detalles.metadata?.textoAdicional" class="mt-8 p-6 bg-primary/5 border border-primary/10 rounded-2xl animate-in fade-in slide-in-from-top-4">
                <div class="flex items-center gap-2 mb-3">
                  <div class="w-1.5 h-6 bg-primary rounded-full"></div>
                  <h3 class="text-[10px] font-black uppercase tracking-widest text-primary">Notas o aclaraciones</h3>
                </div>
                <p class="text-xs text-text font-bold leading-relaxed whitespace-pre-wrap italic">{{ detalles.metadata.textoAdicional }}</p>
              </div>
            </div>

            <!-- Metadata Email - DESKTOP -->
            <div v-if="detalles.metadata?.email" class="mt-8 border border-border rounded-2xl overflow-hidden bg-surface shadow-sm mx-8">
              <button 
                @click="showEmailDetails = !showEmailDetails"
                class="w-full flex items-center justify-between p-4 bg-surface-muted/30 hover:bg-surface-muted transition-colors border-b border-border/10"
              >
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center">
                    <MailIcon class="w-4 h-4 text-primary" />
                  </div>
                  <div class="text-left">
                    <span class="text-[10px] font-black uppercase tracking-widest text-text block leading-none">Detalles del Email Enviado</span>
                    <span class="text-[9px] text-text-muted font-bold uppercase opacity-60">Metadata técnica del registro de envío</span>
                  </div>
                </div>
                <div class="flex items-center gap-2">
                  <span class="text-[8px] font-black uppercase tracking-widest text-primary/60 mr-2">{{ showEmailDetails ? 'Contraer' : 'Expandir' }}</span>
                  <ChevronDownIcon class="w-4 h-4 text-text-muted transition-transform duration-300" :class="{ 'rotate-180': showEmailDetails }" />
                </div>
              </button>
              
              <div v-show="showEmailDetails" class="p-6 bg-surface space-y-5 border-t border-border animate-fade-in">
                <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
                  <!-- Para -->
                  <div class="flex flex-col gap-1.5">
                    <div class="flex items-center justify-between">
                      <label class="text-[9px] font-black text-text-muted uppercase tracking-[0.15em]">Destinatario (TO)</label>
                      <button @click="copyToClipboard(detalles.metadata.email.to, 'Destinatario')" class="p-1.5 hover:bg-primary/10 rounded-lg transition-all group" title="Copiar destinatario">
                        <PageIcon class="w-3.5 h-3.5 text-primary group-hover:scale-110 transition-transform" />
                      </button>
                    </div>
                    <div class="p-3 bg-surface-muted border border-border/50 rounded-xl text-xs font-mono break-all text-text selection:bg-primary/20">{{ detalles.metadata.email.to }}</div>
                  </div>
                  
                  <!-- CC -->
                  <div v-if="detalles.metadata.email.cc" class="flex flex-col gap-1.5">
                    <div class="flex items-center justify-between">
                      <label class="text-[9px] font-black text-text-muted uppercase tracking-[0.15em]">Copia (CC)</label>
                      <button @click="copyToClipboard(detalles.metadata.email.cc, 'CC')" class="p-1.5 hover:bg-primary/10 rounded-lg transition-all group" title="Copiar CC">
                        <PageIcon class="w-3.5 h-3.5 text-primary group-hover:scale-110 transition-transform" />
                      </button>
                    </div>
                    <div class="p-3 bg-surface-muted border border-border/50 rounded-xl text-xs font-mono break-all text-text selection:bg-primary/20">{{ detalles.metadata.email.cc }}</div>
                  </div>
                </div>
                
                <!-- Asunto -->
                <div class="flex flex-col gap-1.5">
                  <div class="flex items-center justify-between">
                    <label class="text-[9px] font-black text-text-muted uppercase tracking-[0.15em]">Asunto del Mensaje</label>
                    <button @click="copyToClipboard(detalles.metadata.email.subject, 'Asunto')" class="p-1.5 hover:bg-primary/10 rounded-lg transition-all group" title="Copiar asunto">
                      <PageIcon class="w-3.5 h-3.5 text-primary group-hover:scale-110 transition-transform" />
                    </button>
                  </div>
                  <div class="p-3 bg-surface-muted border border-border/50 rounded-xl text-xs font-black text-text uppercase tracking-tight selection:bg-primary/20">{{ detalles.metadata.email.subject }}</div>
                </div>
                
                <!-- Cuerpo -->
                <div class="flex flex-col gap-1.5">
                  <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                      <label class="text-[9px] font-black text-text-muted uppercase tracking-[0.15em]">Cuerpo del Email</label>
                      <span class="px-1.5 py-0.5 rounded bg-primary/5 text-primary text-[8px] font-black uppercase italic">Sólo Lectura</span>
                    </div>
                    <button @click="copyAsPlainText(detalles.metadata.email.body, detalles.metadata.textoAdicional)" class="flex items-center gap-2 px-3 py-1.5 hover:bg-primary/10 rounded-lg transition-all group" title="Copiar como tabla de texto">
                      <span class="text-[9px] font-black text-primary uppercase">Copiar como Texto</span>
                      <PageIcon class="w-3.5 h-3.5 text-primary group-hover:scale-110 transition-transform" />
                    </button>
                  </div>
                  <div class="p-4 bg-surface-muted border border-border rounded-xl overflow-y-auto max-h-[400px] shadow-inner selection:bg-primary/20 custom-scrollbar">
                    <div v-html="detalles.metadata.email.body" class="email-preview-content"></div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Listado de Mareas (Impacto) -->
            <div class="p-8">
              <div class="flex items-center gap-2 mb-6">
                <span class="p-1 px-3 bg-primary/10 text-primary rounded-full text-[9px] font-black uppercase tracking-widest">Mareas incluidas</span>
               </div>

              <div class="grid grid-cols-1 gap-4">
                <div v-for="item in itemsOrdenados" :key="item.id" class="group flex flex-col bg-surface border border-border border-l-4 border-l-primary p-4 rounded-xl shadow-sm hover:shadow-md transition-all">
                  <div class="flex items-center justify-between">
                    <div class="flex flex-col">
                      <span class="text-primary font-black text-sm uppercase tracking-widest leading-tight">
                        {{ formatMareaCode(item.marea) }}
                      </span>
                      <span class="text-[11px] font-bold text-text truncate max-w-[400px]">
                        {{ item.marea.buque?.nombreBuque || 'Sin buque' }}
                        <span class="text-text-muted ml-1 opacity-60">({{ item.marea.buque?.codigoInterno || '---' }})</span>
                      </span>
                    </div>
                    <Badge variant="light" color="success" size="sm" class="font-extrabold uppercase text-[9px] tracking-tighter">
                      {{ item.marea.estadoActual?.nombre }}
                    </Badge>
                  </div>
                </div>
              </div>

              <div class="mt-8 p-6 bg-surface-muted/50 rounded-2xl border border-dashed border-border flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 bg-surface rounded-full flex items-center justify-center shadow-sm">
                    <HistoryIcon class="w-5 h-5 text-text-muted" />
                  </div>
                  <div>
                    <p class="text-[10px] font-black uppercase tracking-widest text-text">Resumen del Lote</p>
                    <p class="text-xs text-text-muted font-bold">Registro de trazabilidad integrado</p>
                  </div>
                </div>
                <div class="text-right">
                  <span class="text-[10px] font-black text-text-muted uppercase tracking-widest block">Total {{ detalles.items.length === 1 ? 'Marea' : 'Mareas' }}</span>
                  <span class="text-2xl font-black text-primary tracking-tighter leading-none">{{ detalles.items.length }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- MOBILE LAYOUT (Navigation Pattern) -->
    <div class="lg:hidden flex flex-col gap-4 min-h-[400px]">
      <Transition name="slide-fade" mode="out-in">
        <!-- List View -->
        <div v-if="!selectedLoteId" class="flex flex-col gap-4">
          <div class="flex items-center justify-between px-2">
            <h2 class="text-sm font-black uppercase tracking-widest text-text">Historial de Envíos</h2>
            <Badge variant="solid" color="primary" class="font-black">{{ lotes.length }}</Badge>
          </div>

          <div v-if="lotes.length === 0" class="py-12 text-center text-text-muted font-bold italic bg-surface-muted rounded-2xl border-2 border-dashed border-border px-8">
             No hay registros de envíos de protocolización realizados en este año operativo.
          </div>

          <div v-else class="flex flex-col gap-3">
             <div
              v-for="lote in lotesProcesados"
              :key="lote.id"
              @click="selectLote(lote)"
              class="bg-surface border border-border rounded-xl p-4 active:scale-95 transition-all shadow-sm flex items-center justify-between group"
            >
              <div class="flex flex-col gap-1">
                <div class="flex items-center gap-2">
                  <span class="font-black text-text uppercase tracking-widest text-[10px] leading-tight group-hover:text-primary transition-colors">
                    Lote #{{ lote.numeroLote }}
                  </span>
                  <Badge variant="light" size="sm" class="text-[8px] font-black uppercase px-2 tracking-tighter">{{ lote.canal }}</Badge>
                </div>
                <div class="flex items-center gap-2 mt-1">
                  <span class="text-[8px] font-bold text-text-muted uppercase tracking-tight">{{ lote.usuario?.fullName || 'Sistema' }}</span>
                  <span class="text-[8px] font-medium text-text-muted uppercase italic opacity-60">• {{ lote._count?.items }} {{ lote._count?.items === 1 ? 'marea' : 'mareas' }}</span>
                </div>
              </div>
              <ChevronRightIcon class="w-5 h-5 text-text-muted opacity-30 group-hover:opacity-100 transition-opacity" />
            </div>
          </div>
        </div>

        <!-- Detail View (Mobile) -->
        <div v-else class="flex flex-col gap-4">
          <button
            @click="selectedLoteId = null"
            class="flex items-center gap-2 text-primary font-black uppercase text-[10px] tracking-widest mb-2 group w-fit"
          >
            <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center group-hover:bg-primary group-hover:text-white transition-all shadow-sm">
              <ArrowLeftIcon class="w-4 h-4" />
            </div>
            Volver al Historial
          </button>

          <div v-if="loadingDetail" class="flex flex-col items-center justify-center py-20 bg-surface rounded-3xl border border-border">
            <div class="w-10 h-10 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
            <p class="font-bold text-text-muted uppercase tracking-widest text-[10px]">Cargando...</p>
          </div>

          <div v-else-if="detalles" class="bg-surface border border-border rounded-3xl shadow-xl overflow-hidden flex flex-col animate-scale-in">
             <div class="p-6 border-b border-border bg-linear-to-b from-surface-muted/50 to-surface">
                <div class="flex items-center gap-2 mb-3">
                  <Badge color="primary" variant="solid" size="sm" class="font-black text-[8px] uppercase tracking-widest">{{ detalles.canal }}</Badge>
                  <span class="text-[9px] font-bold text-text-muted uppercase ml-auto italic opacity-70">{{ detalles.items.length }} {{ detalles.items.length === 1 ? 'marea' : 'mareas' }}</span>
                </div>
                <h4 class="text-xl font-black text-text tracking-tighter leading-tight uppercase">Lote #{{ detalles.numeroLote }}</h4>
                <div class="flex flex-col gap-0.5 mt-1">
                  <p class="text-[9px] font-bold text-text-muted uppercase tracking-tight">{{ formatDateGroup(detalles.fechaEnvio) }}</p>
                  <p class="text-[9px] font-black text-primary uppercase italic opacity-80">
                    {{ detalles.canal }} • Enviado por {{ detalles.usuario?.fullName || 'Sistema' }}
                  </p>
                </div>
             </div>

             <!-- Metadata Email - MOBILE -->
             <div v-if="detalles.metadata?.email" class="mx-4 mb-2 mt-4 border border-border rounded-2xl overflow-hidden bg-surface-muted/20">
                <button 
                  @click="showEmailDetails = !showEmailDetails"
                  class="w-full flex items-center justify-between p-4 active:bg-surface-muted transition-colors"
                >
                  <div class="flex items-center gap-3">
                    <MailIcon class="w-4 h-4 text-primary" />
                    <span class="text-[10px] font-black uppercase tracking-widest text-text">Ver Detalles de Envío</span>
                  </div>
                  <ChevronDownIcon class="w-4 h-4 text-text-muted transition-transform duration-300" :class="{ 'rotate-180': showEmailDetails }" />
                </button>
                
                <div v-show="showEmailDetails" class="px-4 pb-6 space-y-4 animate-fade-in border-t border-border/10 pt-4">
                  <!-- Mobile Campos -->
                  <div class="space-y-4">
                     <div class="flex flex-col gap-1">
                       <label class="text-[8px] font-black text-text-muted uppercase tracking-widest">Para:</label>
                       <div class="flex items-center gap-2">
                          <div class="flex-1 p-2 bg-surface rounded-lg text-[10px] font-mono break-all border border-border/40">{{ detalles.metadata.email.to }}</div>
                          <button @click="copyToClipboard(detalles.metadata.email.to, 'Para')" class="p-2 bg-primary/10 rounded-lg active:scale-95 transition-transform"><PageIcon class="w-3.5 h-3.5 text-primary" /></button>
                       </div>
                     </div>
                     
                     <div v-if="detalles.metadata.email.cc" class="flex flex-col gap-1">
                       <label class="text-[8px] font-black text-text-muted uppercase tracking-widest">CC:</label>
                       <div class="flex items-center gap-2">
                          <div class="flex-1 p-2 bg-surface rounded-lg text-[10px] font-mono break-all border border-border/40">{{ detalles.metadata.email.cc }}</div>
                          <button @click="copyToClipboard(detalles.metadata.email.cc, 'CC')" class="p-2 bg-primary/10 rounded-lg active:scale-95 transition-transform"><PageIcon class="w-3.5 h-3.5 text-primary" /></button>
                       </div>
                     </div>

                     <div class="flex flex-col gap-1">
                       <label class="text-[8px] font-black text-text-muted uppercase tracking-widest">Cuerpo HTML:</label>
                       <div class="p-3 bg-surface rounded-lg text-[9px] border border-border/40 max-h-[250px] overflow-y-auto custom-scrollbar">
                          <div v-html="detalles.metadata.email.body" class="prose prose-sm max-w-none dark:prose-invert text-[10px]"></div>
                       </div>
                       <button @click="copyToClipboard(detalles.metadata.email.body, 'Cuerpo')" class="mt-2 w-full py-2.5 bg-primary text-white rounded-xl flex items-center justify-center gap-2 font-black uppercase text-[9px] tracking-[0.2em] shadow-sm active:scale-95 transition-all">
                          <PageIcon class="w-3.5 h-3.5" />
                          Copiar Cuerpo Completo
                       </button>
                     </div>
                  </div>
                </div>
             </div>

             <div class="p-4 flex flex-col gap-3">
                <div v-for="item in itemsOrdenados" :key="item.id" class="bg-surface-muted/30 p-4 rounded-xl border border-border border-l-4 border-l-primary flex flex-col">
                  <div class="font-black text-primary uppercase tracking-widest text-xs leading-tight mb-1">{{ formatMareaCode(item.marea) }}</div>
                  <div class="text-[10px] font-bold text-text truncate">{{ item.marea.buque?.nombreBuque }}</div>
                  <div class="text-[8px] font-black text-text-muted uppercase mt-2 italic opacity-70">{{ item.marea.estadoActual?.nombre }}</div>
                </div>
             </div>
          </div>
        </div>
      </Transition>
    </div>

  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import Badge from '@/components/ui/Badge.vue'
import mareasService from '../../services/mareas.service'
import {
  UserCircleIcon,
  HistoryIcon,
  ArrowLeftIcon,
  ChevronRightIcon,
  MailIcon,
  ChevronDownIcon,
  PageIcon
} from '@/icons'
import { toast } from 'vue-sonner'

const props = defineProps<{
  lotes: any[]
}>()

const selectedLoteId = ref<string | null>(null)
const loadingDetail = ref(false)
const detalles = ref<any>(null)
const showEmailDetails = ref(false)

const copyToClipboard = async (text: string, label: string) => {
  try {
    const textToCopy = text === 'null' || !text ? 'N/D' : text
    await navigator.clipboard.writeText(textToCopy)
    toast.success(`${label} copiado correctamente`)
  } catch (error) {
    console.error('Error al copiar:', error)
    toast.error('No se pudo copiar al portapapeles')
  }
}

const itemsOrdenados = computed(() => {
  if (!detalles.value?.items) return []
  return [...detalles.value.items].sort((a, b) => {
    const aAnio = a.marea.anioMarea || a.marea.anio_marea || 0
    const bAnio = b.marea.anioMarea || b.marea.anio_marea || 0
    const aNro = a.marea.nroMarea || a.marea.nro_marea || 0
    const bNro = b.marea.nroMarea || b.marea.nro_marea || 0
    
    if (aAnio !== bAnio) return aAnio - bAnio
    return aNro - bNro
  })
})

const copyAsPlainText = async (html: string, notas?: string) => {
  try {
    const parser = new DOMParser()
    const doc = parser.parseFromString(html, 'text/html')
    
    // Extraer filas de la tabla
    const rows = Array.from(doc.querySelectorAll('tr'))
    if (rows.length === 0) {
      // Si no hay tabla, copiar texto plano básico
      let content = doc.body.innerText
      if (notas) {
        content += `\n\nNOTAS O ACLARACIONES:\n${notas}`
      }
      await navigator.clipboard.writeText(content)
      toast.success('Contenido copiado como texto')
      return
    }

    // Calcular anchos de columna
    const tableData = rows.map(row => Array.from(row.querySelectorAll('th, td')).map(cell => (cell as HTMLElement).innerText.trim()))
    const colWidths = tableData[0].map((_, i) => Math.max(...tableData.map(row => row[i]?.length || 0)) + 4)

    // Formatear como tabla de texto
    const plainText = tableData.map(row => 
      row.map((cell, i) => cell.padEnd(colWidths[i])).join('')
    ).join('\n')

    let finalResult = `NOTIFICACIÓN DE ENVÍO DE INFORMES DE MAREA\n\n${plainText}`
    
    if (notas) {
      finalResult += `\n\nNOTAS O ACLARACIONES:\n${notas}`
    }

    finalResult += `\n\nEnviado desde SIGMA - INIDEP`
    
    await navigator.clipboard.writeText(finalResult)
    toast.success('Tabla copiada como texto alineado')
  } catch (error) {
    console.error('Error al convertir a texto:', error)
    toast.error('No se pudo formatear el texto')
  }
}

const lotesProcesados = computed(() => {
  return [...props.lotes]
    .sort((a, b) => new Date(a.fechaEnvio).getTime() - new Date(b.fechaEnvio).getTime())
    .map((lote, index) => ({
      ...lote,
      numeroLote: index + 1
    }))
    .sort((a, b) => new Date(b.fechaEnvio).getTime() - new Date(a.fechaEnvio).getTime())
})

const selectLote = async (lote: any) => {
  selectedLoteId.value = lote.id
  loadingDetail.value = true
  detalles.value = null

  try {
    const data = await mareasService.getProtocolizacionLoteDetalle(lote.id)
    detalles.value = {
      ...data,
      numeroLote: lote.numeroLote
    }
  } catch (error) {
    console.error('Error cargando detalle del lote:', error)
  } finally {
    loadingDetail.value = false
  }
}

const formatMareaCode = (marea: any) => {
  if (!marea) return '---'
  const nro = marea.nroMarea || marea.nro_marea
  const anio = marea.anioMarea || marea.anio_marea
  return `${nro}/${anio}`
}

const shouldShowDateHeader = (lote: any, index: number) => {
  if (index === 0) return true
  const prevLote = lotesProcesados.value[index - 1]
  const currentDate = new Date(lote.fechaEnvio).toLocaleDateString()
  const prevDate = new Date(prevLote.fechaEnvio).toLocaleDateString()
  return currentDate !== prevDate
}

const formatDateGroup = (dateStr: string) => {
  return new Date(dateStr).toLocaleDateString('es-AR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  })
}
</script>

<style scoped>
.historial-container {
  animation: fadeIn 0.4s ease-out;
}

.email-preview-content {
  font-family: 'Inter', ui-sans-serif, system-ui, sans-serif;
  font-size: 11px;
  line-height: 1.6;
  color: var(--color-text);
}

.email-preview-content h3 {
  color: var(--color-primary);
  font-weight: 800;
  text-transform: uppercase;
  margin-bottom: 1rem;
  font-size: 14px;
}

.email-preview-content table {
  width: 100%;
  border-collapse: collapse;
  margin: 1.5rem 0;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  overflow: hidden;
}

.email-preview-content th {
  background-color: var(--color-surface-muted);
  color: var(--color-text-muted);
  font-weight: 800;
  text-transform: uppercase;
  font-size: 10px;
  padding: 10px;
  text-align: left;
  border-bottom: 2px solid var(--color-border);
}

.email-preview-content td {
  padding: 10px;
  border-bottom: 1px solid rgba(var(--color-border), 0.5);
}

.email-preview-content tr:last-child td {
  border-bottom: none;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.animate-fade-in {
  animation: fadeInDetail 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes fadeInDetail {
  from { opacity: 0; transform: translateX(20px); }
  to { opacity: 1; transform: translateX(0); }
}

.animate-scale-in {
  animation: scaleIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
}

@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

.slide-fade-enter-active, .slide-fade-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-fade-enter-from, .slide-fade-leave-to {
  opacity: 0;
  transform: translateX(10px);
}

.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-primary-muted);
  border-radius: 10px;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: var(--color-primary);
}
</style>
