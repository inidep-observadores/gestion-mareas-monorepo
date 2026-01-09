
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
    console.log('--- AUDITORÍA DE ALERTAS ---')
    const total = await prisma.alerta.count()
    console.log('Total alertas:', total)

    const states = await prisma.alerta.groupBy({
        by: ['estado'],
        _count: { _all: true }
    })
    console.log('Estados en DB:', JSON.stringify(states, null, 2))

    const resueltas = await prisma.alerta.findMany({
        where: { estado: 'RESUELTA' },
        take: 5
    })
    console.log('Muestra de RESUELTAS:', JSON.stringify(resueltas, null, 2))
}

main()
    .catch(e => console.error(e))
    .finally(() => prisma.$disconnect())
