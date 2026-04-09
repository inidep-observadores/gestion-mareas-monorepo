export interface ProtocolizacionLoteMetadata {
  email?: {
    to: string;
    cc?: string;
    subject: string;
    body: string; // HTML content
  };
  enviadoPorCanalExterno?: boolean;
  timestamp: string;
}
