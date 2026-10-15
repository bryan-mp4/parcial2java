# Sistema de Gestión y Seguimiento de Trabajos de Grado — UTS

Proyecto académico (parcial de Java, segundo corte) que administra los trabajos de
grado de las Unidades Tecnológicas de Santander: desde la idea y el anteproyecto
hasta la entrega del documento final.

**Checkpoint actual: 1 — Fundamentos, login y módulo Administrador.**

---

## 1. Stack y requisitos

| Componente | Versión | Notas |
|---|---|---|
| JDK | 11, 17 o 21 | El script compila con `--release 11` (bytecode compatible con Tomcat 9) |
| Servidor | Apache Tomcat 9 | Servlet 4.0 / JSP 2.3 / JSTL 1.2 |
| Base de datos | MariaDB 10.4+ (InnoDB, utf8mb4) | Instalada de forma independiente; **no** XAMPP/LAMPP |
| Driver | `mariadb-java-client-3.5.10.jar` | Ya está en `src/main/webapp/WEB-INF/lib/` |
| JSTL | `jstl-1.2.jar` | Ya está en `src/main/webapp/WEB-INF/lib/` |

**Prohibido / no usado:** Maven, Gradle, Spring, Hibernate, JPA, frameworks JS,
dependencias por CDN, páginas JSP con scriptlets y cualquier importación
`jakarta.*` (todo el código usa `javax.servlet.*`).

---

## 2. Estructura del proyecto

```
TrabajosGrado/
├── build.sh                      Compila, empaqueta el WAR y (opcional) despliega
├── db.properties.example         Plantilla de configuración de la base de datos
├── db.properties                 Configuración real (NO se versiona)
├── .gitignore
├── README.md
├── db/
│   ├── 01_schema.sql             Todas las tablas, FKs, índices, UNIQUE, InnoDB, utf8mb4
│   └── 02_datos_prueba.sql       Roles + 9 usuarios de prueba (contraseñas hasheadas)
├── docs/
│   ├── requisitos.md             RF y RNF numerados
│   ├── historias_usuario.md      Historias con criterios de aceptación
│   └── plan_trabajo.md           Tareas por checkpoint
├── uploads/                      Archivos subidos (NO se versiona)
├── src/main/java/edu/uts/grados/
│   ├── model/                    Usuario, Rol
│   ├── dao/                      UsuarioDAO (CRUD, búsqueda, filtro, paginación)
│   ├── controller/               LoginServlet, LogoutServlet, InicioServlet
│   │   └── admin/                UsuarioServlet (CRUD de usuarios)
│   ├── filter/                   CodificacionFilter (UTF-8), AuthFilter, RolFilter
│   └── util/                     Conexion, Seguridad, Roles, Validacion, Flash
└── src/main/webapp/
    ├── login.jsp                 Página pública de inicio de sesión
    ├── assets/{css,js,img}/      estilos.css, app.js
    └── WEB-INF/
        ├── web.xml               Filtros, sesión 30 min, errores 403/404/500
        ├── lib/                  jstl-1.2.jar, mariadb-java-client-3.5.10.jar
        └── views/
            ├── comun/            header, menu, footer, mensajes, error403/404/500
            ├── admin/            inicio + usuarios (lista, formulario, detalle, confirmar)
            ├── coordinacion/     inicio
            ├── director/         inicio
            ├── evaluador/        inicio
            └── estudiante/       inicio
```

Cadena de filtros (en este orden, definida en `web.xml`):
`CodificacionFilter` (fuerza UTF-8 en el cuerpo de los formularios) →
`AuthFilter` (exige sesión) → `RolFilter` (exige el rol del prefijo de URL).

Arquitectura MVC por capas:
`navegador → Servlet (controller) → DAO → request.setAttribute → forward a JSP en
WEB-INF/views`. Los JSP no se acceden de forma directa, no tienen SQL ni
scriptlets: solo JSTL + EL.

---

## 3. Puesta en marcha

### 3.1 Crear la base de datos (una sola vez, en phpMyAdmin)

