import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\backend\src\planificacion\planificacion.service.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

lock_methods = """
  // ==========================================
  // PESSIMISTIC LOCKING PARA SIMULADOR
  // ==========================================

  private getLockKey(escenarioId: string): string {
    return `simulador_lock_escenario_${escenarioId}`;
  }

  async adquirirLock(escenarioId: string, userId: string, nombreUser: string, tabId: string) {
    const lockKey = this.getLockKey(escenarioId);
    const ttlMinutes = 2;
    const now = new Date();
    const threshold = new Date(now.getTime() - ttlMinutes * 60000);

    return this.prisma.$transaction(async (tx) => {
      const lock = await tx.systemStatus.findUnique({
        where: { key: lockKey },
      });

      // Si no hay lock, o el lock expiró
      if (!lock || lock.lastUpdate < threshold) {
        await tx.systemStatus.upsert({
          where: { key: lockKey },
          update: {
            value: JSON.stringify({ userId, nombreUser, tabId }),
            lastUpdate: now,
          },
          create: {
            key: lockKey,
            value: JSON.stringify({ userId, nombreUser, tabId }),
            lastUpdate: now,
          },
        });
        return { success: true };
      }

      const lockValue = JSON.parse(lock.value || '{}');

      // Si el lock me pertenece (mismo usuario y tab)
      if (lockValue.userId === userId && lockValue.tabId === tabId) {
        await tx.systemStatus.update({
          where: { key: lockKey },
          data: { lastUpdate: now },
        });
        return { success: true };
      }

      // Si el lock pertenece a otro usuario (o mismo user distinto tab) y está vigente
      return {
        success: false,
        lockedBy: lockValue.nombreUser || 'Otro usuario',
      };
    });
  }

  async liberarLock(escenarioId: string, userId: string, tabId: string) {
    const lockKey = this.getLockKey(escenarioId);
    const lock = await this.prisma.systemStatus.findUnique({
      where: { key: lockKey },
    });

    if (lock) {
      const lockValue = JSON.parse(lock.value || '{}');
      if (lockValue.userId === userId && lockValue.tabId === tabId) {
        await this.prisma.systemStatus.delete({
          where: { key: lockKey },
        });
      }
    }
  }

  async validateLockForUpdate(escenarioId: string, userId: string, tabId: string): Promise<void> {
    const lockKey = this.getLockKey(escenarioId);
    const ttlMinutes = 2;
    const now = new Date();
    const threshold = new Date(now.getTime() - ttlMinutes * 60000);

    const lock = await this.prisma.systemStatus.findUnique({
      where: { key: lockKey },
    });

    if (!lock || lock.lastUpdate < threshold) {
      throw new NotFoundException('El bloqueo ha expirado por inactividad. Por favor, refresque la vista.');
    }

    const lockValue = JSON.parse(lock.value || '{}');
    if (lockValue.userId !== userId || lockValue.tabId !== tabId) {
      throw new NotFoundException(`El escenario estÃ¡ siendo modificado por ${lockValue.nombreUser || 'otro usuario'}.`);
    }
  }
"""

if "PESSIMISTIC LOCKING PARA SIMULADOR" not in content:
    # insert before the last closing brace
    content = content[:content.rfind("}")] + lock_methods + "\n}\n"
    
with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
