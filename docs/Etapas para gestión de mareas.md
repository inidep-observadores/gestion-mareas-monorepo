## Etapas para gestión de mareas

Se proponen los siguientes estados, los cuales permiten realizar un seguimiento bastante fino:

# ✔ **CATEGORÍA: PENDIENTE**

### **1\. DESIGNADA**

La marea está planificada, con buque y observador asignados.  
Es el estado inicial.

### **2\. EN\_EJECUCION**

El observador está embarcado y la marea se está desarrollando.  
(Esto coincide con tu “predeterminada”).

### **3\. ESPERANDO\_ENTREGA**

El buque arribó, la marea terminó, **pero el observador aún no entregó los DBF/Excel**.  
Este estado es clave y muy realista en el flujo institucional.

### **4\. ENTREGADA / RECIBIDA**

El programa recibió los archivos, pero **aún no comenzó la verificación**.

> _Estas cuatro etapas representan perfectamente el tránsito real desde la designación hasta la recepción de datos._

# ✔ **CATEGORÍA: EN CURSO**

Aquí entra todo el trabajo técnico y administrativo interno.

### **5\. VERIFICACION\_INICIAL**

Primera revisión de los archivos recibidos:

*   se verifica integridad,
    
*   formato,
    
*   que estén todas las planillas, etc.
    

### **6\. EN\_CORRECCION**

Se abrió sesión de corrección interna (técnico de datos del INIDEP).  
En esta etapa se trabaja activamente con los DBF/Excel.

### **7\. DELEGADA\_EXTERNA**

La marea fue enviada al **laboratorio o proyecto correspondiente** para revisión/corrección externa.  
Esperando devolución.

### **8\. PENDIENTE\_DE\_INFORME**

Los datos ya están corregidos y validados;  
falta confeccionar el informe técnico.

### **9\. ESPERANDO\_REVISION**

El informe técnico fue enviado a revisión (coordinación o referentes).  
Este es el paso previo a protocolizar.

### **10\. PARA\_PROTOCOLIZAR**

El informe está **aprobado** y listo para iniciar trámite de protocolización.

### **11\. ESPERANDO\_PROTOCOLIZACION**

En proceso administrativo de protocolización.  
Es una etapa formal dentro del INIDEP.

> _Esta sección queda impecable: refleja el trabajo interno, externo y administrativo sin dejar huecos._

# ✔ **CATEGORÍA: COMPLETADO**

### **12\. PROTOCOLIZADA / FINALIZADA**

Flujo completo terminado.  
No permite edición.

# ✔ **CATEGORÍA: CANCELADO / DESESTIMADO**

### **13\. CANCELADA / DESESTIMADA**

La marea queda anulada por motivos administrativos o técnicos.  
Es un estado terminal alternativo.

# ✔ **LISTA ORDENADA FINAL**

Te dejo la lista depurada, con nombres listos para cargarse como catálogo:

### **PENDIENTE**

1.  **DESIGNADA**
    
2.  **EN\_EJECUCION**
    
3.  **ESPERANDO\_ENTREGA**
    
4.  **ENTREGADA\_RECIBIDA**
    

### **EN CURSO**

1.  **VERIFICACION\_INICIAL**
    
2.  **EN\_CORRECCION**
    
3.  **DELEGADA\_EXTERNA**
    
4.  **PENDIENTE\_DE\_INFORME**
    
5.  **ESPERANDO\_REVISION**
    
6.  **PARA\_PROTOCOLIZAR**
    
7.  **ESPERANDO\_PROTOCOLIZACION**
    

### **COMPLETADO**

1.  **PROTOCOLIZADA**
    

### **CANCELADO**

1.  **CANCELADA**
    

**Se propone el siguiente set de datos como para un Seed inicial:**

// PENDIENTE

1.  codigo: &#39;DESIGNADA&#39;  
    &nbsp; nombre: &#39;Designada&#39;  
      categoria: &#39;PENDIENTE&#39;  
      orden: 1  
      es\_inicial: true  
      es\_final: false  
      permite\_carga\_archivos: false  
      permite\_correccion: false  
      permite\_informe: false
    
2.  codigo: &#39;EN\_EJECUCION&#39;  
      nombre: &#39;En ejecución&#39;  
      categoria: &#39;PENDIENTE&#39;  
      orden: 2  
      es\_inicial: false  
      es\_final: false  
      permite\_carga\_archivos: false  
      permite\_correccion: false  
      permite\_informe: false
    
