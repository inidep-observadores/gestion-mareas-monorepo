
export enum DbfFieldType {
    Character = 'C',
    Numeric = 'N',
    Logical = 'L',
    Date = 'D',
}

export interface DbfField {
    name: string;
    type: DbfFieldType;
    length: number;
    decimal?: number;
}

/**
 * A simple DBF (dBase III) writer compatible with Visual FoxPro 9.
 */
export class DbfWriter {
    private fields: DbfField[] = [];
    private records: Record<string, any>[] = [];

    constructor() {}

    addField(field: DbfField) {
        if (field.name.length > 10) {
            field.name = field.name.substring(0, 10);
        }
        this.fields.push(field);
    }

    addRecord(record: Record<string, any>) {
        this.records.push(record);
    }

    build(): Buffer {
        const now = new Date();
        const headerSize = 32 + (this.fields.length * 32) + 1;
        
        let recordSize = 1; // Delete flag byte
        for (const field of this.fields) {
            recordSize += field.length;
        }

        const bufferSize = headerSize + (this.records.length * recordSize) + 1; // +1 for terminator 0x1A
        const buffer = Buffer.alloc(bufferSize, 0x00);

        // --- Header Section ---
        buffer.writeUInt8(0x03, 0); // Version (dBase III without memo)
        buffer.writeUInt8(now.getFullYear() - 1900, 1);
        buffer.writeUInt8(now.getMonth() + 1, 2);
        buffer.writeUInt8(now.getDate(), 3);
        buffer.writeUInt32LE(this.records.length, 4);
        buffer.writeUInt16LE(headerSize, 8);
        buffer.writeUInt16LE(recordSize, 10);

        // --- Field Descriptor Section ---
        for (let i = 0; i < this.fields.length; i++) {
            const field = this.fields[i];
            const offset = 32 + (i * 32);

            // Name (11 bytes, null terminated if < 10)
            const nameBuf = Buffer.from(field.name, 'ascii');
            nameBuf.copy(buffer, offset, 0, Math.min(nameBuf.length, 10));
            // Type (1 byte)
            buffer.write(field.type, offset + 11, 'ascii');
            // Length (1 byte)
            buffer.writeUInt8(field.length, offset + 16);
            // Decimal count (1 byte)
            buffer.writeUInt8(field.decimal || 0, offset + 17);
        }

        buffer.writeUInt8(0x0D, 32 + (this.fields.length * 32)); // Header terminator

        // --- Data Records Section ---
        let currentPos = headerSize;
        for (const record of this.records) {
            buffer.writeUInt8(0x20, currentPos); // Delete flag (space = not deleted)
            currentPos += 1;

            for (const field of this.fields) {
                let value = record[field.name];
                let strValue = '';

                if (value === null || value === undefined) {
                    strValue = ''.padEnd(field.length, ' ');
                } else if (field.type === DbfFieldType.Numeric) {
                    const num = Number(value);
                    if (isNaN(num)) {
                        strValue = ''.padStart(field.length, ' ');
                    } else {
                        strValue = num.toFixed(field.decimal || 0);
                        strValue = strValue.padStart(field.length, ' ');
                    }
                } else if (field.type === DbfFieldType.Character) {
                    strValue = String(value).substring(0, field.length);
                    strValue = strValue.padEnd(field.length, ' ');
                } else {
                    strValue = String(value).substring(0, field.length);
                    strValue = strValue.padEnd(field.length, ' ');
                }

                buffer.write(strValue, currentPos, field.length, 'latin1');
                currentPos += field.length;
            }
        }

        buffer.writeUInt8(0x1A, currentPos); // EOF marker

        return buffer;
    }
}
