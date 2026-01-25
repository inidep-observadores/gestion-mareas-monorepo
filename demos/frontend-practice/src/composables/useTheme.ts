import { ref, watch, onMounted } from 'vue';

export type Theme = 'light' | 'dark' | 'system';

export function useTheme() {
  const themePreference = ref<Theme>((localStorage.getItem('theme-preference') as Theme) || 'system');
  const activeTheme = ref<'light' | 'dark'>('light');

  const updateActiveTheme = () => {
    if (themePreference.value === 'system') {
      const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      activeTheme.value = isDark ? 'dark' : 'light';
    } else {
      activeTheme.value = themePreference.value as 'light' | 'dark';
    }

    // Aplicar clase al body/html para selectores CSS globales
    document.documentElement.classList.remove('theme-dark', 'theme-light');
    document.documentElement.classList.add(`theme-${activeTheme.value}`);

    // También guardamos en localStorage para persistencia básica inmediata
    localStorage.setItem('theme-preference', themePreference.value);
  };

  const setTheme = (theme: Theme) => {
    themePreference.value = theme;
    updateActiveTheme();
  };

  onMounted(() => {
    updateActiveTheme();

    // Escuchar cambios del sistema si el modo es 'system'
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    const handler = () => {
      if (themePreference.value === 'system') {
        updateActiveTheme();
      }
    };

    mediaQuery.addEventListener('change', handler);
  });

  return {
    themePreference,
    activeTheme,
    setTheme
  };
}
