import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as bcrypt from 'bcrypt';
import { Pool } from 'pg';
import * as fs from 'fs';
import * as path from 'path';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Seeding database...');

  // Limpiar datos existentes respetando restricciones de integridad
  await prisma.productImage.deleteMany();
  await prisma.product.deleteMany();
  await prisma.observadorPesqueria.deleteMany();
  await prisma.buque.deleteMany();
  await prisma.observador.deleteMany();
  await prisma.puerto.deleteMany();
  await prisma.pesqueria.deleteMany();
  await prisma.especie.deleteMany();
  await prisma.tipoFlota.deleteMany();
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

  // Seeding Observadores
  const jsonlPath = path.join(__dirname, 'data/observadores.jsonl');
  if (fs.existsSync(jsonlPath)) {
    const observadoresData = fs.readFileSync(jsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${observadoresData.length} observadores...`);

    // Using createMany for better performance
    await prisma.observador.createMany({
      data: observadoresData,
    });

    console.log('Observadores seeded successfully!');
  } else {
    console.warn('observadores.jsonl not found, skipping observadores seeding.');
  }

  // Seeding Puertos
  const puertosJsonlPath = path.join(__dirname, 'data/puertos.jsonl');
  if (fs.existsSync(puertosJsonlPath)) {
    const puertosData = fs.readFileSync(puertosJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${puertosData.length} puertos...`);

    for (const puerto of puertosData) {
      try {
        await prisma.puerto.create({
          data: puerto,
        });
      } catch (error: any) {
        console.error(`Error creating puerto: ${puerto.nombre}`);
        console.error(error.message || error);
        throw error;
      }
    }

    console.log('Puertos seeded successfully!');
  } else {
    console.warn('puertos.jsonl not found, skipping puertos seeding.');
  }

  // Seeding Pesquerías
  const pesqueriasJsonlPath = path.join(__dirname, 'data/pesquerias.jsonl');
  if (fs.existsSync(pesqueriasJsonlPath)) {
    const pesqueriasData = fs.readFileSync(pesqueriasJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${pesqueriasData.length} pesquerías...`);
    await prisma.pesqueria.createMany({ data: pesqueriasData });
    console.log('Pesquerías seeded successfully!');
  }

  // Seeding Especies
  const especiesJsonlPath = path.join(__dirname, 'data/especies.jsonl');
  if (fs.existsSync(especiesJsonlPath)) {
    const especiesData = fs.readFileSync(especiesJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${especiesData.length} especies...`);
    await prisma.especie.createMany({ data: especiesData });
    console.log('Especies seeded successfully!');
  }

  // Seeding Tipos de Flota
  const tiposFlotaJsonlPath = path.join(__dirname, 'data/tipos_flota.jsonl');
  if (fs.existsSync(tiposFlotaJsonlPath)) {
    const tiposFlotaData = fs.readFileSync(tiposFlotaJsonlPath, 'utf8')
      .split('\n')
      .filter(line => line.trim())
      .map(line => JSON.parse(line));

    console.log(`Loading ${tiposFlotaData.length} tipos de flota...`);
    await prisma.tipoFlota.createMany({ data: tiposFlotaData });
    console.log('Tipos de flota seeded successfully!');
  }

  // Seeding Buques from CSV
  const buquesCsvPath = path.join(__dirname, '../old_data/BuqueEmpresa.csv');
  if (fs.existsSync(buquesCsvPath)) {
    console.log('Seeding Buques from CSV...');
    const csvContent = fs.readFileSync(buquesCsvPath, 'utf8');
    const lines = csvContent.split('\n').filter(line => line.trim());
    const headers = lines[0].split(';').map(h => h.trim());

    // Get all puertos and tipos_flota for linking
    const puertos = await prisma.puerto.findMany();
    const tiposFlota = await prisma.tipoFlota.findMany();

    const getPuertoId = (localidad: string) => {
      const loc = localidad.toLowerCase().trim();
      if (!loc) return null;
      if (loc.includes('buenos aires')) return puertos.find(p => p.nombre.toLowerCase().includes('buenos aires'))?.id;
      if (loc.includes('madryn')) return puertos.find(p => p.nombre.toLowerCase().includes('madryn'))?.id;
      if (loc.includes('deseado')) return puertos.find(p => p.nombre.toLowerCase().includes('deseado'))?.id;
      if (loc.includes('san julian') || loc.includes('san julián')) return puertos.find(p => p.nombre.toLowerCase().includes('san julian'))?.id;
      if (loc.includes('rawson') || loc.includes('trelew')) return puertos.find(p => p.nombre.toLowerCase().includes('rawson'))?.id;
      if (loc.includes('comodoro') || loc.includes('rivadavia')) return puertos.find(p => p.nombre.toLowerCase().includes('comod'))?.id;
      if (loc.includes('ushuaia') || loc.includes('punta arenas')) return puertos.find(p => p.nombre.toLowerCase().includes('ushuaia'))?.id;

      const found = puertos.find(p => p.nombre.toLowerCase().includes(loc));
      return found?.id || null;
    };

    const getTipoFlotaId = (tipo: string) => {
      const t = tipo.toLowerCase().trim();
      if (!t) return null;
      let code = '';
      if (t === 'fresquero') code = 'FRESQUERO';
      else if (t === 'tangonero') code = 'TANGONERO';
      else if (t === 'cong_merlucero') code = 'CONGELADOR_MERLUCERO';
      else if (t === 'potero') code = 'POTERO';
      else if (t === 'palangrero') code = 'PALANGRERO';
      else if (t === 'cong_austral') code = 'CONGELADOR_AUSTRAL';
      else if (t === 'trampero') code = 'CENTOLLERO';
      else if (t === 'vieira') code = 'VIEIRERO';
      else if (t === 'costero') code = 'COSTERO';
      else if (t === 'investigación' || t === 'investigacion') code = 'INVESTIGACION';
      else if (t === 'congelador') code = 'CONGELADOR_GENERICO';
      else if (t === 'surimero') code = 'SURIMERO';
      else if (t === 'raya') code = 'RAYERO';
      else if (t.includes('cong_merlucero')) code = 'CONGELADOR_MERLUCERO';

      return tiposFlota.find(tf => tf.codigo === code)?.id || null;
    };

    const extractArmadorNombre = (telArmador: string) => {
      if (!telArmador) return null;
      // Regex to try to capture name before a number or " - "
      // Example: "Emanuel 155597896" -> "Emanuel"
      // Example: "Esteban Palestini 15530-6373" -> "Esteban Palestini"
      const match = telArmador.match(/^([a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+)(?=[\d\s-]{4,}|$)/);
      if (match && match[1]) {
        const name = match[1].trim();
        // Avoid cases like "Noelia -"
        return name.replace(/\s-+$/, '').trim() || null;
      }
      return null;
    };

    let tempMatriculaCount = 1;
    const buquesToCreate = [];

    for (let i = 1; i < lines.length; i++) {
      const values = lines[i].split(';');
      const data: any = {};
      headers.forEach((header, index) => {
        data[header] = values[index]?.trim();
      });

      let matricula = data['Matricula'];
      if (!matricula) {
        matricula = `TEMP-${String(tempMatriculaCount++).padStart(4, '0')}`;
      }

      const armadorInfo = data['Telefono Armador '];
      const armadorNombre = extractArmadorNombre(armadorInfo);

      const diasMarea = parseInt(data['Dias marea Esti.']);

      buquesToCreate.push({
        nombreBuque: data['Buque'] || 'SIN NOMBRE',
        matricula: matricula,
        empresaNombre: data['EMPRESA'],
        tipoFlotaId: getTipoFlotaId(data['Tipo Buque']),
        diasMareaEstimada: isNaN(diasMarea) ? null : diasMarea,
        empresaFax: data['Fax Empresa'],
        empresaLocalidad: data['Localidad'],
        puertoBaseId: getPuertoId(data['Localidad']),
        empresaCorreoPrincipal: data['Correo Empresa '],
        empresaCorreoSecundario: data['Mail'],
        empresaTelefono: data['Telefono'],
        agenciaMaritimaNombre: data['AGENCIA MARITIMA'],
        armadorTelefono: armadorInfo,
        armadorNombre: armadorNombre,
        activo: true,
      });
    }

    console.log(`Loading ${buquesToCreate.length} buques...`);
    for (const buque of buquesToCreate) {
      try {
        await prisma.buque.create({ data: buque });
      } catch (error: any) {
        console.error(`Error creating buque: ${buque.nombreBuque} (Mat: ${buque.matricula})`);
        console.error(error.message || error);
        // We continue with others if one fails, but maybe better to throw if it's a critical error
        // For now let's just log and see.
      }
    }
    console.log('Buques seeding process completed!');
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
