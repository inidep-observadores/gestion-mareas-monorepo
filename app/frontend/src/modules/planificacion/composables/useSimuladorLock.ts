import { ref, onMounted, onBeforeUnmount } from 'vue';
import { api } from '@/config/api';

export function useSimuladorLock(escenarioIdRef: import('vue').Ref<string | null>) {
  const isLockedByMe = ref(true);
  const lockedByOtherUser = ref('');
  const lockTabId = ref(crypto.randomUUID());
  
  let heartbeatInterval: ReturnType<typeof setInterval> | null = null;

  const tryAcquireLock = async (showModalIfFailed: (user: string) => void) => {
    if (!escenarioIdRef.value) return;

    try {
      const response = await api.post(`/planificacion/simulador/escenarios/${escenarioIdRef.value}/lock`, {
        tabId: lockTabId.value
      });
      if (response.data?.success) {
        isLockedByMe.value = true;
        startHeartbeat(showModalIfFailed);
      }
    } catch (error: any) {
      if (error.response?.status === 423 || error.response?.status === 409) {
        const lockUser = error.response.data?.lockedBy || 'otro usuario';
        isLockedByMe.value = false;
        lockedByOtherUser.value = lockUser;
        showModalIfFailed(lockUser);
      } else {
        console.error('Error al intentar adquirir el bloqueo del simulador:', error);
      }
    }
  };

  const startHeartbeat = (showModalIfFailed: (user: string) => void) => {
    if (heartbeatInterval) clearInterval(heartbeatInterval);
    
    // Heartbeat cada 45 segundos
    heartbeatInterval = setInterval(async () => {
      if (!escenarioIdRef.value || !isLockedByMe.value) {
        if (heartbeatInterval) clearInterval(heartbeatInterval);
        return;
      }
      
      try {
        await api.post(`/planificacion/simulador/escenarios/${escenarioIdRef.value}/lock`, {
          tabId: lockTabId.value
        });
      } catch (error: any) {
        if (error.response?.status === 423 || error.response?.status === 409) {
          // Perdimos el lock (ej: suspendimos la pc, venció y lo tomó otro)
          isLockedByMe.value = false;
          if (heartbeatInterval) clearInterval(heartbeatInterval);
          const lockUser = error.response.data?.lockedBy || 'otro usuario';
          lockedByOtherUser.value = lockUser;
          showModalIfFailed(lockUser);
        }
      }
    }, 45000);
  };

  const releaseLock = () => {
    if (heartbeatInterval) clearInterval(heartbeatInterval);
    if (!escenarioIdRef.value || !isLockedByMe.value) return;

    // SendBeacon es la forma mÃ¡s segura de enviar un request durante el beforeunload
    const token = localStorage.getItem('auth-token');
    const url = `${import.meta.env.VITE_API_URL}/planificacion/simulador/escenarios/${escenarioIdRef.value}/lock?tabId=${lockTabId.value}`;
    
    const headers = {
      type: 'application/json',
    };
    
    // Usamos fetch con keepalive para el unmount normal o sendBeacon si estÃ¡ cerrando la tab
    try {
      fetch(url, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`
        },
        keepalive: true
      });
    } catch (e) {
      console.error('Error releasing lock', e);
    }
    
    isLockedByMe.value = false;
  };

  const handleBeforeUnload = () => {
    releaseLock();
  };

  // Se inicia desde el view explicitamente con showModalIfFailed para manejar alertas UI

  onBeforeUnmount(() => {
    releaseLock();
    window.removeEventListener('beforeunload', handleBeforeUnload);
  });

  onMounted(() => {
    window.addEventListener('beforeunload', handleBeforeUnload);
  });

  return {
    isLockedByMe,
    lockedByOtherUser,
    lockTabId,
    tryAcquireLock
  };
}
