---
name: base-development
description: "Proporciona contexto sobre el stack tecnológico del proyecto GastosCompartidos, patrones arquitectónicos y estándares de desarrollo."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Skill: Base Development (GastosCompartidos)

Esta habilidad proporciona el conocimiento fundamental sobre la arquitectura, tecnologías y convenciones utilizadas en este monorepo.

## 🏗️ Arquitectura del Proyecto

```
GastosCompartidos/
├── apps/
│   ├── backend/          # API NestJS
│   │   ├── src/
│   │   │   ├── @core/    # Lógica de dominio (si aplica Aurora)
│   │   │   ├── modules/  # Módulos de funcionalidad
│   │   │   ├── common/   # Código compartido
│   │   │   └── main.ts
│   │   ├── prisma/       # Esquemas y migraciones
│   │   └── test/         # Pruebas e2e
│   └── frontend/         # Aplicación Vue 3
│       ├── src/
│       │   ├── components/  # Componentes Vue
│       │   │   └── ui/      # Sistema de diseño (AppButton, AppCard, etc.)
│       │   ├── views/       # Páginas/Vistas
│       │   ├── stores/      # Pinia stores
│       │   ├── router/      # Vue Router
│       │   └── style.css    # Estilos globales + config Tailwind v4
│       └── public/
└── docs/                 # Documentación del proyecto
```

## 💻 Stack Tecnológico

### Frontend
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Vue.js** | 3.5+ | Framework UI reactivo |
| **Vite** | 6.x | Build tool y dev server |
| **Tailwind CSS** | 4.x | Framework de utilidades CSS |
| **Pinia** | 3.x | Gestión de estado |
| **Vue Router** | 4.x | Enrutamiento SPA |
| **Axios** | 1.x | Cliente HTTP |
| **Lucide Vue** | - | Iconos |
| **TypeScript** | 5.9+ | Tipado estático |

### Backend
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **NestJS** | 10.x | Framework Node.js empresarial |
| **Prisma** | 5.x | ORM type-safe |
| **PostgreSQL** | 15+ | Base de datos relacional |
| **class-validator** | - | Validación de DTOs |
| **class-transformer** | - | Transformación de objetos |
| **Jest** | - | Framework de pruebas |

### Herramientas
- **pnpm**: Gestor de paquetes (workspace-aware)
- **TypeScript**: Configuración estricta en ambos apps
- **ESLint**: Linting de código
- **Prettier**: Formateo de código

## 🎯 Patrones Arquitectónicos

### Backend (NestJS)

#### 1. Módulos por Dominio
```
src/
├── users/
│   ├── users.module.ts
│   ├── users.controller.ts
│   ├── users.service.ts
│   ├── dto/
│   │   ├── create-user.dto.ts
│   │   └── update-user.dto.ts
│   └── entities/
│       └── user.entity.ts (Prisma model reference)
```

#### 2. DTOs para Comunicación
```typescript
// Backend: create-expense.dto.ts
export class CreateExpenseDto {
  @IsString()
  @MinLength(3)
  description: string;

  @IsNumber()
  @IsPositive()
  amount: number;

  @IsDateString()
  date: string;

  @IsUUID()
  categoryId: string;
}

// Frontend: types/expense.ts
export interface CreateExpenseRequest {
  description: string;
  amount: number;
  date: string;
  categoryId: string;
}
```

#### 3. Servicios Reutilizables
- Un servicio = una responsabilidad
- Inyección de dependencias vía constructor
- Exportar servicios para uso en otros módulos

```typescript
@Injectable()
export class ExpensesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly categoriesService: CategoriesService
  ) {}

  async create(dto: CreateExpenseDto) {
    // Validación de categoría usando servicio inyectado
    await this.categoriesService.validateExists(dto.categoryId);
    
    return this.prisma.expense.create({
      data: dto,
      include: { category: true }
    });
  }
}
```

### Frontend (Vue 3)

