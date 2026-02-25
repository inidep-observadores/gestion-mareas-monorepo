import { Test, TestingModule } from '@nestjs/testing';
import { PnaTrackingParser } from './pna-tracking.parser';

describe('PnaTrackingParser', () => {
    let parser: PnaTrackingParser;

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [PnaTrackingParser],
        }).compile();

        parser = module.get<PnaTrackingParser>(PnaTrackingParser);
    });

    it('should be defined', () => {
        expect(parser).toBeDefined();
    });

    it('should parse tracking XML correctly', async () => {
        const xml = `<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
    <soap:Body>
        <GetPosicionesHistoricasResponse xmlns="http://200.41.238.203/">
            <GetPosicionesHistoricasResult>
                <Error error="false" mensaje=""/>
                <Reportes>
                    <Reporte matricula="0001" mmsi="12345" nombre="BUQUE TEST" latitud="-45.0" longitud="-65.0" fecha="2026-02-09 12:00:00" rumbo="180" velocidad="10.5" eslora="50.2"/>
                </Reportes>
            </GetPosicionesHistoricasResult>
        </GetPosicionesHistoricasResponse>
    </soap:Body>
</soap:Envelope>`;

        const result = await parser.parseXml(xml);
        expect(result.error).toBe(false);
        expect(result.reportes).toHaveLength(1);
        expect(result.reportes[0].nombre).toBe('BUQUE TEST');
        expect(result.reportes[0].matricula).toBe('0001');
        expect(result.reportes[0].latitud).toBe('-45.0');
        expect(result.reportes[0].velocidad).toBe('10.5');
    });

    it('should handle empty reports list', async () => {
        const xml = `<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
    <soap:Body>
        <GetPosicionesHistoricasResponse xmlns="http://200.41.238.203/">
            <GetPosicionesHistoricasResult>
                <Error error="false" mensaje=""/>
                <Reportes/>
            </GetPosicionesHistoricasResult>
        </GetPosicionesHistoricasResponse>
    </soap:Body>
</soap:Envelope>`;

        const result = await parser.parseXml(xml);
        expect(result.reportes).toHaveLength(0);
    });
});
