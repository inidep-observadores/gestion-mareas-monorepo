<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue';
import { Timeline } from 'vis-timeline/standalone';
import { DataSet } from 'vis-data';
import type { TimelineOptions } from 'vis-timeline';
import { useConfigStore } from '@/modules/shared/stores/config.store';
import { getBloqueLabel, getItemVisClass, formatItemTooltip } from '@/modules/shared/utils/timeline-styles';
import { toast } from 'vue-sonner';

const props = defineProps<{
  mode: 'observador' | 'buque';
  groups: any[];
  items: any[];
}>();

const emit = defineEmits<{
  (e: 'item-moved', payload: { id: string; start: Date; end: Date; group: string; isReal: boolean }): void;
  (e: 'item-removed', id: string): void;
  (e: 'drop-recurso', payload: { recurso: any; group: string; date: Date }): void;
  (e: 'edit-item', id: string): void;
}>();

const timelineRef = ref<HTMLElement | null>(null);
let timelineInstance: Timeline | null = null;
let currentGroupsDataSet = new DataSet<any>();
let currentItemsDataSet = new DataSet<any>();

const configStore = useConfigStore();

const initTimeline = () => {
  if (!timelineRef.value) return;

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  let dataStart = new Date(today.getFullYear(), today.getMonth() - 2, 1);
  let dataEnd = new Date(today.getFullYear(), today.getMonth() + 4, 0);

  let visibleStart = new Date(today.getFullYear(), today.getMonth() - 1, 1);
  let visibleEnd = new Date(today.getFullYear(), today.getMonth() + 3, 0);

  // Centrar en la fecha actual
  // dataStart / dataEnd ya están centrados en el mes actual
  // visibleStart / visibleEnd se calculan relativos a today

  currentGroupsDataSet = new DataSet(props.groups);
  currentItemsDataSet = new DataSet(props.items);

  const options: TimelineOptions = {
    locale: 'es',
    groupOrder: 'value',
    stack: false,
    maxHeight: '65vh',
    verticalScroll: true,
    horizontalScroll: true,
    zoomKey: 'ctrlKey',
    zoomMin: 1000 * 60 * 60 * 24 * 2,
    zoomMax: 1000 * 60 * 60 * 24 * 31 * 3,
    margin: { item: 8, axis: 8 },
    orientation: 'top',
    editable: {
      updateTime: true,
      updateGroup: true,
      remove: true,
      add: true,
      overrideItems: false
    },
    showCurrentTime: true,
    timeAxis: { scale: 'day', step: 1 },
    snap: function (date: Date) {
      const clone = new Date(date.valueOf());
      clone.setHours(0, 0, 0, 0);
      return clone;
    },
    tooltip: {
      followMouse: true,
      overflowMethod: 'cap'
    },
    start: visibleStart,
    end: visibleEnd,
    min: dataStart,
    max: dataEnd,
    onAdd: (item: any, callback: any) => {
      // Prevent double click creation
      callback(null);
    },
    onMoving: (item: any, callback: any) => {
      if (item.id && item.id.toString().startsWith('real-')) {
        const orig = currentItemsDataSet.get(item.id) as any;
        if (orig && orig.className && orig.className.includes('vis-item-navegando')) {
          item.start = orig.start;
          item.group = orig.group;
        } else if (orig && orig.className && orig.className.includes('vis-item-designada')) {
          item.group = orig.group;
        }
      }

      const today = new Date();
      today.setHours(0, 0, 0, 0);
      if (item.start < today) {
        const diff = item.end.getTime() - item.start.getTime();
        item.start = today;
        item.end = new Date(today.getTime() + diff);
      }

      if (item.content && item.start && item.end) {
        const newDuration = Math.round((new Date(item.end).getTime() - new Date(item.start).getTime()) / 86400000);
        item.content = item.content.replace(/\[\d+d\]/, `[${newDuration}d]`);
        const finInclusivo = new Date(new Date(item.end).getTime() - 86400000);
        item.title = `<strong>Inicio:</strong> ${new Date(item.start).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`;
      }

      callback(item);
    },
    onUpdate: (item: any, callback: any) => {
      emit('edit-item', item.id);
      callback(null);
    },
    onMove: (item: any, callback: any) => {
      if (String(item.group).startsWith('pesqueria-')) {
        toast.error('No se puede asignar a un encabezado de pesquería. Debe soltar el bloque sobre un buque.');
        callback(null);
        return;
      }

      if (item.content && item.start && item.end) {
        const newDuration = Math.round((new Date(item.end).getTime() - new Date(item.start).getTime()) / 86400000);
        item.content = item.content.replace(/\[\d+d\]/, `[${newDuration}d]`);
        const finInclusivo = new Date(new Date(item.end).getTime() - 86400000);
        item.title = `<strong>Inicio:</strong> ${new Date(item.start).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`;
      }

      const isReal = item.id && item.id.toString().startsWith('real-');
      emit('item-moved', {
        id: item.id,
        start: item.start,
        end: item.end,
        group: String(item.group),
        isReal
      });

      callback(item);
    },
    onRemove: (item: any, callback: any) => {
      if (item.id && item.id.toString().startsWith('real-')) {
        toast.error('No se pueden eliminar las mareas reales desde la simulación');
        callback(null);
        return;
      }
      emit('item-removed', item.id);
      callback(item);
    }
  };

  timelineInstance = new Timeline(timelineRef.value, currentItemsDataSet, currentGroupsDataSet, options);

};

