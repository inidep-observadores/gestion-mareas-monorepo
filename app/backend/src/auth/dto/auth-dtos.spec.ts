import 'reflect-metadata';
import { validate } from 'class-validator';
import { CreateUserDto } from './create-user.dto';
import { LoginUserDto } from './login-user.dto';

describe('Auth DTOs', () => {
  describe('CreateUserDto', () => {
    it('should fail with invalid email', async () => {
      const dto = new CreateUserDto();
      dto.email = 'not-an-email';
      dto.password = 'Strong123!';
      dto.fullName = 'John Doe';
      
      const errors = await validate(dto);
      expect(errors.find(e => e.property === 'email')).toBeDefined();
    });

    it('should fail with weak password (missing uppercase)', async () => {
      const dto = new CreateUserDto();
      dto.email = 'test@test.com';
      dto.password = 'weakpassword123';
      dto.fullName = 'John Doe';
      
      const errors = await validate(dto);
      expect(errors.find(e => e.property === 'password')).toBeDefined();
    });

    it('should fail with weak password (missing number)', async () => {
        const dto = new CreateUserDto();
        dto.email = 'test@test.com';
        dto.password = 'WeakPassword';
        dto.fullName = 'John Doe';
        
        const errors = await validate(dto);
        expect(errors.find(e => e.property === 'password')).toBeDefined();
      });

    it('should pass with valid data', async () => {
      const dto = new CreateUserDto();
      dto.email = 'test@test.com';
      dto.password = 'Strong123!';
      dto.fullName = 'John Doe';
      
      const errors = await validate(dto);
      expect(errors.length).toBe(0);
    });
  });

  describe('LoginUserDto', () => {
    it('should fail with invalid email', async () => {
      const dto = new LoginUserDto();
      dto.email = 'invalid';
      dto.password = 'SomePass1';
      
      const errors = await validate(dto);
      expect(errors.find(e => e.property === 'email')).toBeDefined();
    });

    it('should pass with valid credentials', async () => {
      const dto = new LoginUserDto();
      dto.email = 'admin@admin.com';
      dto.password = 'Admin123!';
      
      const errors = await validate(dto);
      expect(errors.length).toBe(0);
    });
  });
});
