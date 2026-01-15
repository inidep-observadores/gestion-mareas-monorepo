<template>
  <FullScreenLayout>
    <div class="min-h-screen bg-gray-50 dark:bg-gray-950 py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-3xl mx-auto bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-800 p-8 sm:p-12">
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-8">Política de Privacidad</h1>
        
        <div class="max-w-none space-y-6 text-gray-600 dark:text-gray-400 leading-relaxed text-sm">
          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">1. Información Recolectada</h2>
            <p>Para el funcionamiento del sistema, recolectamos datos de identificación personal como nombre completo, dirección de correo electrónico institucional y rol dentro de la organización.</p>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">2. Finalidad del Tratamiento</h2>
            <p>Sus datos se utilizan exclusivamente para:</p>
            <ul class="list-disc pl-5 space-y-2 mt-2">
              <li>Gestión de acceso y seguridad del sistema.</li>
              <li>Trazabilidad de la carga de datos de mareas.</li>
              <li>Comunicación operativa relevante para las funciones del observador.</li>
              <li>Generación de reportes institucionales.</li>
            </ul>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">3. Seguridad de los Datos</h2>
            <p>Implementamos medidas técnicas de encriptación y control de acceso para proteger su información contra pérdida, mal uso o acceso no autorizado.</p>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">4. Intercambio de Información</h2>
            <p>El INIDEP no comparte, vende ni alquila sus datos personales a terceros. La información científica anonimizada puede ser compartida con otros organismos de investigación siguiendo los protocolos institucionales vigentes.</p>
          </section>

          <section>
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mb-2">5. Derechos del Usuario</h2>
            <p>Usted tiene derecho a acceder, rectificar o solicitar la actualización de sus datos personales a través del administrador del sistema o el departamento de informática del INIDEP.</p>
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
