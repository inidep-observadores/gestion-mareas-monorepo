export const ROLES = [
    { id: 'admin', name: 'Administrador' },
    { id: 'asistente_administrativo', name: 'Asistente Adm.' },
    { id: 'tecnico_datos', name: 'Técnico Datos' },
    { id: 'coordinador', name: 'Coordinador' },
    { id: 'invitado', name: 'Invitado' },
] as const;

export type RoleId = typeof ROLES[number]['id'];

export const ROLE_LABELS: Record<string, string> = {
    admin: 'Administrador',
    asistente_administrativo: 'Asistente Adm.',
    tecnico_datos: 'Técnico Datos',
    coordinador: 'Coordinador',
    invitado: 'Invitado',
    // Fallback/Legacy
    user: 'Usuario',
    observer: 'Observador'
};
