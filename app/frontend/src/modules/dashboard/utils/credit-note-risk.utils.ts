import type { WorkforceStatus } from '../services/dashboard.service'

export function getCreditNoteRiskItems(data: WorkforceStatus | null) {
  if (!data || !data.listNavegando) return []

  return data.listNavegando.filter(item => {
    const isMonotributista = item.tipoContrato?.toUpperCase() === 'MONOTRIBUTISTA'
    const isLessThan15Days = item.days < 15

    // Pesquería Langostino O (Merluza Y Flota Altura Fresquero)
    const fisheryUpper = (item.fishery || '').toUpperCase()
    const isLangostino = fisheryUpper.includes('LANGOSTINO')
    const isMerluza = fisheryUpper.includes('MERLUZA')

    // Evaluamos el código de flota que añadimos en backend
    const fleetCode = item.fleetCode || ''
    const isFresqueroAltura = fleetCode === 'ALTURA_FRESQUERO'

    const validFishery = isLangostino || (isMerluza && isFresqueroAltura)

    return isMonotributista && isLessThan15Days && validFishery
  })
}

