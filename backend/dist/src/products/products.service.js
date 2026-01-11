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
exports.ProductsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const uuid_1 = require("uuid");
let ProductsService = class ProductsService {
    constructor(prisma) {
        this.prisma = prisma;
        this.logger = new common_1.Logger('ProductsService');
    }
    async create(createProductDto, user) {
        try {
            const { images = [], ...productDetails } = createProductDto;
            if (!productDetails.slug) {
                productDetails.slug = productDetails.title;
            }
            productDetails.slug = productDetails.slug
                .toLowerCase()
                .replaceAll(' ', '_')
                .replaceAll("'", '');
            const product = await this.prisma.product.create({
                data: {
                    ...productDetails,
                    slug: productDetails.slug,
                    user: { connect: { id: user.id } },
                    images: {
                        create: images.map(image => ({ url: image }))
                    }
                },
                include: {
                    images: true,
                }
            });
            return { ...product, images: product.images.map(img => img.url) };
        }
        catch (error) {
            this.handleDBExceptions(error);
        }
    }
    async findAll(paginationDto) {
        const { limit = 10, offset = 0 } = paginationDto;
        const products = await this.prisma.product.findMany({
            take: limit,
            skip: offset,
            include: {
                images: true,
            }
        });
        return products.map((product) => ({
            ...product,
            images: product.images.map(img => img.url)
        }));
    }
    async findOne(term) {
        let product;
        if ((0, uuid_1.validate)(term)) {
            product = await this.prisma.product.findUnique({
                where: { id: term },
                include: { images: true }
            });
        }
        else {
            product = await this.prisma.product.findFirst({
                where: {
                    OR: [
                        { title: { equals: term, mode: 'insensitive' } },
                        { slug: { equals: term.toLowerCase(), mode: 'insensitive' } }
                    ]
                },
                include: { images: true }
            });
        }
        if (!product)
            throw new common_1.NotFoundException(`Product with ${term} not found`);
        return product;
    }
    async findOnePlain(term) {
        const { images = [], ...rest } = await this.findOne(term);
        return {
            ...rest,
            images: images.map(image => image.url)
        };
    }
    async update(id, updateProductDto, user) {
        const { images, ...toUpdate } = updateProductDto;
        const productExists = await this.prisma.product.findUnique({ where: { id } });
        if (!productExists)
            throw new common_1.NotFoundException(`Product with id: ${id} not found`);
        if (toUpdate.slug) {
            toUpdate.slug = toUpdate.slug.toLowerCase().replaceAll(' ', '_').replaceAll("'", '');
        }
        else if (toUpdate.title) {
        }
        try {
            const product = await this.prisma.$transaction(async (tx) => {
                if (images) {
                    await tx.productImage.deleteMany({ where: { productId: id } });
                }
                const updatedProduct = await tx.product.update({
                    where: { id },
                    data: {
                        ...toUpdate,
                        userId: user.id,
                        images: images ? {
                            create: images.map(url => ({ url }))
                        } : undefined
                    },
                    include: { images: true }
                });
                return updatedProduct;
            });
            return this.findOnePlain(id);
        }
        catch (error) {
            this.handleDBExceptions(error);
        }
    }
    async remove(id) {
        await this.findOne(id);
        try {
            await this.prisma.product.delete({ where: { id } });
        }
        catch (error) {
            this.handleDBExceptions(error);
        }
    }
    handleDBExceptions(error) {
        if (error.code === 'P2002')
            throw new common_1.BadRequestException('Unique constraint violation (duplicate key)');
        this.logger.error(error);
        throw new common_1.InternalServerErrorException('Unexpected error, check server logs');
    }
    async deleteAllProducts() {
        try {
            return await this.prisma.product.deleteMany({});
        }
        catch (error) {
            this.handleDBExceptions(error);
        }
    }
};
exports.ProductsService = ProductsService;
exports.ProductsService = ProductsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ProductsService);
//# sourceMappingURL=products.service.js.map