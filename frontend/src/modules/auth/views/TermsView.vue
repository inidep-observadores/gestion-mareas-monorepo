<template>
  <FullScreenLayout>
    <div class="min-h-screen bg-gray-50 dark:bg-gray-950 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-3xl mx-auto bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-800 p-8 sm:p-12">
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-8">Términos y Condiciones</h1>
        
        <div class="max-w-none space-y-6 text-gray-600 dark:text-gray-400 leading-relaxed text-sm">
          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">1. Aceptación de los Términos</h2>
            <p>Al acceder y utilizar el Sistema de Gestión de Mareas del INIDEP, usted acepta estar sujeto a estos Términos y Condiciones de Uso. Si no está de acuerdo con alguno de estos términos, le solicitamos que no utilice el sistema.</p>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">2. Uso del Sistema</h2>
            <p>Este sistema está destinado exclusivamente al personal autorizado y observadores a bordo del INIDEP. Los usuarios son responsables de mantener la confidencialidad de sus credenciales de acceso y de toda la actividad que ocurra bajo su cuenta.</p>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">3. Integridad de los Datos</h2>
            <p>Usted se compromete a ingresar información veraz, precisa y completa. Cualquier alteración deliberada de los datos científicos u operativos será considerada una falta grave y podrá resultar en la revocación del acceso y acciones administrativas correspondientes.</p>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">4. Propiedad Intelectual</h2>
            <p>Todos los datos recolectados a través de este sistema son propiedad del INIDEP y están sujetos a las leyes nacionales de protección de datos científicos y propiedad del Estado.</p>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">5. Limitación de Responsabilidad</h2>
            <p>El INIDEP no se hace responsable por interrupciones en el servicio debidas a fallas técnicas externas o situaciones de fuerza mayor, aunque se compromete a mantener la máxima disponibilidad del sistema.</p>
          </section>
        </div>

        <div class="mt-12 pt-8 border-t border-gray-100 dark:border-gray-800 flex justify-center">
          <button @click="closeWindow" class="bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 px-6 py-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors font-medium">Cerrar esta página</button>
        </div>
      </div>
    </div>
  </FullScreenLayout>
</template>

<script setup lang="ts">
import FullScreenLayout from '@/components/layout/FullScreenLayout.vue';

const closeWindow = () => {
  window.close();
};
</script>
