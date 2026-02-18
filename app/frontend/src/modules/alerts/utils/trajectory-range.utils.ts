export const TrajectoryRangeUtils = {
    /**
     * Normaliza una fecha a string ISO manejando posibles objetos anidados de base de datos
     * Ej: { $type: "DateTime", value: "..." }
     */
    normalize(date: any): string {
        if (!date) return ''
        let d: Date
        if (typeof date === 'object' && date.value && date.$type === 'DateTime') {
            d = new Date(date.value)
        } else {
            d = new Date(date)
        }

        if (isNaN(d.getTime())) {
            return typeof date === 'string' ? date : ''
        }
        return d.toISOString()
    },

    /**
     * Detecta si una fecha tiene componente de hora significativo (no es solo medianoche)
     */
    hasTime(date: any): boolean {
        if (!date) return false
        const dStr = typeof date === 'string' ? date : this.normalize(date)

        // Si es un string YYYY-MM-DD puro sin T ni espacio ni :, no tiene hora
        if (typeof date === 'string' && !date.includes('T') && !date.includes(':') && !date.includes(' ')) {
            return false
        }

        const d = new Date(dStr)
        if (isNaN(d.getTime())) return false

        // Si el string original contiene 'Z' o '+', lo tratamos como UTC/ISO
        const isISO = dStr.includes('T') || dStr.includes('Z') || dStr.includes('+')

        if (isISO) {
            return d.getUTCHours() !== 0 || d.getUTCMinutes() !== 0 || d.getUTCSeconds() !== 0
        } else {
            // Formatos locales como '2026-02-17 15:45'
            return d.getHours() !== 0 || d.getMinutes() !== 0 || d.getSeconds() !== 0
        }
    },

    /**
     * Resuelve el rango de fechas (referencia y fin) desde un objeto de alerta o movimiento.
     * Prioriza eventDate en metadatos.
     */
    resolveAlertDates(alert: any): { referenceDate: string; endDate: string | null } {
        const meta = alert?.metadata || {}

        // 1. Prioridad: Fecha específica del evento en metadatos
        let referenceDate = meta.eventDate || meta.fechaZarpada || meta.date || alert?.fechaDetectada || ''

        // 2. Resolver endDate (si es un rango)
        let endDate = meta.fechaArribo || null

        // 3. Casos especiales de incongruencia (donde tenemos fechas locales vs externas)
        if (meta.subTipo === 'INCONGRUENCIA' || meta.subTipo === 'EDITAR_ETAPA') {
            const startDates = [meta.fechaZarpada, meta.localData?.fechaZarpada].filter(d => !!d)
            if (startDates.length > 0) {
                referenceDate = new Date(Math.min(...startDates.map(d => new Date(this.normalize(d)).getTime()))).toISOString()
            }

            const endDates = [meta.fechaArribo, meta.localData?.fechaArribo].filter(d => !!d)
            if (endDates.length > 0) {
                endDate = new Date(Math.max(...endDates.map(d => new Date(this.normalize(d)).getTime()))).toISOString()
            }
        }

        return {
            referenceDate: this.normalize(referenceDate),
            endDate: endDate ? this.normalize(endDate) : null
        }
    },

    /**
     * Calcula el rango real de búsqueda para la API (con buffers)
     */
    calculateFetchRange(referenceDate: string, endDate: string | null, bufferHours: number = 6): { from: Date; to: Date } {
        const start = new Date(this.normalize(referenceDate))
        let end = endDate ? new Date(this.normalize(endDate)) : start

        // Si no tiene hora (es fecha calendario), expandir a día completo
        if (!this.hasTime(referenceDate)) {
            start.setUTCHours(0, 0, 0, 0)
            if (!endDate) {
                end = new Date(start)
                end.setUTCHours(23, 59, 59, 999)
            }
        }

        // Aplicar buffers
        const from = new Date(start.getTime() - bufferHours * 60 * 60 * 1000)
        const to = new Date(end.getTime() + bufferHours * 60 * 60 * 1000)

        return { from, to }
    }
}
