import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as bcrypt from 'bcrypt';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Seeding database...');

  // Limpiar datos existentes respetando restricciones de integridad
  await prisma.productImage.deleteMany();
  await prisma.product.deleteMany();
  await prisma.user.deleteMany();

  const password = await bcrypt.hash('Obs123', 10);

  const usersData = [
    {
      email: 'admin@obs.com',
      fullName: 'Administrador Sistema',
      password: password,
      roles: ['admin'],
    },
    {
      email: 'coordinador@obs.com',
      fullName: 'Coordinador Operativo',
      password: password,
      roles: ['coordinador'],
    },
    {
      email: 'tecnico@obs.com',
      fullName: 'Técnico de Datos',
      password: password,
      roles: ['tecnico'],
    },
    {
      email: 'asistente@obs.com',
      fullName: 'Asistente Administrativo',
      password: password,
      roles: ['asistente'],
    },
  ];

  for (const userData of usersData) {
    const user = await prisma.user.create({
      data: userData,
    });
    console.log(`Created user: ${user.email} with roles: ${user.roles.join(', ')}`);
  }

  console.log('Seeding completed successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