```sql
CREATE DATABASE trabajos_grado CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 3.2 Importar los scripts SQL (en este orden)

1. `db/01_schema.sql` — crea las tablas.
2. `db/02_datos_prueba.sql` — carga los 5 roles y los usuarios de prueba.

> `02_datos_prueba.sql` hace `TRUNCATE` de las tablas implicadas: sirve para un
> entorno de pruebas y se puede volver a ejecutar.

### 3.3 Configurar la conexión

```bash
cp db.properties.example db.properties
# editar host, puerto, base, usuario, contrasena
```

`util.Conexion` busca el archivo en este orden:

1. ruta indicada en `-Ddb.props=/ruta/db.properties` o en la variable de entorno
   `TRABAJOS_GRADO_DB_PROPS`;
2. `db.properties` empaquetado en `WEB-INF/classes/db.properties` (lo hace
   `build.sh` cuando el archivo existe en la raíz del proyecto);
3. valores por defecto `localhost:3306/trabajos_grado` (con aviso en el log).

### 3.4 Compilar y empaquetar

```bash
./build.sh
```

Genera `build/TrabajosGrado.war`. No usa Maven ni Gradle: `javac` con el
classpath `WEB-INF/lib/*` + `servlet-api.jar` y `jsp-api.jar` de Tomcat.

### 3.5 Desplegar en Tomcat 9

El script tiene la ruta de Tomcat en la parte superior (`RUTA_TOMCAT`,
`RUTA_WEBAPPS`). Tres opciones:

**Opción A — copiar el WAR (recomendada):**

```bash
sudo ./build.sh --desplegar
sudo systemctl restart tomcat9
```

**Opción B — manual:** copia `build/TrabajosGrado.war` a `$RUTA_WEBAPPS/` y
reinicia Tomcat.

**Opción C — Tomcat Manager:** entra en `http://localhost:8080/manager/html`,
sube `TrabajosGrado.war` con *Context Path* `/TrabajosGrado`.

> **Importante:** el proyecto está ubicado en
> `/var/lib/tomcat9/webapps/TrabajosGrado` (dentro de `webapps`). Si despliegas
> el WAR con ese mismo nombre, Tomcat intentará expandirlo en la misma carpeta y
> **podría borrar el código fuente**. El script detecta el caso y se niega a
> copiar salvo que fuerces con `FORZAR=1`. Lo más limpio es mover el proyecto
> fuera de `webapps` (por ejemplo a `~/TrabajosGrado`) o desplegarlo con otro
> nombre de contexto.

### 3.6 Abrir la aplicación

```
http://localhost:8080/TrabajosGrado/login
```

---

## 4. Usuarios y contraseñas de prueba

Todos se crean con `db/02_datos_prueba.sql`. Las contraseñas se almacenan con
**PBKDF2WithHmacSHA256** (200 000 iteraciones, sal aleatoria de 16 bytes por
usuario) en el formato `iteraciones:salBase64:hashBase64`.

| Correo | Contraseña | Rol | Qué prueba |
|---|---|---|---|
| `admin@uts.edu.co` | `Admin.2026` | ADMIN | CRUD de usuarios |
| `coordinacion@uts.edu.co` | `Coord.2026` | COORDINACION | Su inicio y el 403 al entrar a `/admin/*` |
| `director@uts.edu.co` | `Direc.2026` | DIRECTOR | Su inicio y el 403 |
| `evaluador@uts.edu.co` | `Eval.2026` | EVALUADOR | Su inicio y el 403 |
| `estudiante@uts.edu.co` | `Estu.2026` | ESTUDIANTE | Su inicio y el 403 |
| `estudiante2@uts.edu.co` | `Estu.2026` | ESTUDIANTE | Listado/paginación |
| `estudiante3@uts.edu.co` | `Estu.2026` | ESTUDIANTE | Listado/paginación |
| `estudiante4@uts.edu.co` | `Estu.2026` | ESTUDIANTE | Listado/paginación |
| `inactivo@uts.edu.co` | `Estu.2026` | ESTUDIANTE (**inactivo**) | No puede iniciar sesión |

> Para regenerar hashes (por ejemplo al cambiar contraseñas de prueba):
> ```bash
> ./build.sh
> java -cp build/classes edu.uts.grados.util.Seguridad 'MiClave123'
> ```
> La utilidad imprime **solo el hash**, nunca la contraseña en claro.

---

## 5. Cómo probar el Checkpoint 1

1. **Login correcto:** entra con cada uno de los 5 usuarios por rol y comprueba
   que aterrizas en su propia página de inicio (`/admin/inicio`,
   `/coordinacion/inicio`, `/director/inicio`, `/evaluador/inicio`,
   `/estudiante/inicio`).
2. **Login incorrecto:** correo válido + contraseña mala, y correo inexistente.
   En ambos casos el mensaje es el mismo: *"Correo o contraseña incorrectos."*
   (no revela qué dato falló).
3. **Usuario inactivo:** intenta entrar con `inactivo@uts.edu.co`; no pasa del
   login.
4. **Autorización:** con la sesión de `coordinacion@uts.edu.co` abierta, escribe
   `http://localhost:8080/TrabajosGrado/admin/usuarios` → **403** con la página
   de "Acceso denegado". Repite con los demás roles.
5. **Sin sesión:** abre `/admin/usuarios` en una ventana de incógnito → te
   redirige a `/login` con el mensaje *"Debes iniciar sesión…"*.
6. **Timeout de sesión:** deja la sesión inactiva más de 30 minutos (o prueba con
   un `<session-timeout>` de 1 minuto) y vuelve a usar la aplicación → te manda
   al login.
7. **CRUD de usuarios (admin):**
   - Crear usuario con código/correo duplicados → mensaje de error y no crea.
   - Crear con contraseña de 5 caracteres → error *"mínimo 8 caracteres"*.
   - Buscar por nombre, código y correo; filtrar por rol; pasar de página.
   - Editar un usuario sin escribir contraseña (no se cambia) y con contraseña
     nueva.
   - Intentar eliminar o desactivar tu propio usuario (`admin@uts.edu.co`) →
     mensaje de error y no se aplica.
   - Con el bloque opcional de datos de prueba de `02_datos_prueba.sql`
     (un estudiante con anteproyecto), eliminar ese estudiante → el sistema
     informa que tiene anteproyectos y aplica **baja lógica** (activo = 0).
8. **Errores:** entra a `http://localhost:8080/TrabajosGrado/no-existe` → 404.

---

## 6. Identidad visual

Paleta definida con variables CSS en `:root` (`assets/css/estilos.css`):

| Variable | Color | Uso |
|---|---|---|
| `--color-primario` | `#C3D730` (Pantone 382 C) | Fondo de botones, enlaces activos, foco. Sobre fondo claro nunca como color de texto: se usa como fondo con texto `#1E1E1E`. |
| `--gris-sobre-oscuro` | `#B3B3B3` (Cool Gray 5 C) | Textos secundarios sobre fondos oscuros. |
| `--gris-sobre-claro` | `#878787` (Pantone 877 C) | Textos secundarios, bordes y detalles sobre fondos claros. |
| neutros | `#FFFFFF`, `#F5F5F5`, `#222` | Fondos y encabezado/menú lateral oscuro. |

Layout: menú lateral oscuro fijo, contenido claro, tarjetas, tablas legibles,
formularios con foco en color primario y alertas de éxito/error. Responsive
(pasa a una columna por debajo de 900 px).

---

## 7. Documentación

- [`docs/requisitos.md`](docs/requisitos.md) — requisitos funcionales (RF) y no funcionales (RNF).
- [`docs/historias_usuario.md`](docs/historias_usuario.md) — historias de usuario con criterios de aceptación.
- [`docs/plan_trabajo.md`](docs/plan_trabajo.md) — tareas y estado por checkpoint.

---

## 8. Supuestos del Checkpoint 1

1. El nombre de la base de datos es `trabajos_grado` y se crea a mano (los
   scripts no incluyen `CREATE DATABASE`).
2. `RUTA_TOMCAT=/usr/share/tomcat9` y `RUTA_WEBAPPS=/var/lib/tomcat9/webapps`
   porque es la instalación detectada en este equipo; en otra instalración
   (Arch/cachyOS con `/opt/tomcat9`) solo hay que cambiar esas dos variables al
   inicio de `build.sh`.
3. PBKDF2 con 200 000 iteraciones: tarda ~0,1 s por login, margen de seguridad
   aceptable para el parcial. Se puede bajar en `util.Seguridad` si se necesita
   más velocidad.
4. "Un estudiante tiene máximo un anteproyecto activo" se validará en la
   aplicación (MariaDB no permite índices únicos parciales).
5. Los usuarios inactivos y los mensajes de error del login comparten mensaje
   genérico a propósito: no se revela si el correo existe.
6. Las rutas `/calendario` y `/formatos` ya están declaradas en `AuthFilter` y
   `RolFilter` (compartidas por cualquier rol autenticado), pero sus módulos se
   construyen en el Checkpoint 2.
7. Los formularios se envían en UTF-8 y `CodificacionFilter` lo fuerza en el
   servidor, para que tildes y eñes se guarden correctamente en MariaDB.
8. Se verificó la compilación (`javac`) y el empaquetado del WAR; la prueba
   funcional completa (login de los 5 roles, 403, CRUD) se hace de forma manual
   como indica la sección 5.
# parcial2java