3.  codigo: &#39;ESPERANDO\_ENTREGA&#39;  
      nombre: &#39;Esperando entrega de datos&#39;  
      categoria: &#39;PENDIENTE&#39;  
      orden: 3  
      es\_inicial: false  
      es\_final: false  
      permite\_carga\_archivos: false   // todavía no se recibieron formalmente  
      permite\_correccion: false  
      permite\_informe: false
    
4.  codigo: &#39;ENTREGADA\_RECIBIDA&#39;  
      nombre: &#39;Entregada / Recibida&#39;  
      categoria: &#39;PENDIENTE&#39;  
      orden: 4  
      es\_inicial: false  
      es\_final: false  
      permite\_carga\_archivos: true    // se pueden subir/reemplazar archivos recibidos  
      permite\_correccion: false  
      permite\_informe: false
    

// EN CURSO  
5) codigo: &#39;VERIFICACION\_INICIAL&#39;  
  nombre: &#39;Verificación inicial&#39;  
  categoria: &#39;EN\_CURSO&#39;  
  orden: 5  
  es\_inicial: false  
  es\_final: false  
  permite\_carga\_archivos: true  
  permite\_correccion: false  
  permite\_informe: false

1.  codigo: &#39;EN\_CORRECCION&#39;  
      nombre: &#39;En corrección interna&#39;  
      categoria: &#39;EN\_CURSO&#39;  
      orden: 6  
      es\_inicial: false  
      es\_final: false  
      permite\_carga\_archivos: true  
      permite\_correccion: true        // aquí se abren sesiones de corrección  
      permite\_informe: false
    
2.  codigo: &#39;DELEGADA\_EXTERNA&#39;  
      nombre: &#39;Delegada / En espera externa&#39;  
      categoria: &#39;EN\_CURSO&#39;  
      orden: 7  
      es\_inicial: false  
      es\_final: false  
      permite\_carga\_archivos: true    // puede volver corregida desde afuera  
      permite\_correccion: false       // corrección la hacen fuera del sistema  
      permite\_informe: false
    
3.  codigo: &#39;PENDIENTE\_DE\_INFORME&#39;  
      nombre: &#39;Pendiente de informe&#39;  
      categoria: &#39;EN\_CURSO&#39;  
      orden: 8  
      es\_inicial: false  
      es\_final: false  
      permite\_carga\_archivos: false  
      permite\_correccion: false       // en principio datos ya cerrados  
      permite\_informe: true           // se puede confeccionar el informe
    
4.  codigo: &#39;ESPERANDO\_REVISION&#39;  
      nombre: &#39;Esperando revisión de informe&#39;  
      categoria: &#39;EN\_CURSO&#39;  
      orden: 9  
      es\_inicial: false  
      es\_final: false  
      permite\_carga\_archivos: false  
      permite\_correccion: false  
      permite\_informe: true
    
5.  codigo: &#39;PARA\_PROTOCOLIZAR&#39;  
       nombre: &#39;Para protocolizar&#39;  
       categoria: &#39;EN\_CURSO&#39;  
       orden: 10  
       es\_inicial: false  
       es\_final: false  
       permite\_carga\_archivos: false  
       permite\_correccion: false  
       permite\_informe: true
    
6.  codigo: &#39;ESPERANDO\_PROTOCOLIZACION&#39;  
       nombre: &#39;Esperando protocolización&#39;  
       categoria: &#39;EN\_CURSO&#39;  
       orden: 11  
       es\_inicial: false  
       es\_final: false  
       permite\_carga\_archivos: false  
       permite\_correccion: false  
       permite\_informe: true
    

// COMPLETADO  
12) codigo: &#39;PROTOCOLIZADA&#39;  
   nombre: &#39;Protocolizada / Finalizada&#39;  
   categoria: &#39;COMPLETADO&#39;  
   orden: 12  
   es\_inicial: false  
   es\_final: true  
   permite\_carga\_archivos: false  
   permite\_correccion: false  
   permite\_informe: true          // sólo lectura, pero se pueden generar copias

// CANCELADO  
13) codigo: &#39;CANCELADA&#39;  
   nombre: &#39;Cancelada / Desestimada&#39;  
   categoria: &#39;CANCELADO&#39;  
   orden: 13  
   es\_inicial: false  
   es\_final: true  
   permite\_carga\_archivos: false  
   permite\_correccion: false  
   permite\_informe: false

<br>