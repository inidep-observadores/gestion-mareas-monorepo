import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { GotenbergService } from './gotenberg.service';
import { HttpException, HttpStatus } from '@nestjs/common';
import axios from 'axios';

jest.mock('axios');
const mockedAxios = axios as jest.Mocked<typeof axios>;

describe('GotenbergService', () => {
  let service: GotenbergService;
  let configService: ConfigService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GotenbergService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn().mockReturnValue('http://gotenberg:3000'),
          },
        },
      ],
    }).compile();

    service = module.get<GotenbergService>(GotenbergService);
    configService = module.get<ConfigService>(ConfigService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('convertHtmlToPdf', () => {
    it('debe generar un PDF a partir de HTML exitosamente', async () => {
      // Arrange
      const htmlContent = '<h1>Test</h1>';
      const fakePdfBuffer = Buffer.from('fake pdf content');
      mockedAxios.post.mockResolvedValueOnce({ data: fakePdfBuffer });

      // Act
      const result = await service.convertHtmlToPdf(htmlContent);

      // Assert
      expect(result).toBeInstanceOf(Buffer);
      expect(result.toString()).toBe('fake pdf content');
      expect(mockedAxios.post).toHaveBeenCalledTimes(1);
      expect(mockedAxios.post.mock.calls[0][0]).toBe('http://gotenberg:3000/forms/chromium/convert/html');
    });

    it('debe lanzar HttpException cuando falla la conversión', async () => {
      // Arrange
      const htmlContent = '<h1>Test</h1>';
      mockedAxios.post.mockRejectedValueOnce(new Error('Gotenberg error'));

      // Act & Assert
      await expect(service.convertHtmlToPdf(htmlContent)).rejects.toThrow(HttpException);
      await expect(service.convertHtmlToPdf(htmlContent)).rejects.toThrow('No se pudo generar el documento PDF desde el contenido original');
    });
  });
});
