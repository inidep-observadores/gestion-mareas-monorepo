<script setup lang="ts">
import { ref, watch } from 'vue';
import {
    X,
    Terminal,
    Box,
    AlertCircle,
    Info,
    ChevronDown,
    ChevronUp
} from 'lucide-vue-next';
import type { JobQueue } from '../interfaces/job-queue.interface';

const props = defineProps<{
    job: JobQueue | null;
    visible: boolean;
}>();

const emit = defineEmits(['update:visible']);

const activeTab = ref('payload');

const close = () => {
    emit('update:visible', false);
};

const formatJSON = (json: any) => {
    try {
        return JSON.stringify(json, null, 2);
    } catch (e) {
        return String(json);
    }
};
</script>

<template>
    <div v-if="visible && job"
        class="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm transition-all">
        <div
            class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] flex flex-col overflow-hidden animate-in fade-in zoom-in duration-200">
            <!-- Header -->
            <div class="p-6 border-b border-slate-100 flex justify-between items-start bg-slate-50/50">
                <div class="space-y-1">
                    <div class="flex items-center gap-2">
                        <span
                            class="text-xs font-mono bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded uppercase tracking-wider">
                            {{ job.type }}
                        </span>
                        <span class="text-xs text-slate-400 font-mono">{{ job.id }}</span>
                    </div>
                    <h2 class="text-xl font-bold text-slate-800">Detalles de la Tarea</h2>
                </div>
                <button @click="close" class="p-2 hover:bg-slate-200 rounded-full transition-colors text-slate-500">
                    <X class="w-5 h-5" />
                </button>
            </div>

            <!-- Tabs -->
            <div class="flex border-b border-slate-100 px-6">
                <button @click="activeTab = 'payload'"
                    :class="[activeTab === 'payload' ? 'border-primary text-primary border-b-2' : 'border-transparent text-slate-500 hover:text-slate-700', 'px-4 py-3 text-sm font-semibold transition-all']">
                    <div class="flex items-center gap-2">
                        <Box class="w-4 h-4" />
                        Payload
                    </div>
                </button>
                <button @click="activeTab = 'result'"
                    :class="[activeTab === 'result' ? 'border-primary text-primary border-b-2' : 'border-transparent text-slate-500 hover:text-slate-700', 'px-4 py-3 text-sm font-semibold transition-all']">
                    <div class="flex items-center gap-2">
                        <Terminal class="w-4 h-4" />
                        Resultado
                    </div>
                </button>
                <button v-if="job.errorMessage" @click="activeTab = 'error'"
                    :class="[activeTab === 'error' ? 'border-rose-500 text-rose-600 border-b-2' : 'border-transparent text-slate-500 hover:text-rose-500', 'px-4 py-3 text-sm font-semibold transition-all']">
                    <div class="flex items-center gap-2">
                        <AlertCircle class="w-4 h-4" />
                        Error
                    </div>
                </button>
            </div>

            <!-- Content Area -->
            <div class="flex-1 overflow-y-auto p-6 bg-slate-50/30">
                <!-- Payload Tab -->
                <div v-show="activeTab === 'payload'" class="space-y-4 animate-in slide-in-from-right-2">
                    <div v-if="job.payload" class="bg-slate-900 rounded-xl p-4 overflow-x-auto shadow-inner">
                        <pre class="text-sm text-indigo-300 font-mono">{{ formatJSON(job.payload) }}</pre>
                    </div>
                    <div v-else class="text-center py-8 text-slate-400 italic">
                        Sin payload de entrada
                    </div>
                </div>

                <!-- Result Tab -->
                <div v-show="activeTab === 'result'" class="space-y-4 animate-in slide-in-from-right-2">
                    <div v-if="job.result" class="bg-slate-900 rounded-xl p-4 overflow-x-auto shadow-inner">
                        <pre class="text-sm text-emerald-300 font-mono">{{ formatJSON(job.result) }}</pre>
                    </div>
                    <div v-else class="text-center py-8 text-slate-400 italic">
                        Sin resultados todavía
                    </div>

                    <div class="grid grid-cols-2 gap-4 mt-6">
                        <div class="p-3 bg-white border border-slate-200 rounded-lg shadow-sm">
                            <span class="text-[10px] uppercase text-slate-400 font-bold block mb-1">Duración</span>
                            <span class="text-lg font-bold text-slate-700">{{ job.duration ? job.duration + 'ms' : '-'
                                }}</span>
                        </div>
                        <div class="p-3 bg-white border border-slate-200 rounded-lg shadow-sm">
                            <span class="text-[10px] uppercase text-slate-400 font-bold block mb-1">Worker</span>
                            <span class="text-lg font-bold text-slate-700 truncate block">{{ job.workerId || 'Auto'
                                }}</span>
                        </div>
                    </div>
                </div>

                <!-- Error Tab -->
                <div v-show="activeTab === 'error'" class="space-y-4 animate-in slide-in-from-right-2">
                    <div class="flex items-start gap-3 p-4 bg-rose-50 border border-rose-100 rounded-xl text-rose-800">
                        <AlertCircle class="w-5 h-5 flex-shrink-0 mt-0.5" />
                        <p class="font-medium">{{ job.errorMessage }}</p>
                    </div>
                    <div v-if="job.stackTrace" class="bg-slate-900 rounded-xl p-4 overflow-x-auto shadow-inner">
                        <h4 class="text-slate-500 text-[10px] uppercase font-bold mb-3">Stack Trace</h4>
                        <pre class="text-xs text-rose-300 font-mono leading-relaxed">{{ job.stackTrace }}</pre>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="p-4 border-t border-slate-100 bg-white flex justify-end">
                <button @click="close"
                    class="px-6 py-2 bg-slate-800 text-white rounded-lg font-bold hover:bg-slate-700 transition-colors shadow-lg">
                    Cerrar
                </button>
            </div>
        </div>
    </div>
</template>
