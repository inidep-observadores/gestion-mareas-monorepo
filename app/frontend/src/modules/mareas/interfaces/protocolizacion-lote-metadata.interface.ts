export interface ProtocolizacionLoteMetadata {
  email?: {
    to: string;
    cc?: string;
    subject: string;
    body: string; // Contenido HTML
  };
  enviadoPorCanalExterno?: boolean;
  timestamp: string;
}
