import { defineStore } from 'pinia'
import { ref } from 'vue'
import { EMPTY_BUSINESS_RULES, type BusinessRules } from '@/modules/shared/config/business-rules'
import { businessRulesService } from '@/modules/shared/services/business-rules.service'

export const useBusinessRulesStore = defineStore('businessRules', () => {
  const rules = ref<BusinessRules>({ ...EMPTY_BUSINESS_RULES })
  const loaded = ref(false)
  const failed = ref(false)

  const load = async () => {
    const data = await businessRulesService.getRules()
    rules.value = data
    loaded.value = true
    failed.value = false
  }


  return {
    rules,
    loaded,
    failed,
    load,
  }
})
