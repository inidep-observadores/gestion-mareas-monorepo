// Color mapping for calendar events using Tailwind theme variables
// This file provides a centralized color configuration for all calendar event types

export const CALENDAR_EVENT_COLORS = {
  // Designaciones - Brand color (purple)
  designacion: 'rgb(70, 95, 255)', // brand-500

  // Zarpadas - Blue
  zarpada: 'rgb(59, 130, 246)', // blue-500

  // Arribos - Success green
  arribo: 'rgb(16, 185, 129)', // success-500 / green-500

  // Informes - Orange
  informe: 'rgb(251, 101, 20)', // orange-500

  // Validaciones - Warning yellow
  validacion: 'rgb(247, 144, 9)', // warning-500

  // Alertas - Error red
  alerta: 'rgb(240, 68, 56)', // error-500

  // Reuniones - Indigo
  reunion: 'rgb(99, 102, 241)', // indigo-500

  // Navegación - Cyan/Purple variants
  navegacionCyan: 'rgb(6, 182, 212)', // cyan-500
  navegacionPurple: 'rgb(139, 92, 246)', // purple-500
} as const

export type EventType = keyof typeof CALENDAR_EVENT_COLORS
