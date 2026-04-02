/**
 * Metadata personalizada para registros de MareaArchivo.
 * Este objeto se almacena como JSONB en la base de datos.
 */
export interface MareaArchivoMetadata {
  /**
   * Nombre original del archivo subido por el usuario.
   */
  originalName: string;

  /**
   * Tamaño del archivo en bytes (opcional).
   */
  size?: number;

  /**
   * Tipo MIME del archivo (opcional).
   */
  mimeType?: string;

  /**
   * Otros metadatos específicos que puedan surgir en el futuro.
   */
  [key: string]: any;
}
