import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\backend\src\planificacion\planificacion.service.spec.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Make sure mockPrisma has systemStatus
mock_prisma_addition = """
    systemStatus: {
      findUnique: jest.fn(),
      upsert: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
"""

if "systemStatus" not in content:
    content = content.replace("createMany: jest.fn(),\n    },", "createMany: jest.fn(),\n    },\n" + mock_prisma_addition)

tests_code = """
  describe('Pessimistic Locking (Simulador)', () => {
    beforeEach(() => {
      jest.useFakeTimers();
      jest.setSystemTime(new Date('2026-10-03T12:00:00Z'));
    });

    afterEach(() => {
      jest.useRealTimers();
    });

    it('debe adquirir el lock si está libre', async () => {
      mockPrisma.systemStatus.findUnique.mockResolvedValue(null);
      mockPrisma.systemStatus.upsert.mockResolvedValue({});

      const result = await service.adquirirLock('esc1', 'user1', 'Juan', 'tab1');
      
      expect(result.success).toBe(true);
      expect(mockPrisma.systemStatus.upsert).toHaveBeenCalled();
    });

    it('debe renovar el lock si pertenece al mismo usuario y tab', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });
      mockPrisma.systemStatus.update.mockResolvedValue({});

      const result = await service.adquirirLock('esc1', 'user1', 'Juan', 'tab1');
      
      expect(result.success).toBe(true);
      expect(mockPrisma.systemStatus.update).toHaveBeenCalled();
    });

    it('debe robar el lock si expiró por inactividad (> 2 mins)', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 3 * 60000), // Hace 3 minutos
      });
      mockPrisma.systemStatus.upsert.mockResolvedValue({});

      const result = await service.adquirirLock('esc1', 'user2', 'Maria', 'tab2');
      
      expect(result.success).toBe(true);
      expect(mockPrisma.systemStatus.upsert).toHaveBeenCalled();
    });

    it('debe rechazar adquirir el lock si está en uso por otro', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });

      const result = await service.adquirirLock('esc1', 'user2', 'Maria', 'tab2');
      
      expect(result.success).toBe(false);
      expect(result.lockedBy).toBe('Juan');
    });

    it('validateLockForUpdate debe lanzar NotFoundException si pertenece a otro', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });

      await expect(service.validateLockForUpdate('esc1', 'user2', 'tab2')).rejects.toThrowError(
        'El escenario está siendo modificado por Juan.'
      );
    });

    it('validateLockForUpdate no debe lanzar error si el lock pertenece al usuario', async () => {
      const now = new Date();
      mockPrisma.systemStatus.findUnique.mockResolvedValue({
        key: 'simulador_lock_escenario_esc1',
        value: JSON.stringify({ userId: 'user1', nombreUser: 'Juan', tabId: 'tab1' }),
        lastUpdate: new Date(now.getTime() - 10000), // Hace 10 segundos
      });

      await expect(service.validateLockForUpdate('esc1', 'user1', 'tab1')).resolves.not.toThrow();
    });
  });
"""

if "Pessimistic Locking" not in content:
    content = content[:content.rfind("}")] + tests_code + "\n}\n"
    
with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
