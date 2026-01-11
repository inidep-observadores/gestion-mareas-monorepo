export declare class HashService {
    hash(plainText: string, saltRounds?: number): string;
    compare(plainText: string, hash: string): boolean;
}
