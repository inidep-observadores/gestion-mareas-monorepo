import { existsSync } from 'fs';
import { join } from 'path';

import { Injectable, BadRequestException } from '@nestjs/common';


@Injectable()
export class FilesService {

    getStaticProductImage(imageName: string) {

        const path = join(process.cwd(), 'static/products', imageName);

        if (!existsSync(path))
            throw new BadRequestException(`No product found with image ${imageName}`);

        return path;
    }

    getStaticUserImage(imageName: string) {

        const path = join(process.cwd(), 'static/users', imageName);

        if (!existsSync(path))
            throw new BadRequestException(`No user image found with name ${imageName}`);

        return path;
    }


}
