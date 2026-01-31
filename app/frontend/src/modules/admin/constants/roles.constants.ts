import { ValidRoles } from '@/modules/auth/interfaces/roles.enum';

export const ROLES = [
    { id: ValidRoles.admin, name: 'Administrador' },
    { id: ValidRoles.asistente, name: 'Asistente Adm.' },
    { id: ValidRoles.tecnico, name: 'Técnico Datos' },
    { id: ValidRoles.coordinador, name: 'Coordinador' },
    { id: ValidRoles.invitado, name: 'Invitado' },
] as const;

export type RoleId = typeof ROLES[number]['id'];

export const ROLE_LABELS: Record<ValidRoles | string, string> = {
    [ValidRoles.admin]: 'Administrador',
    [ValidRoles.asistente]: 'Asistente Adm.',
    [ValidRoles.tecnico]: 'Técnico Datos',
    [ValidRoles.coordinador]: 'Coordinador',
    [ValidRoles.invitado]: 'Invitado',
    // Fallback/Legacy
    user: 'Usuario',
    observer: 'Observador'
};
