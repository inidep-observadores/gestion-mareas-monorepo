---
name: visual-designing
description: 视觉设计工具箱 - Canvas / Temas / Sistema de Diseño / Artefactos. El motor de diseño visual unificado para Antigravity.
---

# Sistema de Diseño Visual
*Motor de Diseño Unificado v1.0*

## Propósito
Una única fuente de verdad para todas las tareas de diseño UI/UX. Esta habilidad cambia inteligentemente entre "Eficiencia de Producción" (Estándar) y "Factor Wow" (Premium) según la intención del usuario.

## 🧭 Modos de Diseño

| Modo | Activador | Enfoque | Rasgos de Estilo |
| :--- | :--- | :--- | :--- |
| **Estándar (Producción)** | "crear un dashboard", "formulario de login", "página de ajustes" | Usabilidad, Velocidad, Accesibilidad | Prioridad a utilidades de Tailwind, blancos/oscuros limpios, componentes estándar. |
| **Premium (Estético)** | "premium", "glassmorfismo", "sorpréndeme", "landing page" | Impacto Visual, Emoción, Marca | Efectos de cristal, degradados Aurora, micro-interacciones, variables CSS personalizadas. |

## 🛠️ Protocolo de Ejecución

1.  **Analizar Intención Estética**: ¿El usuario quiere una herramienta sólida (Estándar) o una pieza de arte (Premium)?
2.  **Cargar Recursos (Solo Premium)**:
    - Si se solicita Premium/Cristal/Movimiento, **DEBES** leer los recursos de componentes glass, paletas premium y micro-interacciones.
3.  **Generar CSS/Tailwind**:
    - **Estándar**: Usa Tailwind estándar (`bg-white`, `text-slate-900`, `rounded-lg`).
    - **Premium**: Usa `backdrop-filter`, `bg-white/10`, `border-white/20` y animaciones personalizadas.

## 📐 Principios Core (Todos los modos)
1.  **Móvil Primero**: Siempre responsivo.
2.  **Preparado para Modo Oscuro**: Todos los colores específicos deben tener equivalentes en modo oscuro.
3.  **Accesibilidad**: Sin texto de contraste ultra bajo, incluso en modo "Premium".

## 🚫 Anti-Patrones
- **Mezclar Metáforas**: No pongas una tarjeta de cristal hiperrealista dentro de un dashboard de diseño plano/material. Cómpremete con un solo estilo.
- **Sobre-Animación**: El movimiento debe facilitar la comprensión, no distraer.
