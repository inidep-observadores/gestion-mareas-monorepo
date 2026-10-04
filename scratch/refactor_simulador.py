import sys

def modify_file():
    with open('app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue', 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    for i, line in enumerate(lines):
        if 'item.buqueId = activeTab.value === \'buque\' ? payload.group : item.buqueId;' in line:
            if 'hasUnsavedChanges.value = true;' not in lines[i+1]:
                lines.insert(i+1, '      hasUnsavedChanges.value = true;\n')
                
        if 'escenarioActual.value.items.splice(idx, 1);' in line:
            if 'hasUnsavedChanges.value = true;' not in lines[i+1]:
                lines.insert(i+1, '    hasUnsavedChanges.value = true;\n')

        if 'escenarioActual.value.items.push(nuevoItem);' in line:
            if 'hasUnsavedChanges.value = true;' not in lines[i+1]:
                lines.insert(i+1, '      hasUnsavedChanges.value = true;\n')
                
        if 'cerrarModalRecurso();' in line and 'toast.success' in lines[i-1]:
            if 'hasUnsavedChanges.value = true;' not in lines[i+1]:
                lines.insert(i+1, '    hasUnsavedChanges.value = true;\n')

    with open('app/frontend/src/modules/planificacion/views/SimuladorCoberturaView.vue', 'w', encoding='utf-8') as f:
        f.writelines(lines)
        
modify_file()
