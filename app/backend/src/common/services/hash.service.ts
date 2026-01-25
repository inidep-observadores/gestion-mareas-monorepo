import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';

@Injectable()
export class HashService {
    /**
     * Hashes a plain text string using bcrypt.
     * @param plainText The string to hash.
     * @param saltRounds The number of salt rounds (default 10).
     * @returns The hashed string.
     */
    hash(plainText: string, saltRounds: number = 10): string {
        return bcrypt.hashSync(plainText, saltRounds);
    }

    /**
     * Compares a plain text string with a hash.
     * @param plainText The plain text string.
     * @param hash The hash to compare against.
     * @returns True if they match, false otherwise.
     */
    compare(plainText: string, hash: string): boolean {
        return bcrypt.compareSync(plainText, hash);
    }
}
