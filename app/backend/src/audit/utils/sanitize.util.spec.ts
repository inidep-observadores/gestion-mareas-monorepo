import { sanitizeObject } from './sanitize.util';

describe('SanitizeUtil', () => {
    it('should return null or undefined as is', () => {
        expect(sanitizeObject(null)).toBeNull();
        expect(sanitizeObject(undefined)).toBeUndefined();
    });

    it('should not modify non-sensitive objects', () => {
        const obj = { name: 'John', age: 30, active: true };
        expect(sanitizeObject(obj)).toEqual(obj);
    });

    it('should redact sensitive fields at root level', () => {
        const obj = {
            username: 'admin',
            password: 'secretPassword',
            token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
        };
        const sanitized = sanitizeObject(obj);

        expect(sanitized.username).toBe('admin');
        expect(sanitized.password).toBe('***REDACTED***');
        expect(sanitized.token).toBe('***REDACTED***');
    });

    it('should redact sensitive fields nested deeply', () => {
        const obj = {
            user: {
                profile: {
                    email: 'test@test.com',
                    creditCard: '1234-5678-9012-3456'
                }
            },
            metadata: {
                apiKeys: {
                    google: 'AIzaSyD',
                    aws: {
                        accessKeyId: 'AKIAIOSFODNN7EXAMPLE',
                        secretAccessKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
                    }
                }
            }
        };

        const sanitized = sanitizeObject(obj);

        expect(sanitized.user.profile.creditCard).toBe('***REDACTED***');
        expect(sanitized.metadata.apiKeys.aws.secretAccessKey).toBe('***REDACTED***'); // 'secret' in key name matches sensitive list
    });

    it('should handle arrays of objects', () => {
        const list = [
            { id: 1, password: 'p1' },
            { id: 2, password: 'p2' }
        ];

        const sanitized = sanitizeObject(list);

        expect(sanitized[0].password).toBe('***REDACTED***');
        expect(sanitized[1].password).toBe('***REDACTED***');
    });

    it('should be case insensitive for field names', () => {
        const obj = {
            PaSsWoRd: '123456',
            NEWpassword: 'changed'
        };

        const sanitized = sanitizeObject(obj);
        expect(sanitized.PaSsWoRd).toBe('***REDACTED***');
        expect(sanitized.NEWpassword).toBe('***REDACTED***');
    });
});
