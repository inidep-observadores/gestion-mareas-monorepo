import { ProductsService } from './products.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { PaginationDto } from './../common/dtos/pagination.dto';
import { User } from '@prisma/client';
export declare class ProductsController {
    private readonly productsService;
    constructor(productsService: ProductsService);
    create(createProductDto: CreateProductDto, user: User): Promise<{
        images: string[];
        id: string;
        userId: string;
        title: string;
        price: number;
        description: string | null;
        slug: string;
        stock: number;
        sizes: string[];
        gender: string;
        tags: string[];
    }>;
    findAll(paginationDto: PaginationDto): Promise<{
        images: string[];
        id: string;
        userId: string;
        title: string;
        price: number;
        description: string | null;
        slug: string;
        stock: number;
        sizes: string[];
        gender: string;
        tags: string[];
    }[]>;
    findOne(term: string): Promise<any>;
    update(id: string, updateProductDto: UpdateProductDto, user: User): Promise<any>;
    remove(id: string): Promise<void>;
}
