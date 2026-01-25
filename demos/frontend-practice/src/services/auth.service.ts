const API_URL = import.meta.env.BACKEND_URL ?? 'http://localhost:3000/api';
// Auth service for handling login, registration and password recovery.

interface ApiErrorResponse {
  message?: string;
}

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface RegistroUsuario {
  email: string;
  password: string;
  fullName: string;
  roles?: string[];
  [key: string]: unknown;
}

export interface UsuarioAutenticado {
  id: string;
  email: string;
  fullName: string;
  roles: string[];
  isActive: boolean;
  token?: string;
  [key: string]: unknown;
}

export type AuthResponse = UsuarioAutenticado & {
  token: string;
};

export interface AuthService {
  login(credentials: LoginCredentials): Promise<AuthResponse>;
  register(payload: RegistroUsuario): Promise<AuthResponse>;
  logout(): void;
  getToken(): string | null;
  getUser(): UsuarioAutenticado | null;
  forgotPassword(email: string): Promise<{ message: string }>;
  validateResetToken(token: string): Promise<{ email: string }>;
  resetPassword(token: string, newPassword: string): Promise<{ message: string }>;
}

const persistSession = (data: AuthResponse): AuthResponse => {
  if (data.token) {
    localStorage.setItem('authToken', data.token);
  }

  // Extraemos los datos del usuario (todo menos el token) para persistir
  const { token, ...user } = data;
  localStorage.setItem('user', JSON.stringify(user));

  return data;
};

const handleResponse = async (response: Response): Promise<AuthResponse> => {
  if (!response.ok) {
    const errorData: ApiErrorResponse = await response.json();
    throw new Error(errorData.message ?? 'Operación de autenticación fallida');
  }

  return response.json() as Promise<AuthResponse>;
};

export const authService: AuthService = {
  async login({ email, password }: LoginCredentials) {
    const response = await fetch(`${API_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email, password }),
    });

    const data = await handleResponse(response);
    return persistSession(data);
  },

  async register(payload: RegistroUsuario) {
    const response = await fetch(`${API_URL}/auth/register`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    const data = await handleResponse(response);
    return persistSession(data);
  },

  logout() {
    localStorage.removeItem('authToken');
    localStorage.removeItem('user');
    window.location.href = '/auth/login';
  },

  getToken() {
    return localStorage.getItem('authToken');
  },

  getUser() {
    const storedUser = localStorage.getItem('user');
    return storedUser ? (JSON.parse(storedUser) as UsuarioAutenticado) : null;
  },

  async forgotPassword(email: string) {
    const response = await fetch(`${API_URL}/auth/forgot-password`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Error al solicitar recuperación');
    }

    return response.json();
  },

  async validateResetToken(token: string) {
    const response = await fetch(`${API_URL}/auth/reset-password/${token}`);

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Token inválido o expirado');
    }

    return response.json();
  },

  async resetPassword(token: string, newPassword: string) {
    const response = await fetch(`${API_URL}/auth/reset-password`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ token, newPassword }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Error al restablecer contraseña');
    }

    return response.json();
  },
};
