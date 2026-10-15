# Requisitos del Sistema de Gestión y Seguimiento de Trabajos de Grado

Proyecto: parcial de Java (segundo corte) — UTS
Documento base para los checkpoints 1, 2 y 3.

Convenciones:

- **RF-**nn → requisito funcional. Cada RF indica el rol que lo usa y el
  checkpoint en que se entrega (**CP1**, **CP2**, **CP3**).
- **RNF-**nn → requisito no funcional (aplica a todo el sistema).
- Estado: **Implementado** (probado en CP1) o **Pendiente**.

---

## 1. Requisitos funcionales — Autenticación, sesión y autorización

| ID | Requisito | Rol | Checkpoint | Estado |
|---|---|---|---|---|
| RF-01 | Iniciar sesión con correo institucional y contraseña | Todos | CP1 | Implementado |
| RF-02 | Cerrar sesión y volver al login | Todos | CP1 | Implementado |
| RF-03 | Impedir el acceso a cualquier ruta privada sin sesión iniciada (redirige a `/login`) | Todos | CP1 | Implementado |
| RF-04 | Restringir cada prefijo de URL (`/admin/*`, `/coordinacion/*`, `/director/*`, `/evaluador/*`, `/estudiante/*`) al rol correspondiente | Todos | CP1 | Implementado |
| RF-05 | Mostrar página de error 403 cuando el rol no tiene permiso sobre la ruta | Todos | CP1 | Implementado |
| RF-06 | Redirigir al usuario a la página de inicio de su rol después de entrar | Todos | CP1 | Implementado |
| RF-07 | Mostrar mensajes de error de login que no revelen si falló el correo o la contraseña | Todos | CP1 | Implementado |
| RF-08 | Bloquear el acceso de usuarios con `activo = 0` (cuenta desactivada) | Todos | CP1 | Implementado |
| RF-09 | Regenerar el identificador de sesión al iniciar sesión (evita fijación de sesión) | Todos | CP1 | Implementado |
| RF-10 | Cerrar la sesión automáticamente tras 30 minutos de inactividad | Todos | CP1 | Implementado |
| RF-11 | Ver la página de inicio del rol con el menú de sus módulos y los módulos futuros marcados "Próximamente" | Todos | CP1 | Implementado |
| RF-12 | Mostrar páginas de error 404 y 500 del sistema | Todos | CP1 | Implementado |

## 2. Requisitos funcionales — Módulo Administrador

| ID | Requisito | Rol | Checkpoint | Estado |
|---|---|---|---|---|
| RF-13 | Registrar usuarios (docentes, coordinación, alumnos) con código, nombres, apellidos, correo, rol y contraseña | ADMIN | CP1 | Implementado |
| RF-14 | Listar los usuarios registrados | ADMIN | CP1 | Implementado |
| RF-15 | Buscar usuarios por nombre, código o correo | ADMIN | CP1 | Implementado |
| RF-16 | Filtrar el listado de usuarios por rol | ADMIN | CP1 | Implementado |
| RF-17 | Paginar el listado de usuarios | ADMIN | CP1 | Implementado |
| RF-18 | Ver el detalle de un usuario | ADMIN | CP1 | Implementado |
| RF-19 | Editar los datos de un usuario; la contraseña es opcional | ADMIN | CP1 | Implementado |
| RF-20 | Eliminar un usuario con confirmación previa | ADMIN | CP1 | Implementado |
| RF-21 | Activar o desactivar un usuario (baja/alta lógica) | ADMIN | CP1 | Implementado |
| RF-22 | Rechazar códigos y correos duplicados | ADMIN | CP1 | Implementado |
| RF-23 | Exigir contraseñas de mínimo 8 caracteres | ADMIN | CP1 | Implementado |
| RF-24 | Impedir que el administrador se elimine o se desactive a sí mismo | ADMIN | CP1 | Implementado |
| RF-25 | Si el usuario tiene anteproyectos asociados, hacer baja lógica (`activo = 0`) en lugar de borrarlo | ADMIN | CP1 | Implementado |
| RF-26 | Guardar las contraseñas cifradas con PBKDF2 (nunca en claro) | ADMIN | CP1 | Implementado |
| RF-27 | Validar en el servidor todos los datos del formulario de usuarios | ADMIN | CP1 | Implementado |
| RF-28 | Confirmar el resultado de cada operación con mensajes de éxito o error (POST-Redirect-GET) | ADMIN | CP1 | Implementado |

