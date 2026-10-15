# Plan de Trabajo

Distribución del proyecto en los tres checkpoints del parcial. Estado actual:
**Checkpoint 1 completo**.

Leyenda: ✅ Hecho · ⏳ En curso · ⬜ Pendiente

---

## Checkpoint 1 — Fundamentos, login y módulo Administrador

| # | Tarea | Entregable | Estado |
|---|---|---|---|
| 1.1 | Estructura de carpetas del proyecto (`src/main/java`, `src/main/webapp`, `db`, `docs`, `uploads`, `build`) | Árbol de carpetas | ✅ |
| 1.2 | `.gitignore` (build/, uploads/, db.properties, *.class, WAR, IDE) | `.gitignore` | ✅ |
| 1.3 | `db.properties.example` (host, puerto, base, usuario, contraseña) | Plantilla de configuración | ✅ |
| 1.4 | `README.md` inicial | `README.md` | ✅ |
| 1.5 | Script de build y empaquetado sin Maven (`javac` + `jar` → `build/TrabajosGrado.war`) con ruta de Tomcat configurable y opción de despliegue | `build.sh` | ✅ |
| 1.6 | `web.xml`: tiempo de sesión 30 min, páginas de error 403/404/500 y filtros globales | `WEB-INF/web.xml` | ✅ |
| 1.7 | Esquema completo de la base de datos (todas las tablas, FKs, índices, UNIQUE, InnoDB, utf8mb4) | `db/01_schema.sql` | ✅ |
| 1.8 | Datos de prueba: 5 roles, un usuario por rol y 3 estudiantes más, contraseñas hasheadas con la utilidad Java | `db/02_datos_prueba.sql` | ✅ |
| 1.9 | `util.Conexion` (lee `db.properties`, DriverManager, driver MariaDB) | `util/Conexion.java` | ✅ |
| 1.10 | `util.Seguridad` (PBKDF2 generar/verificar + utilidad de consola para los hashes) | `util/Seguridad.java` | ✅ |
| 1.11 | Modelos `Usuario` y `Rol` | `model/` | ✅ |
| 1.12 | `UsuarioDAO`: CRUD, búsqueda, filtro por rol, paginación, buscarPorCorreo, unicidad, contador de anteproyectos | `dao/UsuarioDAO.java` | ✅ |
| 1.13 | Login por correo y contraseña, logout, sesión con usuario y rol, id de sesión regenerado, mensajes de error genéricos | `controller/LoginServlet`, `controller/LogoutServlet` | ✅ |
| 1.14 | `AuthFilter` (rutas públicas: `/login` y `/assets/*`), `CodificacionFilter` (UTF-8) y `RolFilter` por prefijo de URL; acceso no autorizado → 403 | `filter/` | ✅ |
| 1.15 | Redirección a la página de inicio de cada rol | `controller/InicioServlet` | ✅ |
| 1.16 | Layout común (`header`, `menu` por rol con `c:if`, `footer`, mensajes flash) y CSS con las variables de color del proyecto | `views/comun/`, `assets/css/estilos.css` | ✅ |
| 1.17 | Página de inicio de cada rol con tarjetas de módulos futuros "Próximamente" | `views/{admin,coordinacion,director,evaluador,estudiante}/inicio.jsp` | ✅ |
| 1.18 | CRUD de usuarios: listar con búsqueda/filtro/paginación, crear, ver detalle, editar (contraseña opcional) y eliminar con confirmación | `controller/admin/UsuarioServlet` + 4 JSP | ✅ |
| 1.19 | Reglas del CRUD: código y correo únicos, contraseña mínima 8 caracteres, el admin no se elimina ni se desactiva a sí mismo, baja lógica si hay anteproyectos asociados, usuario inactivo no entra | Implementado y verificado | ✅ |
| 1.20 | Documentación: `docs/requisitos.md`, `docs/historias_usuario.md`, `docs/plan_trabajo.md` | `docs/` | ✅ |
| 1.21 | Compilación sin errores y verificación del WAR (sin `jakarta.*`, sin scriptlets, sin SQL en JSP) | `build/TrabajosGrado.war` | ✅ |

---

## Checkpoint 2 — Coordinación y Estudiante

| # | Tarea | Entregable | Estado |
|---|---|---|---|
| 2.1 | Módulo de ideas de anteproyecto (CRUD coordinación) | `controller/coordinacion/IdeaServlet`, `dao/IdeaDAO`, vistas | ⬜ |
| 2.2 | Asignación de director y evaluador (deben ser distintos) | `controller/coordinacion/AsignacionServlet` | ⬜ |
| 2.3 | Búsqueda de estudiante por código o nombre y consulta de su anteproyecto | vistas de coordinación | ⬜ |
| 2.4 | Informes por alumno, por director y por evaluador | `controller/coordinacion/InformeServlet` | ⬜ |
| 2.5 | Módulo del estudiante: seleccionar idea, CRUD de su anteproyecto, ver director/evaluador | `controller/estudiante/AnteproyectoServlet` | ⬜ |
| 2.6 | Subida de archivos con `@MultipartConfig`, validación de extensión/tamaño y guardado con UUID en `uploads/` | servlet de archivos + `util.Archivos` | ⬜ |
| 2.7 | Calendario académico (CRUD coordinación, consulta para todos) | `controller/coordinacion/EventoServlet`, vistas | ⬜ |
| 2.8 | Formatos de grado (CRUD coordinación, descarga para todos) | `controller/coordinacion/FormatoServlet` | ⬜ |
| 2.9 | Entrega del anteproyecto (ENTREGADO) e informe de calificación del estudiante | vistas de estudiante | ⬜ |
| 2.10 | Pruebas de integración del flujo estudiante ↔ coordinación | evidencias | ⬜ |

## Checkpoint 3 — Director y Evaluador

| # | Tarea | Entregable | Estado |
|---|---|---|---|
| 3.1 | Módulo del director: listado de sus anteproyectos e información del estudiante | `controller/director/AnteproyectoServlet` | ⬜ |
| 3.2 | Registro de revisiones del director (nota, observaciones, decisión) y transición de estados | `dao/RevisionDAO` + validación de transiciones | ⬜ |
| 3.3 | Aprobación para el evaluador (APROBADO_DIRECTOR) y devolución con correcciones | controlador de director | ⬜ |
| 3.4 | Módulo del evaluador: listado de APROBADO_DIRECTOR y registro de la evaluación | `controller/evaluador/AnteproyectoServlet` | ⬜ |
| 3.5 | Aprobación final (APROBADO_EVALUADOR) visible para estudiante y coordinación | flujo de estados | ⬜ |
| 3.6 | Validación de todas las transiciones de estado (nadie se salta pasos) | utilidad de estados | ⬜ |
| 3.7 | Ajustes de interfaz, pruebas finales y cierre de documentación | informe final | ⬜ |

---

## Dependencias importantes

- El Checkpoint 2 necesita las tablas `ideas`, `anteproyectos` y la carpeta
  `uploads/` (ya creadas y ya ignoradas por git).
- La regla de **baja lógica** del Checkpoint 1 ya está probada con
  anteproyectos (bloque opcional en `db/02_datos_prueba.sql`).
- El Checkpoint 3 reutiliza `RevisionDAO` sobre `revisiones` y las validaciones
  de estado que se definan en el Checkpoint 2.
