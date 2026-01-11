import { ProductsService } from './../products/products.service';
import { PrismaService } from '../prisma/prisma.service';
export declare class SeedService {
    private readonly productsService;
    private readonly prisma;
    constructor(productsService: ProductsService, prisma: PrismaService);
    runSeed(): Promise<string>;
    private deleteTables;
    private insertUsers;
    private insertNewProducts;
}
