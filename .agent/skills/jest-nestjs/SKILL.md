---
name: jest-nestjs
description: >
  Patrones de testing con Jest + NestJS para pruebas unitarias y e2e en proyectos Aurora.
  Activador: Al escribir pruebas, simular (mocking) dependencias o implementar cobertura de pruebas en NestJS/Aurora.
license: MIT
metadata:
  author: aurora
  version: "1.0"
  auto_invoke: "Escritura de pruebas, simulación de servicios, prueba de manejadores"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Cuándo usar
Utiliza esta habilidad cuando:
- Escribas pruebas unitarias para manejadores (handlers), servicios o agregados.
- Creas pruebas e2e para endpoints de API.
- Simules (mocking) dependencias de NestJS (repositorios, servicios, bus de eventos).
- Pruebes comandos y consultas CQRS.
- Pruebes código generado por Aurora.
- Configures accesorios (fixtures) y fábricas de pruebas.
- Implementes estrategias de cobertura de pruebas.

## Filosofía de pruebas en Aurora/NestJS

**Pruebas Unitarias**: Prueban componentes individuales en aislamiento.
- Manejadores (Comando/Consulta)
- Servicios
- Agregados y Objetos de Valor (Value Objects)
- Mapeadores (Mappers)

**Pruebas e2e**: Prueban flujos completos a través de la capa de API.
- Endpoints REST (Controladores)
- Resolutores GraphQL
- Autenticación/Autorización
- Interacciones con la base de datos

---

## Patrones de Pruebas Unitarias

### 1. Probar Manejadores de Comandos
**Objetivo**: Verificar la lógica de negocio, las validaciones y las interacciones con el repositorio.

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { EventPublisher } from '@nestjs/cqrs';
import { CreateTeslaCommandHandler } from './create-tesla.command-handler';
import { CreateTeslaCommand } from './create-tesla.command';
import { ITeslaRepository } from '../../domain/tesla.repository';
import { TeslaMockRepository } from '../../infrastructure/mock/tesla.mock-repository';

describe('CreateTeslaCommandHandler', () => {
    let handler: CreateTeslaCommandHandler;
    let repository: ITeslaRepository;
    let publisher: EventPublisher;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                CreateTeslaCommandHandler,
                {
                    provide: ITeslaRepository,
                    useClass: TeslaMockRepository,
                },
                {
                    provide: EventPublisher,
                    useValue: {
                        mergeObjectContext: jest.fn().mockReturnValue({
                            commit: jest.fn(),
                        }),
                    },
                },
            ],
        }).compile();

        handler = module.get<CreateTeslaCommandHandler>(CreateTeslaCommandHandler);
        repository = module.get<ITeslaRepository>(ITeslaRepository);
        publisher = module.get<EventPublisher>(EventPublisher);
    });

    describe('execute', () => {
        it('should create tesla with valid data', async () => {
            // Arrange
            const command = new CreateTeslaCommand({
                payload: {
                    id: 'tesla-uuid',
                    model: 'Model S',
                    year: 2023,
                    price: 79990,
                    isActive: true,
                },
            });

            const createSpy = jest.spyOn(repository, 'create');

            // Act
            await handler.execute(command);

            // Assert
            expect(createSpy).toHaveBeenCalledTimes(1);
            expect(createSpy).toHaveBeenCalledWith(
                expect.objectContaining({
                    id: expect.any(Object),
                    model: expect.any(Object),
                    year: expect.any(Object),
                }),
            );
        });

        it('should throw exception when price is invalid', async () => {
            // Arrange
            const command = new CreateTeslaCommand({
                payload: {
                    id: 'tesla-uuid',
                    model: 'Model S',
                    year: 2023,
                    price: -100, // Precio inválido
                    isActive: true,
                },
            });

            // Act & Assert
            await expect(handler.execute(command)).rejects.toThrow(
                'Price must be greater than 0',
            );
        });
    });
});
```

**Patrones Clave:**
- ✅ Usa `Test.createTestingModule()` para el contenedor de DI.
- ✅ Simula repositorios con interfaces (`ITeslaRepository`).
- ✅ Simula EventPublisher para eventos CQRS.
- ✅ Prueba el camino feliz + casos borde + caminos de error.
- ✅ Sigue el patrón AAA: Arrange, Act, Assert.

---

## Mejores Prácticas

### ✅ QUÉ HACER
1. **Aislar pruebas**: Cada prueba debe ser independiente.
2. **Usar nombres descriptivos**: "debe lanzar error cuando el precio es negativo".
3. **Seguir el patrón AAA**: Arrange, Act, Assert.
4. **Simular dependencias externas**: Base de datos, APIs, servicios.
5. **Probar casos borde**: Null, undefined, arreglos vacíos, límites.
6. **Probar caminos de error**: Excepciones, errores de validación.

### ❌ QUÉ NO HACER
1. **No probar detalles de implementación**: Prueba el comportamiento, no lo interno.
2. **No probar código del framework**: Confía en NestJS, TypeORM, etc.
3. **No compartir estado**: Entre pruebas o bloques describe.
4. **No usar base de datos real**: En pruebas unitarias (usa simuladores/mocks).
