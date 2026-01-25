import { BadRequestException, Injectable, InternalServerErrorException, Logger, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { PaginationDto } from 'src/common/dtos/pagination.dto';
import { validate as isUUID } from 'uuid';
import { User } from '@prisma/client';

@Injectable()
export class ProductsService {

  private readonly logger = new Logger('ProductsService');

  constructor(
    private readonly prisma: PrismaService,
  ) { }


  async create(createProductDto: CreateProductDto, user: User) {

    try {
      const { images = [], ...productDetails } = createProductDto;

      // Slug logic
      if (!productDetails.slug) {
        productDetails.slug = productDetails.title;
      }
      productDetails.slug = productDetails.slug
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll("'", '')

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

    } catch (error) {
      this.handleDBExceptions(error);
    }

  }


  async findAll(paginationDto: PaginationDto) {

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
    }))
  }

  async findOne(term: string) {

    let product;

    if (isUUID(term)) {
      product = await this.prisma.product.findUnique({
        where: { id: term },
        include: { images: true }
      });
    } else {
      // Search by title or slug
      // TypeORM used UPPER(title) = :title which is case insensitive roughly if DB collation allows or we upper param.
      // Prisma: mode: 'insensitive'
      product = await this.prisma.product.findFirst({
        where: {
          OR: [
            { title: { equals: term, mode: 'insensitive' } },
            { slug: { equals: term.toLowerCase(), mode: 'insensitive' } } // Slug is usually lowercased
          ]
        },
        include: { images: true }
      });
    }


    if (!product)
      throw new NotFoundException(`Product with ${term} not found`);

    return product;
  }

  async findOnePlain(term: string) {
    const { images = [], ...rest } = await this.findOne(term);
    return {
      ...rest,
      images: images.map(image => image.url)
    }
  }


  async update(id: string, updateProductDto: UpdateProductDto, user: User) {

    const { images, ...toUpdate } = updateProductDto;

    const productExists = await this.prisma.product.findUnique({ where: { id } });
    if (!productExists) throw new NotFoundException(`Product with id: ${id} not found`);

    if (toUpdate.slug) {
      toUpdate.slug = toUpdate.slug.toLowerCase().replaceAll(' ', '_').replaceAll("'", '');
    } else if (toUpdate.title) {
      // Should we re-slugify title if slug wasn't provided but title was?
      // TypeORM logic: @BeforeUpdate checkSlugUpdate() uses existing slug value potentially
      // Here we modify only if provided.
      // If user creates title "A", slug "a". Updates title "B", slug logic in Entity updated it only if slug changed?
      // TypeORM: checkSlugUpdate() => this.slug = this.slug...
      // It always reprocessed the slug. 
      // If I update title but not slug, should slug change? Usually no, unless derived.
      // But if I pass slug, it sanitizes it.
    }

    try {

      // Transaction for update
      const product = await this.prisma.$transaction(async (tx) => {

        // 1. Update images if provided
        if (images) {
          // Delete old images
          await tx.productImage.deleteMany({ where: { productId: id } });
          // We could use deleteMany + create, or set (if we had IDs)
          // But here we are replacing logic
        }

        // 2. Update product
        const updatedProduct = await tx.product.update({
          where: { id },
          data: {
            ...toUpdate,
            userId: user.id, // Update user who modified it? Yes
            images: images ? {
              create: images.map(url => ({ url }))
            } : undefined
          },
          include: { images: true }
        });

        return updatedProduct;
      });

      return this.findOnePlain(id);

    } catch (error) {
      this.handleDBExceptions(error);
    }

  }

  async remove(id: string) {
    await this.findOne(id); // Check exist
    try {
      await this.prisma.product.delete({ where: { id } });
    } catch (error) {
      this.handleDBExceptions(error);
    }
  }


  private handleDBExceptions(error: any) {

    if (error.code === 'P2002')
      throw new BadRequestException('Unique constraint violation (duplicate key)');

    this.logger.error(error)
    throw new InternalServerErrorException('Unexpected error, check server logs');

  }

  async deleteAllProducts() {
    try {
      // Delete all
      return await this.prisma.product.deleteMany({});
    } catch (error) {
      this.handleDBExceptions(error);
    }
  }

}
