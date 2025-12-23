
import { Injectable } from '@nestjs/common';
import { ProductsService } from './../products/products.service';
import { initialData } from './data/seed-data';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { User } from '@prisma/client';

@Injectable()
export class SeedService {

  constructor(
    private readonly productsService: ProductsService,
    private readonly prisma: PrismaService,
  ) { }


  async runSeed() {

    await this.deleteTables();
    const adminUser = await this.insertUsers();

    await this.insertNewProducts(adminUser);

    return 'SEED EXECUTED';
  }

  private async deleteTables() {

    await this.productsService.deleteAllProducts();
    await this.prisma.user.deleteMany({});

  }

  private async insertUsers() {

    const seedUsers = initialData.users;

    // Hash passwords and normalize emails manually since we don't use Entity hooks or AuthService here
    const uersToInsert = seedUsers.map(user => ({
      ...user,
      email: user.email.toLowerCase().trim(),
      password: user.password
    }));

    // Prisma createMany is supported but doesn't return the created objects with IDs easily (only count).
    // But we need to return one user (adminUser) to use for products.
    // So we can use createMany, then findFirst? Or create one by one.
    // Given it's a seed, loop promises is fine.

    const dbUsers = [];

    for (const user of uersToInsert) {
      const dbUser = await this.prisma.user.create({ data: user });
      dbUsers.push(dbUser);
    }

    return dbUsers[0];
  }


  private async insertNewProducts(user: User) {
    await this.productsService.deleteAllProducts();

    const products = initialData.products;

    const insertPromises = [];

    products.forEach(product => {
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { type, ...cleanProduct } = product;
      insertPromises.push(this.productsService.create(cleanProduct, user));
    });

    await Promise.all(insertPromises);


    return true;
  }


}
