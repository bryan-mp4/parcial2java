-- ============================================================================
--  Sistema de gestión y seguimiento de trabajos de grado - UTS
--  02_datos_prueba.sql : datos iniciales para el entorno de pruebas
-- ----------------------------------------------------------------------------
--  ATENCIÓN: este script BORRA los datos actuales (TRUNCATE) y carga
--  únicamente lo necesario para el CHECKPOINT 1:
--     * los 5 roles
--     * un usuario por rol (admin, coordinador, director, evaluador, estudiante)
--     * 3 estudiantes adicionales
--     * 1 usuario inactivo para probar el bloqueo de cuenta
--
--  Las contraseñas se guardan HASHEADAS con PBKDF2WithHmacSHA256 (mismo
--  algoritmo que usa la aplicación: util.Seguridad). Formato
--  "iteraciones:salBase64:hashBase64" con 200000 iteraciones.
--  Los hashes se generaron ejecutando:
--     java -cp build/classes edu.uts.grados.util.Seguridad 'Admin.2026' ...
--  Las contraseñas en claro están documentadas SOLO en el README.md.
-- ============================================================================

USE trabajos_grado;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE revisiones;
TRUNCATE TABLE anteproyectos;
TRUNCATE TABLE ideas;
TRUNCATE TABLE eventos_calendario;
TRUNCATE TABLE formatos_grado;
TRUNCATE TABLE usuarios;
TRUNCATE TABLE roles;

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------------
-- Roles
-- ----------------------------------------------------------------------------
INSERT INTO roles (id, nombre) VALUES
    (1, 'ADMIN'),
    (2, 'COORDINACION'),
    (3, 'DIRECTOR'),
    (4, 'EVALUADOR'),
    (5, 'ESTUDIANTE');

-- ----------------------------------------------------------------------------
-- Usuarios (un hash por usuario: cada uno tiene su propia sal aleatoria)
-- ----------------------------------------------------------------------------
INSERT INTO usuarios (id, codigo, nombres, apellidos, correo, password_hash, rol_id, activo) VALUES
    (1, 'ADM-1001', 'Ana María',   'Ramírez Torres', 'admin@uts.edu.co',
     '200000:WbBNwpEZfSPwWLqrw7JY/g==:ItOfPb+XQkG0jc4MHhDeJitNTtq0knvacSP0sn6Fqmo=', 1, 1),

    (2, 'COO-2001', 'Carlos Andrés', 'Mejía Vargas',  'coordinacion@uts.edu.co',
     '200000:2oIuUKqCkmRYWZBMBLrGUQ==:gQEl78UWtqoJ5tIrynAFAwJZ/mVcgfbMCf7sKYJCKKg=', 2, 1),

    (3, 'DOC-3001', 'Luis Alberto', 'Fernández Ruiz', 'director@uts.edu.co',
     '200000:8e9iSy6mRhlOPQd2aflGtw==:GMk9rf5lCmjJ1rkwcHQnSNlRuAgl7j5NIefQIO6U1qQ=', 3, 1),

    (4, 'DOC-3002', 'Marta Lucía',  'Ortega Peña',    'evaluador@uts.edu.co',
     '200000:KqwWvXNWW1dIQ6peMAK3kw==:4SZ5Lbqrr6VoNZ/j+3SG4AXHX/dhZMJJAYtYWRhFI4Q=', 4, 1),

    (5, '20251001', 'Juan David',   'Pérez Gómez',    'estudiante@uts.edu.co',
     '200000:OwJvSFC8FBYOVBu83iEg0w==:59FewPBnLStgYGfLYLQy4JKkftu1+fSft8jd1YPhPrg=', 5, 1),

    (6, '20251002', 'Laura Camila', 'Sánchez Díaz',   'estudiante2@uts.edu.co',
     '200000:5BTguUR02WxpB0zhcJPetQ==:nV9jIrcWBYHnQtMRcVdQyDSaJ6Z7wIbaLPJ22zF8xfU=', 5, 1),

    (7, '20251003', 'Santiago',     'Núñez Rojas',    'estudiante3@uts.edu.co',
     '200000:RPyjYXavlW88nsHekxhmGw==:TuwfvSYVlNVKG3FHJnq8qTUmzUOdxNb4DdeAEog8zJs=', 5, 1),

    (8, '20251004', 'Valentina',    'Castro León',    'estudiante4@uts.edu.co',
     '200000:3AXeukLD09rXMh3T8+8/5w==:yLhkgrti1KEY8PRg/YsS5ZglDHgMzmjzocfY+HN7JV0=', 5, 1),

    -- Usuario inactivo: sirve para comprobar que una cuenta desactivada no entra
    (9, '20251999', 'Pedro José',   'Ruiz Mora',      'inactivo@uts.edu.co',
     '200000:VOntWdiTwjDX3dlos832hw==:tEU0Vr/lVfnD26FJLFhL+H9Ph1vjp9mStXCrplljaH0=', 5, 0);

-- ----------------------------------------------------------------------------
-- (OPCIONAL) Datos para probar la regla "si el usuario tiene anteproyectos
-- asociados se hace baja lógica (activo = 0) en vez de borrarlo".
-- Descomenta este bloque si quieres tener anteproyectos de prueba.
-- Se borrará cuando importes los datos del CHECKPOINT 2.
-- ----------------------------------------------------------------------------
-- INSERT INTO ideas (id, titulo, descripcion, estado, creada_por) VALUES
--     (1, 'App móvil para control de asistencia en laboratorios',
--      'Sistema de registro de asistencia por QR en los laboratorios de la UTS.',
--      'TOMADA', 2);
--
-- INSERT INTO anteproyectos (id, idea_id, estudiante_id, director_id, evaluador_id, titulo, resumen, estado) VALUES
--     (1, 1, 5, 3, 4, 'App móvil para control de asistencia en laboratorios',
--      'Prototipo de app Android con lector de código QR y panel web de reportes.',
--      'ENTREGADO'),
--     (2, NULL, 6, 3, NULL, 'Plataforma web de seguimiento a egresados',
--      'Módulo de encuestas y tablero de indicadores de empleabilidad.',
--      'BORRADOR');

-- ============================================================================
-- Fin de 02_datos_prueba.sql
-- ============================================================================
