export interface ProtocolizacionLoteMetadata {
  email?: {
    to: string;
    cc?: string;
    bcc?: string;
    subject: string;
    body: string; // HTML content
  };
  textoAdicional?: string;
  enviadoPorCanalExterno?: boolean;
  timestamp: string;
}