#### 1. Composition API con `<script setup>`
```vue
<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useExpensesStore } from '@/stores/expenses'

const props = defineProps<{
  categoryId?: string
}>()

const emit = defineEmits<{
  created: [expense: Expense]
}>()

const expensesStore = useExpensesStore()
const loading = ref(false)

const filteredExpenses = computed(() => {
  if (!props.categoryId) return expensesStore.expenses
  return expensesStore.expenses.filter(e => e.categoryId === props.categoryId)
})

onMounted(async () => {
  loading.value = true
  await expensesStore.fetchExpenses()
  loading.value = false
})
</script>
```

#### 2. Pinia Stores
```typescript
// stores/expenses.ts
import { defineStore } from 'pinia'
import axios from 'axios'

export const useExpensesStore = defineStore('expenses', () => {
  const expenses = ref<Expense[]>([])
  const loading = ref(false)

  async function fetchExpenses() {
    loading.value = true
    try {
      const { data } = await axios.get('/api/expenses')
      expenses.value = data
    } finally {
      loading.value = false
    }
  }

  async function createExpense(dto: CreateExpenseRequest) {
    const { data } = await axios.post('/api/expenses', dto)
    expenses.value.push(data)
    return data
  }

  return {
    expenses,
    loading,
    fetchExpenses,
    createExpense
  }
})
```

#### 3. Sistema de Diseño Consistente
Usar siempre componentes de `src/components/ui/`:

```vue
<template>
  <AppCard>
    <template #header>
      <h2 class="text-lg font-semibold">Nuevo Gasto</h2>
    </template>

    <form @submit.prevent="handleSubmit">
      <AppInput
        v-model="form.description"
        label="Descripción"
        placeholder="Ej: Cena con amigos"
      />

      <AppButton type="submit" variant="solid" size="md">
        Guardar
      </AppButton>
    </form>
  </AppCard>
</template>
```

## 🎨 Convenciones de Código

### Nombres de Archivos
| Tipo | Convención | Ejemplo |
|------|-----------|---------|
| **Componentes Vue** | PascalCase | `ExpenseForm.vue` |
| **Composables** | camelCase con `use` prefix | `useExpenses.ts` |
| **Stores** | camelCase | `expenses.ts` |
| **Views** | PascalCase + `View` suffix | `DashboardView.vue` |
| **Controllers** | kebab-case + `.controller.ts` | `expenses.controller.ts` |
| **Services** | kebab-case + `.service.ts` | `expenses.service.ts` |
| **DTOs** | kebab-case + `.dto.ts` | `create-expense.dto.ts` |

### Convenciones TypeScript
```typescript
// ✅ Interfaces para shapes de datos
interface User {
  id: string;
  email: string;
  name: string;
}

// ✅ Types para uniones y composiciones
type UserRole = 'admin' | 'user' | 'guest'
type UserWithRole = User & { role: UserRole }

// ✅ Enums para valores fijos del dominio
enum ExpenseStatus {
  PENDING = 'PENDING',
  APPROVED = 'APPROVED',
  REJECTED = 'REJECTED'
}

// ✅ Generics para funciones reutilizables
function findById<T extends { id: string }>(items: T[], id: string): T | undefined {
  return items.find(item => item.id === id)
}
```

### Tailwind CSS (v4)
```css
/* CORRECTO: Variables en @theme */
@theme {
  --color-primary: oklch(0.6 0.25 250);
  --color-danger: oklch(0.55 0.2 20);
  --spacing-card: 1.5rem;
}

/* CORRECTO: Uso en componentes */
.btn-primary {
  @apply bg-brand-primary text-brand-primary-foreground rounded-lg px-4 py-2;
}
```

```vue
<!-- CORRECTO: Utility-first en templates -->
<div class="flex items-center gap-4 p-6 bg-card rounded-xl shadow-premium">
  <AppButton variant="solid" class="w-full md:w-auto">
    Guardar
  </AppButton>
</div>
```

## 🔧 Comandos Comunes

### Desarrollo
```bash
# Instalar dependencias
pnpm install

# Iniciar ambos servicios en paralelo
pnpm dev

# Solo backend
pnpm --filter backend dev

# Solo frontend
pnpm --filter frontend dev
```

