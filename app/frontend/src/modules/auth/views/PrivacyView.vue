<template>
  <FullScreenLayout>
    <div class="min-h-screen bg-surface-muted py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-3xl mx-auto bg-surface rounded-2xl shadow-sm border border-border p-8 sm:p-12">
        <h1 class="text-3xl font-black text-text mb-8 uppercase tracking-tight">Política de Privacidad</h1>
        
        <div class="max-w-none space-y-6 text-text-muted leading-relaxed text-sm">
          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">1. Información Recolectada</h2>
            <p>Para el funcionamiento del sistema, recolectamos datos de identificación personal como nombre completo, dirección de correo electrónico institucional y rol dentro de la organización.</p>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">2. Finalidad del Tratamiento</h2>
            <p>Sus datos se utilizan exclusivamente para:</p>
            <ul class="list-disc pl-5 space-y-2 mt-2">
              <li>Gestión de acceso y seguridad del sistema.</li>
              <li>Trazabilidad de la carga de datos de mareas.</li>
              <li>Comunicación operativa relevante para las funciones del observador.</li>
              <li>Generación de reportes institucionales.</li>
            </ul>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">3. Seguridad de los Datos</h2>
            <p>Implementamos medidas técnicas de encriptación y control de acceso para proteger su información contra pérdida, mal uso o acceso no autorizado.</p>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">4. Intercambio de Información</h2>
            <p>El INIDEP no comparte, vende ni alquila sus datos personales a terceros. La información científica anonimizada puede ser compartida con otros organismos de investigación siguiendo los protocolos institucionales vigentes.</p>
          </section>

          <section>
            <h2 class="text-xl font-bold text-text mb-2 uppercase tracking-tight">5. Derechos del Usuario</h2>
            <p>Usted tiene derecho a acceder, rectificar o solicitar la actualización de sus datos personales a través del administrador del sistema o el departamento de informática del INIDEP.</p>
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
