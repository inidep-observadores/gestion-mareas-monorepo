<template>
  <FullScreenLayout>
    <div class="min-h-screen bg-surface-muted py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-3xl mx-auto bg-surface rounded-2xl shadow-sm border border-border p-8 sm:p-12">
        <h1 class="text-3xl font-black text-text mb-8 uppercase tracking-tight">Términos y Condiciones</h1>
        
        <div class="max-w-none space-y-6 text-text-muted leading-relaxed text-sm">
          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">1. Aceptación de los Términos</h2>
            <p>Al acceder y utilizar el Sistema de Gestión de Mareas del INIDEP, usted acepta estar sujeto a estos Términos y Condiciones de Uso. Si no está de acuerdo con alguno de estos términos, le solicitamos que no utilice el sistema.</p>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">2. Uso del Sistema</h2>
            <p>Este sistema está destinado exclusivamente al personal autorizado y observadores a bordo del INIDEP. Los usuarios son responsables de mantener la confidencialidad de sus credenciales de acceso y de toda la actividad que ocurra bajo su cuenta.</p>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">3. Integridad de los Datos</h2>
            <p>Usted se compromete a ingresar información veraz, precisa y completa. Cualquier alteración deliberada de los datos científicos u operativos será considerada una falta grave y podrá resultar en la revocación del acceso y acciones administrativas correspondientes.</p>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">4. Propiedad Intelectual</h2>
            <p>Todos los datos recolectados a través de este sistema son propiedad del INIDEP y están sujetos a las leyes nacionales de protección de datos científicos y propiedad del Estado.</p>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">5. Limitación de Responsabilidad</h2>
            <p>El INIDEP no se hace responsable por interrupciones en el servicio debidas a fallas técnicas externas o situaciones de fuerza mayor, aunque se compromete a mantener la máxima disponibilidad del sistema.</p>
          </section>
        </div>

        <div class="mt-12 pt-8 border-t border-border flex justify-center">
          <button @click="closeWindow" class="bg-surface-muted text-text-muted px-6 py-2 rounded-lg hover:bg-border transition-all font-bold uppercase tracking-wider text-xs">Cerrar esta página</button>
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
