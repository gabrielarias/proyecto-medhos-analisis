/*
  PROYECTO MEDHOS - ESQUEMA DE BASE DE DATOS
  Motor: PostgreSQL
  Fecha: Diciembre 2025
  Descripción: Define tablas de dimensiones y la tabla de hechos (raw) para la ingesta de SIGA.
*/

-- ========================================================
-- 1. TABLAS DE DIMENSIONES (Maestros)
-- ========================================================

-- Dimension: Depósitos (Medicamentos, Odontología, etc.)
CREATE TABLE IF NOT EXISTS dim_depositos (
    cod_deposito VARCHAR(10) PRIMARY KEY,
    nombre_deposito VARCHAR(50)
);

-- Carga inicial de datos maestros conocidos
INSERT INTO dim_depositos (cod_deposito, nombre_deposito) VALUES
('2678', 'Biomédico'),
('2311', 'Medicamentos'),
('2015', 'Odontológico'),
('2878', 'Laboratorio')
ON CONFLICT (cod_deposito) DO NOTHING;

-- Dimension: Tipos de Movimiento (Entradas vs Salidas)
CREATE TABLE IF NOT EXISTS dim_tipos_movimiento (
    cod_tipo VARCHAR(10) PRIMARY KEY,
    descripcion_movimiento VARCHAR(50),
    sentido VARCHAR(10) -- 'ENTRADA' o 'SALIDA'
);

-- Carga inicial de lógica de negocio
INSERT INTO dim_tipos_movimiento (cod_tipo, descripcion_movimiento, sentido) VALUES
('2',  'Entrada por Compra',   'ENTRADA'),
('29', 'Entrada Ajuste/Otros', 'ENTRADA'),
('1',  'Salida a Efector',     'SALIDA'),
('27', 'Salida Ajuste/Otros',  'SALIDA'),
('17', 'Receta Afiliado',      'SALIDA')
ON CONFLICT (cod_tipo) DO NOTHING;

-- ========================================================
-- 2. TABLA DE HECHOS (RAW DATA)
-- ========================================================

-- Soporta tanto Entradas (con Proveedor) como Salidas (con Depósito Origen)
-- Se recomienda limpiar la tabla antes de una recarga masiva completa si no es incremental.
-- DROP TABLE IF EXISTS raw_movimientos_siga; 

CREATE TABLE IF NOT EXISTS raw_movimientos_siga (
    id SERIAL PRIMARY KEY,
    
    -- Metadatos del Archivo Origen
    nombre_archivo VARCHAR(100),
    tipo_archivo_detectado VARCHAR(20), -- 'ENTRADA' o 'SALIDA'
    fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Columnas Comunes del SIGA
    cod_insumo VARCHAR(50),
    descripcion_insumo TEXT,
    fecha_movimiento DATE,
    tipo_movimiento_cod VARCHAR(10), -- FK lógica hacia dim_tipos_movimiento
    nro_remito VARCHAR(50),
    nro_factura VARCHAR(50),
    nro_orden VARCHAR(50),
    nro_lote VARCHAR(50),
    fecha_vencimiento DATE, 

    -- Columnas Dinámicas (Según si es Entrada o Salida)
    cod_proveedor VARCHAR(50),      -- Solo Entradas (Archivos 2, 29)
    nombre_proveedor VARCHAR(150),  -- Solo Entradas
    
    deposito_origen_cod VARCHAR(50),  -- Solo Salidas (Archivos 1, 17, 27)
    deposito_origen_desc VARCHAR(150),-- Solo Salidas

    -- Destino (Siempre presente)
    deposito_destino_cod VARCHAR(50),
    deposito_destino_desc VARCHAR(150),

    -- Métricas Financieras y Stock
    cantidad NUMERIC(15, 2),
    precio_unitario NUMERIC(15, 4), -- Precisión extendida para cálculos unitarios
    precio_total NUMERIC(15, 2)
);

-- ========================================================
-- 3. ÍNDICES DE RENDIMIENTO
-- ========================================================
CREATE INDEX IF NOT EXISTS idx_raw_fecha ON raw_movimientos_siga(fecha_movimiento);
CREATE INDEX IF NOT EXISTS idx_raw_insumo ON raw_movimientos_siga(cod_insumo);
CREATE INDEX IF NOT EXISTS idx_raw_archivo ON raw_movimientos_siga(nombre_archivo);
CREATE INDEX IF NOT EXISTS idx_raw_tipo_mov ON raw_movimientos_siga(tipo_movimiento_cod);