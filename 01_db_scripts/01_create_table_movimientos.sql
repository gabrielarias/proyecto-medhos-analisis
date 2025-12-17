-- TABLA RAW UNIFICADA (Versión 2.0)
-- Soporta tanto Entradas (con Proveedor) como Salidas (con Depósito Origen)
DROP TABLE IF EXISTS raw_movimientos_siga;

CREATE TABLE raw_movimientos_siga (
    id SERIAL PRIMARY KEY,
    -- Campos de Auditoría del Archivo
    nombre_archivo VARCHAR(100),
    tipo_archivo_detectado VARCHAR(20), -- 'ENTRADA' o 'SALIDA'
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Columnas Comunes
    cod_insumo VARCHAR(50),
    descripcion_insumo TEXT,
    fecha_movimiento DATE,
    tipo_movimiento_cod VARCHAR(10), -- Columna 'T' del archivo
    nro_remito VARCHAR(50),
    nro_factura VARCHAR(50),
    nro_orden VARCHAR(50),
    nro_lote VARCHAR(50),
    fecha_vencimiento DATE, -- Ojo: Manejar nulos en el ETL

    -- Columnas Variables (Estructura A vs B)
    cod_proveedor VARCHAR(50),      -- Solo para Entradas (2, 29)
    nombre_proveedor VARCHAR(150),  -- Solo para Entradas (2, 29)
    
    deposito_origen_cod VARCHAR(50),  -- Solo para Salidas (1, 17, 27)
    deposito_origen_desc VARCHAR(150),-- Solo para Salidas (1, 17, 27)

    -- Columnas de Destino (Siempre están)
    deposito_destino_cod VARCHAR(50),
    deposito_destino_desc VARCHAR(150),

    -- Métricas
    cantidad NUMERIC(15, 2),
    precio_unitario NUMERIC(15, 4), -- Aumento precisión a 4 decimales por si acaso
    precio_total NUMERIC(15, 2)
);

-- Índices Actualizados
CREATE INDEX idx_raw_fecha ON raw_movimientos_siga(fecha_movimiento);
CREATE INDEX idx_raw_insumo ON raw_movimientos_siga(cod_insumo);
CREATE INDEX idx_raw_archivo ON raw_movimientos_siga(nombre_archivo);