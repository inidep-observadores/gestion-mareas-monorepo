// Centralized chart color configuration using Tailwind theme variables
// This file provides consistent color palettes for all ApexCharts components

/**
 * Get computed CSS variable value at runtime
 * Useful for ApexCharts which requires color values as strings
 */
export function getCSSVariable(variable: string): string {
  return getComputedStyle(document.documentElement).getPropertyValue(variable).trim()
}

/**
 * Chart color palettes aligned with Tailwind theme
 */
export const CHART_COLORS = {
  // Primary brand colors for main data series
  brand: {
    primary: 'rgb(70, 95, 255)', // brand-500
    light: 'rgb(156, 185, 255)', // brand-300
    lighter: 'rgb(194, 214, 255)', // brand-200
  },

  // Success/positive metrics
  success: {
    primary: 'rgb(18, 183, 106)', // success-500
    light: 'rgb(108, 233, 166)', // success-300
  },

  // Error/negative metrics
  error: {
    primary: 'rgb(217, 45, 32)', // error-600
    light: 'rgb(253, 162, 155)', // error-300
  },

  // Warning/attention metrics
  warning: {
    primary: 'rgb(247, 144, 9)', // warning-500
    light: 'rgb(254, 200, 75)', // warning-300
  },

  // Neutral/gray for backgrounds and secondary data
  neutral: {
    primary: 'rgb(152, 162, 179)', // gray-400
    light: 'rgb(217, 217, 217)', // gray-300
  },
} as const

/**
 * Pre-defined color arrays for multi-series charts
 */
export const CHART_PALETTES = {
  // Primary palette for most charts
  primary: [CHART_COLORS.brand.primary, CHART_COLORS.brand.light],

  // Success-focused palette
  success: [CHART_COLORS.success.primary, CHART_COLORS.success.light],

  // Comparison palette (positive vs negative)
  comparison: [CHART_COLORS.success.primary, CHART_COLORS.error.primary],

  // Multi-series palette
  multiSeries: [
    CHART_COLORS.brand.primary,
    CHART_COLORS.brand.light,
    CHART_COLORS.success.primary,
    CHART_COLORS.warning.primary,
    CHART_COLORS.error.primary,
  ],
} as const

/**
 * Chart configuration defaults aligned with theme
 */
export const CHART_DEFAULTS = {
  fontFamily: 'Outfit, sans-serif',
  fontSize: '14px',
  colors: CHART_PALETTES.primary,

  // Grid and axis colors
  grid: {
    borderColor: 'rgb(226, 232, 240)', // gray-200
    borderColorDark: 'rgb(30, 41, 59)', // gray-800 for dark mode
  },

  // Tooltip colors
  tooltip: {
    background: 'rgb(255, 255, 255)',
    backgroundDark: 'rgb(17, 24, 39)', // gray-900 for dark mode
    borderColor: 'rgb(226, 232, 240)',
    borderColorDark: 'rgb(55, 65, 81)',
  },
} as const

export type ChartPalette = keyof typeof CHART_PALETTES