### Testing
```bash
# Todas las pruebas
pnpm test

# Backend: Unitarias
pnpm --filter backend test

# Backend: E2E
pnpm --filter backend test:e2e

# Frontend: Unitarias
pnpm --filter frontend test
```

### Base de Datos
```bash
# Generar cliente de Prisma
pnpm --filter backend prisma generate

# Crear migración
pnpm --filter backend prisma migrate dev --name nombre_descripcion

# Aplicar migraciones
pnpm --filter backend prisma migrate deploy

# Abrir Prisma Studio
pnpm --filter backend prisma studio

# Seed de datos
pnpm --filter backend prisma db seed
```

### Build
```bash
# Build de producción (ambos)
pnpm build

# Build solo frontend
pnpm --filter frontend build

# Build solo backend
pnpm --filter backend build
```

## 📋 Checklist de Desarrollo

### Antes de Crear una Funcionalidad
- [ ] Revisar si existe lógica similar que se pueda reutilizar
- [ ] Verificar componentes UI disponibles en `frontend/src/components/ui/`
- [ ] Planificar el modelo de datos (Prisma schema)
- [ ] Definir DTOs para la comunicación

### Durante el Desarrollo
- [ ] Seguir el patrón de módulos para organizar código
- [ ] Usar TypeScript con tipos explícitos (evitar `any`)
- [ ] Añadir validaciones en DTOs con `class-validator`
- [ ] Documentar funciones complejas con JSDoc
- [ ] Usar componentes del sistema de diseño
- [ ] Aplicar Tailwind siguiendo la guía de v4

### Antes de Commit
- [ ] Ejecutar linter: `pnpm lint`
- [ ] Ejecutar pruebas: `pnpm test`
- [ ] Verificar que la build funciona: `pnpm build`
- [ ] Actualizar documentación técnica si aplica
- [ ] Mensaje de commit siguiendo Conventional Commits (ver skill `git-commits-spanish`)

### Antes de Merge/Deploy
- [ ] Todas las pruebas pasan
- [ ] No hay errores de TypeScript
- [ ] Documentación actualizada
- [ ] README actualizado si cambió funcionalidad principal
- [ ] Migraciones de BD validadas

## 🚨 Anti-Patrones a Evitar

### Backend
❌ **No usar** `any` en TypeScript
```typescript
// ❌ MAL
function processData(data: any) { }

// ✅ BIEN
interface DataInput {
  id: string;
  value: number;
}
function processData(data: DataInput) { }
```

❌ **No mezclar** lógica de negocio en controladores
```typescript
// ❌ MAL
@Controller('users')
export class UsersController {
  @Post()
  create(@Body() dto: CreateUserDto) {
    // Lógica de negocio aquí ❌
    const hashedPassword = bcrypt.hash(dto.password, 10)
  }
}

// ✅ BIEN
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  create(@Body() dto: CreateUserDto) {
    return this.usersService.create(dto) // Servicio maneja la lógica
  }
}
```

### Frontend
❌ **No mutar** props directamente
```vue
<script setup>
// ❌ MAL
const props = defineProps<{ count: number }>()
props.count++ // ❌ Error!

// ✅ BIEN
const props = defineProps<{ count: number }>()
const emit = defineEmits<{ update: [value: number] }>()

function increment() {
  emit('update', props.count + 1)
}
</script>
```

❌ **No usar** `reactive()` para primitivos
```typescript
// ❌ MAL
const count = reactive(0) // No funciona como esperas

// ✅ BIEN
const count = ref(0)
```

## 📚 Recursos Adicionales

- **NestJS Docs**: https://docs.nestjs.com
- **Vue 3 Docs**: https://vuejs.org
- **Prisma Docs**: https://www.prisma.io/docs
- **Tailwind v4 Docs**: https://tailwindcss.com/docs
- **Pinia Docs**: https://pinia.vuejs.org

## 🔄 Actualización de esta Skill

Esta skill debe actualizarse cuando:
- Se añada una nueva tecnología al stack
- Cambien patrones arquitectónicos importantes
- Se modifiquen convenciones de código
- Surjan nuevos anti-patrones comunes