## 3. Requisitos funcionales — Coordinación (Checkpoint 2)

| ID | Requisito | Rol | Checkpoint | Estado |
|---|---|---|---|---|
| RF-29 | Registrar, editar, consultar y eliminar ideas de anteproyecto (estado DISPONIBLE/TOMADA) | COORDINACION | CP2 | Pendiente |
| RF-30 | Asignar director y evaluador a un anteproyecto (deben ser distintos) | COORDINACION | CP2 | Pendiente |
| RF-31 | Buscar estudiante por código o nombre y ver su anteproyecto | COORDINACION | CP2 | Pendiente |
| RF-32 | Generar informes del estado de los proyectos por alumno, por director y por evaluador | COORDINACION | CP2 | Pendiente |
| RF-33 | Consultar el calendario académico | COORDINACION | CP2 | Pendiente |
| RF-34 | Consultar y descargar los formatos de grado | COORDINACION | CP2 | Pendiente |

## 4. Requisitos funcionales — Estudiante (Checkpoint 2)

| ID | Requisito | Rol | Checkpoint | Estado |
|---|---|---|---|---|
| RF-35 | Ver las ideas disponibles y seleccionar una (la idea pasa a TOMADA) | ESTUDIANTE | CP2 | Pendiente |
| RF-36 | Crear su anteproyecto en estado BORRADOR (máximo uno activo) | ESTUDIANTE | CP2 | Pendiente |
| RF-37 | Editar su anteproyecto mientras esté en BORRADOR o CON_CORRECCIONES | ESTUDIANTE | CP2 | Pendiente |
| RF-38 | Subir el documento del anteproyecto (PDF/DOC validado) y entregarlo | ESTUDIANTE | CP2 | Pendiente |
| RF-39 | Ver la información del director y del evaluador asignados | ESTUDIANTE | CP2 | Pendiente |
| RF-40 | Ver el informe con la calificación de su anteproyecto | ESTUDIANTE | CP2 | Pendiente |
| RF-41 | Consultar el calendario académico y los formatos de grado | ESTUDIANTE | CP2 | Pendiente |

## 5. Requisitos funcionales — Director y Evaluador (Checkpoint 3)

| ID | Requisito | Rol | Checkpoint | Estado |
|---|---|---|---|---|
| RF-42 | Ver los anteproyectos de los estudiantes que dirige | DIRECTOR | CP3 | Pendiente |
| RF-43 | Ver la información del estudiante | DIRECTOR | CP3 | Pendiente |
| RF-44 | Calificar un anteproyecto (nota 0.0–5.0, observaciones y decisión) | DIRECTOR | CP3 | Pendiente |
| RF-45 | Aprobar el anteproyecto para el evaluador, devolverlo con correcciones o rechazarlo | DIRECTOR | CP3 | Pendiente |
| RF-46 | Consultar el calendario académico y los formatos de grado | DIRECTOR | CP3 | Pendiente |
| RF-47 | Ver los anteproyectos aprobados por el director | EVALUADOR | CP3 | Pendiente |
| RF-48 | Evaluar un anteproyecto (aprobar, con correcciones o rechazar) | EVALUADOR | CP3 | Pendiente |
| RF-49 | Consultar el calendario académico y los formatos de grado | EVALUADOR | CP3 | Pendiente |
| RF-50 | Validar en el servidor las transiciones de estado del anteproyecto (nadie puede saltarse pasos) | DIRECTOR, EVALUADOR, ESTUDIANTE | CP3 | Pendiente |

---

## 6. Requisitos no funcionales

### Seguridad

