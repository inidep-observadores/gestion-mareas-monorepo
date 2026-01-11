"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SeedService = void 0;
const common_1 = require("@nestjs/common");
const products_service_1 = require("./../products/products.service");
const seed_data_1 = require("./data/seed-data");
const prisma_service_1 = require("../prisma/prisma.service");
let SeedService = class SeedService {
    constructor(productsService, prisma) {
        this.productsService = productsService;
        this.prisma = prisma;
    }
    async runSeed() {
        await this.deleteTables();
        const adminUser = await this.insertUsers();
        await this.insertNewProducts(adminUser);
        return 'SEED EXECUTED';
    }
    async deleteTables() {
        await this.productsService.deleteAllProducts();
        await this.prisma.user.deleteMany({});
    }
    async insertUsers() {
        const seedUsers = seed_data_1.initialData.users;
        const uersToInsert = seedUsers.map(user => ({
            ...user,
            email: user.email.toLowerCase().trim(),
            password: user.password
        }));
        const dbUsers = [];
        for (const user of uersToInsert) {
            const dbUser = await this.prisma.user.create({ data: user });
            dbUsers.push(dbUser);
        }
        return dbUsers[0];
    }
    async insertNewProducts(user) {
        await this.productsService.deleteAllProducts();
        const products = seed_data_1.initialData.products;
        const insertPromises = [];
        products.forEach(product => {
            const { type, ...cleanProduct } = product;
            insertPromises.push(this.productsService.create(cleanProduct, user));
        });
        await Promise.all(insertPromises);
        return true;
    }
};
exports.SeedService = SeedService;
exports.SeedService = SeedService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [products_service_1.ProductsService,
        prisma_service_1.PrismaService])
], SeedService);
//# sourceMappingURL=seed.service.js.map