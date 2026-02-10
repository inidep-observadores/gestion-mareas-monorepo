<template>
  <AdminDashboardLayout
    title="Panel de Administración"
    description="Centro de control para la gestión de usuarios, auditoría y mantenimiento del sistema"
  >
    <div class="space-y-10">
      <!-- Sección: Gestión de Entidades -->
      <section>
        <div class="flex items-center gap-3 mb-6">
          <div class="p-2 rounded-xl bg-primary/10 text-primary">
            <UserCircleIcon class="w-5 h-5" />
          </div>
          <h2 class="text-xl font-bold text-text">Gestión de Entidades</h2>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <AdminHomeCard
            title="Gestión de Usuarios"
            description="Administra los accesos de personal, roles y permisos del sistema."
            :to="{ name: 'AdminUsers' }"
            :icon="UserGroupIcon"
            color="primary"
          />
          <AdminHomeCard
            title="Gestión de Buques"
            description="Control de la flota, características técnicas y armadores asociados."
            :to="{ name: 'AdminBuques' }"
            :icon="ShipIcon"
            color="primary"
          />
          <AdminHomeCard
            title="Gestión de Observadores"
            description="Registro oficial de observadores a bordo y su información técnica."
            :to="{ name: 'AdminObservadores' }"
            :icon="BeakerIcon"
            color="primary"
          />
        </div>
      </section>

      <!-- Sección: Auditoría e Integridad -->
      <section>
        <div class="flex items-center gap-3 mb-6">
          <div class="p-2 rounded-xl bg-warning/10 text-warning">
            <ShieldIcon class="w-5 h-5" />
          </div>
          <h2 class="text-xl font-bold text-text">Auditoría e Integridad</h2>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <AdminHomeCard
            title="Log de Errores"
            description="Monitoreo en tiempo real de excepciones y fallas críticas del servidor."
            :to="{ name: 'AdminErrorLogs' }"
            :icon="ErrorHexaIcon"
            color="warning"
          />
          <AdminHomeCard
            title="Centro de Auditoría"
            description="Registro histórico de navegación y acciones realizadas por los usuarios."
            :to="{ name: 'AdminAudit' }"
            :icon="HistoryIcon"
            color="warning"
          />
        </div>
      </section>

      <!-- Sección: Sistema y Mantenimiento -->
      <section>
        <div class="flex items-center gap-3 mb-6">
          <div class="p-2 rounded-xl bg-success/10 text-success">
            <SettingsIcon class="w-5 h-5" />
          </div>
          <h2 class="text-xl font-bold text-text">Sistema y Mantenimiento</h2>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-6">
          <AdminHomeCard
            title="Copia de Seguridad"
            description="Gestión de respaldos de base de datos y puntos de restauración."
            :to="{ name: 'AdminBackup' }"
            :icon="BackupIcon"
            color="success"
          />
          <AdminHomeCard
            title="Portabilidad de Datos"
            description="Exportación masiva de información en formatos estandarizados."
            :to="{ name: 'AdminDataExport' }"
            :icon="DownloadIcon"
            color="success"
          />
          <AdminHomeCard
            title="Importación Access"
            description="Herramientas de migración para datos desde bases Access heredadas."
            :to="{ name: 'AdminImportAccess' }"
            :icon="LayersIcon"
            color="success"
          />
          <AdminHomeCard
            title="Gestión de Tareas"
            description="Monitoreo y administración de procesos en segundo plano y sincronizaciones."
            :to="{ name: 'AdminJobs' }"
            :icon="TaskIcon"
            color="success"
          />
          <AdminHomeCard
            title="Gestión de Alertas"
            description="Supervisión y autoconfirmación masiva de alertas de zarpada y arribo."
            :to="{ name: 'AdminAlertsLog' }"
            :icon="BellIcon"
            color="success"
          />
        </div>
      </section>
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import AdminHomeCard from '../components/AdminHomeCard.vue';
import { 
  UserGroupIcon, 
  ShipIcon, 
  BeakerIcon, 
  ErrorHexaIcon, 
  ShieldIcon, 
  BackupIcon, 
  DownloadIcon, 
  LayersIcon,
  UserCircleIcon,
  HistoryIcon,
  SettingsIcon,
  TaskIcon,
  BellIcon
} from '@/icons';
</script>
