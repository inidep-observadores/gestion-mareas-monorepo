import re

file_path = r"d:\Desarrollo\_INIDEP\OBS\Mareas\gestion-mareas-monorepo\app\backend\src\planificacion\planificacion.service.ts"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

replacement = """
  async adquirirLock(escenarioId: string, userId: string, nombreUser: string, tabId: string) {
    const lockKey = this.getLockKey(escenarioId);
    const ttlMinutes = 2;
    const now = new Date();
    const threshold = new Date(now.getTime() - ttlMinutes * 60000);

    return this.prisma.$transaction(async (tx) => {
      const dbUser = await tx.user.findUnique({ where: { id: userId }, select: { fullName: true } });
      const realName = dbUser?.fullName || nombreUser;

      const lock = await tx.systemStatus.findUnique({
        where: { key: lockKey },
      });

      // Si no hay lock, o el lock expiró
      if (!lock || lock.lastUpdate < threshold) {
        await tx.systemStatus.upsert({
          where: { key: lockKey },
          update: {
            value: JSON.stringify({ userId, nombreUser: realName, tabId }),
            lastUpdate: now,
          },
          create: {
            key: lockKey,
            value: JSON.stringify({ userId, nombreUser: realName, tabId }),
            lastUpdate: now,
          },
        });
        return { success: true };
      }

      const lockData = JSON.parse(lock.value);
      if (lockData.userId === userId && lockData.tabId === tabId) {
        // Renovar lock
        await tx.systemStatus.update({
          where: { key: lockKey },
          data: {
            value: JSON.stringify({ userId, nombreUser: realName, tabId }),
            lastUpdate: now,
          },
        });
        return { success: true };
      }

      return { success: false, lockedBy: lockData.nombreUser };
    });
  }
"""

content = re.sub(
    r"async adquirirLock\(escenarioId: string, userId: string, nombreUser: string, tabId: string\) \{.*?return \{ success: false, lockedBy: lockData\.nombreUser \};\n    \}\);\n  \}",
    replacement.strip(),
    content,
    flags=re.DOTALL
)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
