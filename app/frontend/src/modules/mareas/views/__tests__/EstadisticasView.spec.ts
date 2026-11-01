import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import EstadisticasView from '../EstadisticasView.vue'
import { statsService } from '@/modules/stats/services/stats.service'
import { planificacionService } from '@/modules/planificacion/services/planificacion.service'

vi.mock('vue-router', () => ({
   useRouter: () => ({ push: vi.fn(), replace: vi.fn() }),
   useRoute: () => ({ query: {} })
}))

vi.mock('vue-sonner', () => ({
   toast: { success: vi.fn(), error: vi.fn() }
}))

vi.mock('@/modules/stats/services/stats.service', () => ({
   statsService: {
      getDashboardStats: vi.fn(),
      getMareaDistribution: vi.fn(),
      getUniqueVesselsCount: vi.fn(),
      getDashboardStatsDetail: vi.fn(),
      downloadExport: vi.fn()
   }
}))

vi.mock('@/modules/planificacion/services/planificacion.service', () => ({
   planificacionService: {
      getRequerimientos: vi.fn().mockResolvedValue([]),
      getRequerimientosPorAnio: vi.fn().mockResolvedValue([])
   }
}))

// Stubs para subcomponentes visuales
const ChartWidgetStub = {
   name: 'ChartWidget',
   template: `
      <div class="chart-widget-stub">
         <div class="widget-title">{{ title }}</div>
         <slot name="header-action" />
      </div>
   `,
   props: ['title', 'subtitle', 'type', 'series', 'options', 'chartHeight', 'allowDownload']
}

const StatsFilterBarStub = {
   name: 'StatsFilterBar',
   template: '<div class="stats-filter-bar-stub"></div>',
   props: ['title', 'subtitle', 'loading', 'mode', 'protocolizedOnly', 'includeOutOfPeriod', 'daysCalculationMode', 'includeCampaigns']
}

const TimeFilterBarStub = {
   name: 'TimeFilterBar',
   template: '<div class="time-filter-bar-stub"></div>',
   props: ['year', 'startDate', 'endDate']
}

const AdminLayoutStub = {
   name: 'AdminLayout',
   template: '<div class="admin-layout-stub"><slot /></div>',
   props: ['title', 'description']
}

