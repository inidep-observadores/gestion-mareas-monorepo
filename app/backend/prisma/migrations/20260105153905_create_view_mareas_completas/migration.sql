-- Drop the view if it exists
DROP VIEW IF EXISTS vw_mareas_completas;

-- Create the view vw_mareas_completas
CREATE VIEW vw_mareas_completas AS
WITH etapas_formateadas AS (
    SELECT 
        me.id_marea,
        me.nro_etapa,
        TO_CHAR(me.fecha_zarpada AT TIME ZONE 'America/Argentina/Buenos_Aires', 'DD/MM/YYYY') AS zarpada,
        pz.nombre AS puerto_zarpada,
        TO_CHAR(me.fecha_arribo AT TIME ZONE 'America/Argentina/Buenos_Aires', 'DD/MM/YYYY') AS arribo,
        pa.nombre AS puerto_arribo
    FROM mareas_etapas me
    LEFT JOIN puertos pz ON me.id_puerto_zarpada = pz.id
    LEFT JOIN puertos pa ON me.id_puerto_arribo = pa.id
)
SELECT 
    m.id,
    m.anio_marea, m.nro_marea, m.tipo_marea,
    CONCAT(m.anio_marea, '-', LPAD(m.nro_marea::text, 3, '0'), '-', m.tipo_marea) AS codigo_marea,
    b.nombre_buque AS buque, em.nombre AS estado,
    -- Etapa 1
    e1.zarpada AS zarpada_1, e1.puerto_zarpada AS pto_zarp_1, e1.arribo AS arribo_1, e1.puerto_arribo AS pto_arrib_1,
    -- Etapa 2
    e2.zarpada AS zarpada_2, e2.puerto_zarpada AS pto_zarp_2, e2.arribo AS arribo_2, e2.puerto_arribo AS pto_arrib_2,
    -- Etapa 3
    e3.zarpada AS zarpada_3, e3.puerto_zarpada AS pto_zarp_3, e3.arribo AS arribo_3, e3.puerto_arribo AS pto_arrib_3,
    -- Etapa 4
    e4.zarpada AS zarpada_4, e4.puerto_zarpada AS pto_zarp_4, e4.arribo AS arribo_4, e4.puerto_arribo AS pto_arrib_4,
    -- Etapa 5
    e5.zarpada AS zarpada_5, e5.puerto_zarpada AS pto_zarp_5, e5.arribo AS arribo_5, e5.puerto_arribo AS pto_arrib_5,
    -- Etapa 6
    e6.zarpada AS zarpada_6, e6.puerto_zarpada AS pto_zarp_6, e6.arribo AS arribo_6, e6.puerto_arribo AS pto_arrib_6,
    -- Etapa 7
    e7.zarpada AS zarpada_7, e7.puerto_zarpada AS pto_zarp_7, e7.arribo AS arribo_7, e7.puerto_arribo AS pto_arrib_7,
    -- Etapa 8
    e8.zarpada AS zarpada_8, e8.puerto_zarpada AS pto_zarp_8, e8.arribo AS arribo_8, e8.puerto_arribo AS pto_arrib_8,
    -- Etapa 9
    e9.zarpada AS zarpada_9, e9.puerto_zarpada AS pto_zarp_9, e9.arribo AS arribo_9, e9.puerto_arribo AS pto_arrib_9,
    -- Etapa 10
    e10.zarpada AS zarpada_10, e10.puerto_zarpada AS pto_zarp_10, e10.arribo AS arribo_10, e10.puerto_arribo AS pto_arrib_10,
    TO_CHAR(m.fecha_creacion AT TIME ZONE 'America/Argentina/Buenos_Aires', 'DD/MM/YYYY') AS fecha_registro
FROM mareas m
LEFT JOIN buques b ON m.id_buque = b.id
LEFT JOIN estados_marea em ON m.id_estado_actual = em.id
LEFT JOIN etapas_formateadas e1 ON m.id = e1.id_marea AND e1.nro_etapa = 1
LEFT JOIN etapas_formateadas e2 ON m.id = e2.id_marea AND e2.nro_etapa = 2
LEFT JOIN etapas_formateadas e3 ON m.id = e3.id_marea AND e3.nro_etapa = 3
LEFT JOIN etapas_formateadas e4 ON m.id = e4.id_marea AND e4.nro_etapa = 4
LEFT JOIN etapas_formateadas e5 ON m.id = e5.id_marea AND e5.nro_etapa = 5
LEFT JOIN etapas_formateadas e6 ON m.id = e6.id_marea AND e6.nro_etapa = 6
LEFT JOIN etapas_formateadas e7 ON m.id = e7.id_marea AND e7.nro_etapa = 7
LEFT JOIN etapas_formateadas e8 ON m.id = e8.id_marea AND e8.nro_etapa = 8
LEFT JOIN etapas_formateadas e9 ON m.id = e9.id_marea AND e9.nro_etapa = 9
LEFT JOIN etapas_formateadas e10 ON m.id = e10.id_marea AND e10.nro_etapa = 10;
