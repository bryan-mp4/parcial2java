-- ============================================================================
--  Sistema de gestión y seguimiento de trabajos de grado - UTS
--  01_schema.sql : estructura completa de la base de datos
-- ----------------------------------------------------------------------------
--  Motor  : MariaDB (InnoDB) / MySQL 8
--  Charset: utf8mb4 (soporta tildes, eñes y emojis)
--  Importar desde phpMyAdmin sobre una base de datos YA CREADA llamada
--  "trabajos_grado" (este script NO incluye CREATE DATABASE).
--
--  Incluye todas las tablas del modelo, incluso las que se usan en los
--  checkpoints 2 y 3 (ideas, anteproyectos, revisiones, calendario, formatos).
-- ============================================================================

USE trabajos_grado;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Limpieza previa (solo para re-importar el script sin errores)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS revisiones;
DROP TABLE IF EXISTS anteproyectos;
DROP TABLE IF EXISTS ideas;
DROP TABLE IF EXISTS eventos_calendario;
DROP TABLE IF EXISTS formatos_grado;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;

-- ----------------------------------------------------------------------------
-- roles : catálogo de roles del sistema
-- ----------------------------------------------------------------------------
CREATE TABLE roles (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    nombre  VARCHAR(30) NOT NULL UNIQUE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- usuarios : administradores, coordinación, directores, evaluadores y estudiantes
-- ----------------------------------------------------------------------------
CREATE TABLE usuarios (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    codigo        VARCHAR(20)  NOT NULL UNIQUE,
    nombres       VARCHAR(60)  NOT NULL,
    apellidos     VARCHAR(60)  NOT NULL,
    correo        VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
                  COMMENT 'PBKDF2WithHmacSHA256: iteraciones:salBase64:hashBase64',
    rol_id        INT          NOT NULL,
    activo        TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 = puede entrar, 0 = cuenta desactivada',
    creado_en     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) REFERENCES roles (id),
    INDEX idx_usuarios_rol (rol_id),
    INDEX idx_usuarios_apellidos (apellidos, nombres)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- ideas : ideas de anteproyecto publicadas por coordinación
-- ----------------------------------------------------------------------------
CREATE TABLE ideas (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    titulo      VARCHAR(150) NOT NULL,
    descripcion TEXT         NULL,
    estado      ENUM('DISPONIBLE','TOMADA') NOT NULL DEFAULT 'DISPONIBLE',
    creada_por  INT          NULL,
    creada_en   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ideas_creador FOREIGN KEY (creada_por) REFERENCES usuarios (id),
    INDEX idx_ideas_estado (estado),
    INDEX idx_ideas_creada_por (creada_por)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- anteproyectos : documento seguido desde BORRADOR hasta APROBADO_EVALUADOR
-- director_id y evaluador_id son NULL hasta que coordinación los asigna.
-- ----------------------------------------------------------------------------
CREATE TABLE anteproyectos (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    idea_id        INT          NULL,
    estudiante_id  INT          NOT NULL,
    director_id    INT          NULL,
    evaluador_id   INT          NULL,
    titulo         VARCHAR(150) NOT NULL,
    resumen        TEXT         NULL,
    archivo_nombre VARCHAR(255) NULL COMMENT 'Nombre original del documento',
    archivo_ruta   VARCHAR(255) NULL COMMENT 'Ruta en el servidor (fuera del webapp)',
    estado         ENUM('BORRADOR','ENTREGADO','CON_CORRECCIONES',
                        'APROBADO_DIRECTOR','APROBADO_EVALUADOR','RECHAZADO')
                   NOT NULL DEFAULT 'BORRADOR',
    creado_en      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_anteproyectos_idea       FOREIGN KEY (idea_id)       REFERENCES ideas (id),
    CONSTRAINT fk_anteproyectos_estudiante FOREIGN KEY (estudiante_id) REFERENCES usuarios (id),
    CONSTRAINT fk_anteproyectos_director   FOREIGN KEY (director_id)   REFERENCES usuarios (id) ON DELETE SET NULL,
    CONSTRAINT fk_anteproyectos_evaluador  FOREIGN KEY (evaluador_id)  REFERENCES usuarios (id) ON DELETE SET NULL,
    INDEX idx_anteproyectos_estudiante (estudiante_id),
    INDEX idx_anteproyectos_director (director_id),
    INDEX idx_anteproyectos_evaluador (evaluador_id),
    INDEX idx_anteproyectos_estado (estado),
    INDEX idx_anteproyectos_idea (idea_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- revisiones : calificaciones y decisiones del director y del evaluador
-- ----------------------------------------------------------------------------
CREATE TABLE revisiones (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    anteproyecto_id  INT NOT NULL,
    revisor_id       INT NOT NULL,
    rol_revisor      ENUM('DIRECTOR','EVALUADOR') NOT NULL,
    nota             DECIMAL(2,1) NULL COMMENT 'Escala 0.0 a 5.0',
    observaciones    TEXT NULL,
    decision         ENUM('APROBADO','CON_CORRECCIONES','RECHAZADO') NOT NULL,
    fecha            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_revisiones_anteproyecto FOREIGN KEY (anteproyecto_id) REFERENCES anteproyectos (id),
    CONSTRAINT fk_revisiones_revisor      FOREIGN KEY (revisor_id)      REFERENCES usuarios (id),
    CONSTRAINT chk_revisiones_nota CHECK (nota IS NULL OR (nota >= 0 AND nota <= 5)),
    INDEX idx_revisiones_anteproyecto (anteproyecto_id),
    INDEX idx_revisiones_revisor (revisor_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- eventos_calendario : calendario académico compartido por todos los roles
-- ----------------------------------------------------------------------------
CREATE TABLE eventos_calendario (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    titulo      VARCHAR(150) NOT NULL,
    descripcion TEXT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin   DATE NULL,
    creado_por  INT NULL,
    CONSTRAINT fk_eventos_creador FOREIGN KEY (creado_por) REFERENCES usuarios (id),
    INDEX idx_eventos_fecha (fecha_inicio),
    INDEX idx_eventos_creado_por (creado_por)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- formatos_grado : documentos y enlaces de formatos de grado
-- ----------------------------------------------------------------------------
CREATE TABLE formatos_grado (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    descripcion     TEXT NULL,
    archivo_nombre  VARCHAR(255) NULL,
    archivo_ruta    VARCHAR(255) NULL,
    enlace_externo  VARCHAR(255) NULL,
    subido_por      INT NULL,
    creado_en       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_formatos_subido FOREIGN KEY (subido_por) REFERENCES usuarios (id),
    INDEX idx_formatos_subido_por (subido_por)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- Fin de 01_schema.sql
-- ============================================================================