describe('EstadisticasView.vue - Cronograma de Distribución de Mareas (Gantt)', () => {
   const mockStats = {
      year: 2024,
      mode: 'CALENDAR' as const,
      totalMareas: 4,
      totalDaysNavigated: 80,
      avgDaysPerMarea: 20,
      monthly: { mareas: [1, 2, 1], days: [20, 40, 20] },
      fisheries: [
         { name: 'CALAMAR', mareas: 2, days: 40 },
         { name: 'LANGOSTINO', mareas: 2, days: 40 }
      ],
      fleets: [{ name: 'Congelador', mareas: 4, days: 80 }],
      observers: [{ name: 'Juan Perez', id: 'obs-1', mareas: 4, days: 80, active: true }],
      estimationDeviations: []
   }

   const mockDistribution = [
      {
         mareaId: 'm1',
         id_marea: 'MC-01-24',
         nroEtapa: 1,
         buque: 'BUQUE ALFA',
         flota: 'Congelador',
         pesqueria: 'CALAMAR',
         observador: 'Juan Perez',
         fechaZarpada: '2024-02-01T00:00:00Z',
         fechaArribo: '2024-02-20T00:00:00Z'
      },
      {
         mareaId: 'm2',
         id_marea: 'ML-02-24',
         nroEtapa: 1,
         buque: 'BUQUE ALFA',
         flota: 'Congelador',
         pesqueria: 'LANGOSTINO',
         observador: 'Juan Perez',
         fechaZarpada: '2024-03-01T00:00:00Z',
         fechaArribo: '2024-03-20T00:00:00Z'
      },
      {
         mareaId: 'm3',
         id_marea: 'MC-03-24',
         nroEtapa: 1,
         buque: 'BUQUE BETA',
         flota: 'Fresquero',
         pesqueria: 'CALAMAR',
         observador: 'Pedro Gomez',
         fechaZarpada: '2024-02-05T00:00:00Z',
         fechaArribo: '2024-02-25T00:00:00Z'
      }
   ]

   beforeEach(() => {
      vi.clearAllMocks()
      vi.mocked(statsService.getDashboardStats).mockResolvedValue(mockStats)
      vi.mocked(statsService.getMareaDistribution).mockResolvedValue(mockDistribution)
      vi.mocked(statsService.getUniqueVesselsCount).mockResolvedValue({
         count: 0,
         monthly: Array.from({ length: 12 }, (_, i) => ({
            month: i + 1,
            count: 0,
            days: 0,
            fleets: []
         }))
      })
   })

   const createWrapper = () => {
      return mount(EstadisticasView, {
         global: {
            plugins: [
               createTestingPinia({
                  initialState: {
                     config: {
                        selectedYear: 2024,
                        statsDetailViewMode: 'list'
                     }
                  }
               })
            ],
            stubs: {
               AdminLayout: AdminLayoutStub,
               ChartWidget: ChartWidgetStub,
               StatsFilterBar: StatsFilterBarStub,
               TimeFilterBar: TimeFilterBarStub,
               StatKpiCard: true,
               BaseModal: true,
               AuditAnalysisPanel: true,
               MareaQuickDetailModal: true
            }
         }
      })
   }

   it('renderiza el checkbox de agrupación y se encuentra habilitado cuando pesquería es ALL', async () => {
      const wrapper = createWrapper()
      await flushPromises()

      const checkbox = wrapper.find('input[type="checkbox"][disabled]')
      // Con ALL, no debe tener el atributo disabled
      expect(wrapper.find('input[type="checkbox"]').exists()).toBe(true)

      const groupCheckbox = wrapper.findAll('input[type="checkbox"]').find(input => {
         return input.element.closest('label')?.textContent?.includes('Agrupar por buque (sin pesquería)')
      })

      expect(groupCheckbox).toBeDefined()
      expect(groupCheckbox?.attributes('disabled')).toBeUndefined()
   })

   it('deshabilita y desmarca el checkbox si se selecciona una pesquería específica', async () => {
      const wrapper = createWrapper()
      await flushPromises()

      const groupCheckbox = wrapper.findAll('input[type="checkbox"]').find(input => {
         return input.element.closest('label')?.textContent?.includes('Agrupar por buque (sin pesquería)')
      })!

      // Marcar checkbox
      await groupCheckbox.setValue(true)
      expect(wrapper.vm.groupByVessel).toBe(true)

      // Cambiar filtro de pesquería a una específica
      wrapper.vm.selectedDistributionFishery = 'CALAMAR'
      await flushPromises()

      // Debe haberse reseteado a false y quedar disabled
      expect(wrapper.vm.groupByVessel).toBe(false)
      expect(groupCheckbox.attributes('disabled')).toBeDefined()
   })

   it('agrupa por buque en ganttSeries cuando groupByVessel es true', async () => {
      const wrapper = createWrapper()
      await flushPromises()

      // Estado inicial (sin agrupar): BUQUE ALFA tiene 2 entradas separadas (CALAMAR y LANGOSTINO)
      expect(wrapper.vm.groupByVessel).toBe(false)
      const seriesNormal = wrapper.vm.ganttSeries[0].data
      expect(seriesNormal).toHaveLength(3)
      // En modo normal, x es un array [buque, subLabel]
      expect(Array.isArray(seriesNormal[0].x)).toBe(true)

      // Activar agrupación por buque
      wrapper.vm.groupByVessel = true
      await flushPromises()

      const seriesGrouped = wrapper.vm.ganttSeries[0].data
      expect(seriesGrouped).toHaveLength(3)

      // En modo agrupado por buque, x es sólo el string del buque
      expect(seriesGrouped[0].x).toBe('BUQUE ALFA')
      expect(seriesGrouped[1].x).toBe('BUQUE ALFA')
      expect(seriesGrouped[2].x).toBe('BUQUE BETA')

      // Mantienen diferenciación de colores por pesquería
      expect(seriesGrouped[0].fillColor).toBe('#3B82F6') // CALAMAR
      expect(seriesGrouped[1].fillColor).toBe('#EF4444') // LANGOSTINO
   })
})
