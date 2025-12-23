<template>
  <AdminLayout>
    <!-- Background Clouds -->
    <Clouds />
    
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="grid grid-cols-12 gap-4 md:gap-6">
        <div class="col-span-12 space-y-6 xl:col-span-12">
           <div class="mb-6">
              <h1 class="text-2xl font-bold text-gray-800 dark:text-white/90">Panel de Control</h1>
              <p class="text-gray-500 dark:text-gray-400">Resumen general de las operaciones de marea.</p>
           </div>
        </div>

        <div class="col-span-12 space-y-6 xl:col-span-7">
          <EcommerceMetrics />
          <MonthlyTarget />
        </div>
        <div class="col-span-12 xl:col-span-5">
          <MonthlySale />
        </div>

        <div class="col-span-12">
          <StatisticsChart />
        </div>

        <div class="col-span-12 xl:col-span-5">
          <CustomerDemographic />
        </div>

        <div class="col-span-12 xl:col-span-7">
          <RecentOrders />
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from '@/components/layout/AdminLayout.vue'
import EcommerceMetrics from '@/components/ecommerce/EcommerceMetrics.vue'
import MonthlyTarget from '@/components/ecommerce/MonthlySale.vue'
import MonthlySale from '@/components/ecommerce/MonthlyTarget.vue'
import CustomerDemographic from '@/components/ecommerce/CustomerDemographic.vue'
import StatisticsChart from '@/components/ecommerce/StatisticsChart.vue'
import RecentOrders from '@/components/ecommerce/RecentOrders.vue'
import Clouds from '@/modules/shared/components/Clouds.vue'
</script>

<style scoped>
/* Estilos específicos para Professional Clean si es necesario */
</style>
