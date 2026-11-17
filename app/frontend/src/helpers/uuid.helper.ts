/**
 * Genera un identificador único UUID v4 con compatibilidad universal.
 * Funciona tanto en contextos seguros (HTTPS, localhost) como no seguros (HTTP por IP privada, ej: http://10.0.64.46),
 * donde los navegadores restringen window.crypto.randomUUID().
 */

function fallbackUUID(): string {
  if (typeof crypto !== 'undefined' && typeof crypto.getRandomValues === 'function') {
    return (([1e7] as any) + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (c: number) =>
      (c ^ (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4)))).toString(16)
    );
  }

  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

// Guardamos referencia a la función nativa antes de cualquier polyfill para evitar recursión
const nativeRandomUUID =
  typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function'
    ? crypto.randomUUID.bind(crypto)
    : null;

export function generateUUID(): string {
  if (nativeRandomUUID) {
    try {
      return nativeRandomUUID();
    } catch {
      // Si el navegador falla al invocar el nativo en contexto no seguro
    }
  }
  return fallbackUUID();
}

// Auto-instalar polyfill en window.crypto si randomUUID no está disponible
if (typeof crypto !== 'undefined') {
  try {
    if (typeof crypto.randomUUID !== 'function') {
      Object.defineProperty(crypto, 'randomUUID', {
        value: fallbackUUID,
        writable: true,
        configurable: true,
      });
    }
  } catch {
    try {
      (crypto as any).randomUUID = fallbackUUID;
    } catch {
      // Ignorar si el objeto está sellado
    }
  }
}