const onDrop = (e: DragEvent) => {
  e.preventDefault();
  e.stopPropagation();
  const data = e.dataTransfer?.getData('application/json');
  if (!data || !timelineInstance) {
    return;
  }

  try {
    const recurso = JSON.parse(data);
    if (recurso.type !== 'buque') {
      return;
    }

    const props = timelineInstance.getEventProperties(e);
    
    if (props.group && props.time) {
      if (String(props.group).startsWith('pesqueria-')) {
        toast.error('No se puede asignar un recurso directamente al encabezado de la pesquería. Debe soltarlo sobre un buque.');
        return;
      }
      emit('drop-recurso', {
        recurso,
        group: String(props.group),
        date: new Date(props.time)
      });
    } else {
    }
  } catch (err) {
    console.error('[SimuladorTimeline] Error procesando drop', err);
  }
};

watch(() => props.groups, (newGroups) => {
  if (currentGroupsDataSet) {
    const currentIds = currentGroupsDataSet.getIds();
    const newIds = newGroups.map(g => g.id);
    const toRemove = currentIds.filter(id => !newIds.includes(id));
    if (toRemove.length > 0) currentGroupsDataSet.remove(toRemove);
    currentGroupsDataSet.update(newGroups);
  }
}, { deep: true });

watch(() => props.items, (newItems) => {
  if (currentItemsDataSet) {
    const currentIds = currentItemsDataSet.getIds();
    const newIds = newItems.map(i => i.id);
    const toRemove = currentIds.filter(id => !newIds.includes(id));
    if (toRemove.length > 0) currentItemsDataSet.remove(toRemove);
    currentItemsDataSet.update(newItems);
  }
}, { deep: true });

onMounted(() => {
  nextTick(() => {
    initTimeline();
  });
});

onBeforeUnmount(() => {
  if (timelineInstance) {
    timelineInstance.destroy();
    timelineInstance = null;
  }
});

defineExpose({
  getTimelineInstance: () => timelineInstance,
  redraw: () => {
    if (timelineInstance) {
      timelineInstance.redraw();
    }
  }
});
</script>

<template>
  <div 
    ref="timelineRef" 
    class="w-full h-full bg-white timeline-wrapper simulador-timeline"
    @dragover.capture.prevent
    @dragenter.capture.prevent
    @drop.capture="onDrop"
  ></div>
</template>

<style scoped>
.timeline-wrapper {
  /* Scope it nicely */
  width: 100%;
  height: 100%;
  min-height: 400px;
}
</style>