| ID | Requisito | Estado |
|---|---|---|
| RNF-01 | Las contraseñas se almacenan con PBKDF2WithHmacSHA256, sal aleatoria por usuario y formato `iteraciones:salBase64:hashBase64`. Nunca se guardan ni se registran en claro | Implementado |
| RNF-02 | Todas las consultas usan `PreparedStatement` y cierran recursos con try-with-resources | Implementado |
| RNF-03 | Sin SQL ni scriptlets en los JSP (solo JSTL + EL) | Implementado |
| RNF-04 | Toda salida dinámica se escapa con `<c:out>` o `fn:escapeXml` | Implementado |
| RNF-05 | Validación obligatoria en el servidor (el navegador nunca es confiable) | Implementado |
| RNF-06 | Regeneración del id de sesión al iniciar sesión y cookie `HttpOnly` | Implementado |
| RNF-07 | Sesión de 30 minutos y controles `no-store` en páginas privadas | Implementado |
| RNF-08 | Autorización por prefijo de URL (rol) + autorización a nivel de objeto (un estudiante solo ve su anteproyecto, etc.) | Parcial: el filtro de rol está implementado; la validación por objeto llega con los módulos de datos |
| RNF-09 | Subida de archivos con `@MultipartConfig`, validación de extensión y tamaño, nombre UUID y almacenamiento fuera del webapp; descarga solo por un servlet que verifique permisos | Pendiente (CP2) |
| RNF-10 | Los mensajes de error no revelan información interna del sistema | Implementado |

### Usabilidad

| ID | Requisito | Estado |
|---|---|---|
| RNF-11 | Interfaz en español, limpia y responsive (móvil, tablet, escritorio) | Implementado |
| RNF-12 | Contraste accesible (WCAG AA en el texto principal) y foco visible en los controles | Implementado |
| RNF-13 | Mensajes de éxito y error visibles junto a la acción que se acaba de realizar | Implementado |
| RNF-14 | Formularios con etiquetas asociadas, orden de tabulación natural y acciones de confirmación en operaciones destructivas | Implementado |
| RNF-15 | Paleta institucional aplicada con variables CSS (`--color-primario #C3D730`, grises y neutros) | Implementado |

### Compatibilidad

| ID | Requisito | Estado |
|---|---|---|
| RNF-16 | Apache Tomcat 9 (Servlet 4.0 / JSP 2.3 / JSTL 1.2) y JDK 11 o superior | Implementado |
| RNF-17 | Uso exclusivo del namespace `javax.*` (nada de `jakarta.*`) | Implementado |
| RNF-18 | MariaDB 10.4+ con InnoDB y `utf8mb4`; driver `org.mariadb.jdbc.Driver` | Implementado |
| RNF-19 | Sin Maven, Gradle, Spring, Hibernate, JPA ni dependencias por CDN | Implementado |
| RNF-20 | Context path fijo `/TrabajosGrado`; todas las rutas se construyen con `pageContext.request.contextPath` | Implementado |

### Rendimiento

| ID | Requisito | Estado |
|---|---|---|
| RNF-21 | Paginación en todos los listados (nunca se carga la tabla completa) | Implementado |
| RNF-22 | Índices en columnas de búsqueda y en las llaves foráneas | Implementado |
| RNF-23 | Una sola consulta por página de resultados (sin consultas N+1) | Implementado |
| RNF-24 | Carga de la página de inicio por debajo de 1 segundo en red local | Implementado |

### Mantenibilidad

| ID | Requisito | Estado |
|---|---|---|
| RNF-25 | Arquitectura MVC por capas: `model`, `dao`, `controller`, `filter`, `util` | Implementado |
| RNF-26 | Un servlet por módulo con el parámetro `accion` y patrón POST-Redirect-GET | Implementado |
| RNF-27 | Código y nombres de dominio en español, clases pequeñas y sin código muerto | Implementado |
| RNF-28 | Build reproducible por script (`build.sh`) sin herramientas externas | Implementado |
| RNF-29 | Documentación viva en `README.md` y `docs/` (requisitos, historias, plan) | Implementado |
| RNF-30 | Configuración de la base de datos fuera del código (`db.properties`) y no versionada | Implementado |
