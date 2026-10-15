# CONTEXTO DEL PROYECTO (léelo completo antes de cada tarea)

Proyecto: "Sistema de gestión y seguimiento de los trabajos de grado de la UTS".
Es un parcial de Java (segundo corte). Objetivo: almacenar, organizar y dar
seguimiento a los trabajos de grado, desde la idea y el anteproyecto hasta la
entrega final del documento de grado.

## Entorno del desarrollador
- SO: cachyos
- JDK: [11/17]
- Tomcat 9 en: [RUTA_TOMCAT]
- IDE: [Eclipse/IntelliJ/NetBeans/VS Code/ninguno]
- MariaDB + phpMyAdmin instalados por separado (no XAMPP/LAMPP).

## Stack (obligatorio)
- Java + Servlets + JSP + JSTL + JDBC puro. Arquitectura MVC por capas.
- Servidor: TOMCAT 9 => Servlet 4.0 / JSP 2.3 / JSTL 1.2.
  Usa SIEMPRE el namespace javax.* (javax.servlet.*, javax.servlet.http.*,
  javax.servlet.annotation.*). PROHIBIDO jakarta.* (no funciona en Tomcat 9).
- URIs JSTL 1.2: http://java.sun.com/jsp/jstl/core (c),
  http://java.sun.com/jsp/jstl/fmt (fmt), http://java.sun.com/jsp/jstl/functions (fn).
- PROHIBIDO: Maven, Gradle, Spring, Hibernate, JPA, frameworks JS, scriptlets
  (<% %>) en los JSP. Solo EL + JSTL. Sin dependencias externas por CDN.
- Los JARs (jstl-1.2.jar y mariadb-java-client-3.x.jar) ya están en
  src/main/webapp/WEB-INF/lib/. No los descargues ni los modifiques. Driver:
  org.mariadb.jdbc.Driver, URL: jdbc:mariadb://localhost:3306/trabajos_grado.
- Sin Maven, entonces el build es por script: javac con classpath
  (WEB-INF/lib/* + servlet-api.jar y jsp-api.jar de [RUTA_TOMCAT]/lib) y
  empaquetado a WAR con la herramienta "jar". Context path: /TrabajosGrado.
  Servlets con @WebServlet (web.xml solo para filtros globales, páginas de
  error y timeout de sesión).

## Estructura del proyecto
TrabajosGrado/
  src/main/java/edu/uts/grados/{model,dao,controller,filter,util}
  src/main/webapp/
    WEB-INF/{lib,views/{comun,admin,coordinacion,director,evaluador,estudiante},web.xml}
    assets/{css,js,img}
    login.jsp (o equivalente público)
  db/            scripts SQL
  docs/          documentación
  uploads/       archivos subidos (NO se versiona)
  build/         salida del build (NO se versiona)
  db.properties.example   (db.properties real NO se versiona)
  .gitignore, README.md, script de build/deploy

## Reglas de arquitectura
- Flujo: navegador -> Servlet (controller) -> DAO -> request.setAttribute ->
  forward a un JSP dentro de WEB-INF/views. Los JSP nunca se acceden directo.
- Los JSP no contienen SQL ni lógica de negocio. Reutiliza header/menu/footer
  con <jsp:include> o <c:import>. El menú cambia según el rol con <c:if>.
- Un servlet por módulo, con parámetro "accion" (listar, nuevo, guardar,
  editar, eliminar, ver). Patrón POST-Redirect-GET en toda operación que modifique datos,
  con mensajes flash en sesión.
- URLs por rol: /admin/*, /coordinacion/*, /director/*, /evaluador/*,
  /estudiante/* (protegidas por AuthFilter y RolFilter). /calendario y /formatos
  son compartidas por todos los roles autenticados.
- Autorización a nivel de objeto: no basta con el rol. Un estudiante solo ve su
  anteproyecto, un director solo los suyos, etc. (verifícalo en el servlet/DAO).

## Seguridad
- Solo PreparedStatement. Cierra recursos con try-with-resources.
- Contraseñas con PBKDF2WithHmacSHA256 (JDK), sal aleatoria por usuario, formato
  "iteraciones:salBase64:hashBase64". Nunca guardes ni registres en log una contraseña en claro.
- Escapa toda salida con <c:out> o fn:escapeXml. Valida SIEMPRE en servidor.
- Regenera el id de sesión al iniciar sesión. Timeout de 30 min.
- Subida de archivos: @MultipartConfig, valida extensión y tamaño, guárdalos en
  una carpeta fuera del webapp con nombre generado (UUID), y descárgalos solo por
  un servlet que verifique permisos.

## Modelo de datos (MariaDB, InnoDB, utf8mb4)
roles(id, nombre)  -> ADMIN, COORDINACION, DIRECTOR, EVALUADOR, ESTUDIANTE
usuarios(id, codigo UNIQUE, nombres, apellidos, correo UNIQUE, password_hash,
         rol_id FK, activo, creado_en)
ideas(id, titulo, descripcion, estado ENUM('DISPONIBLE','TOMADA'),
      creada_por FK usuarios, creada_en)
anteproyectos(id, idea_id FK, estudiante_id FK, director_id FK NULL,
      evaluador_id FK NULL, titulo, resumen, archivo_nombre, archivo_ruta,
      estado ENUM('BORRADOR','ENTREGADO','CON_CORRECCIONES','APROBADO_DIRECTOR',
      'APROBADO_EVALUADOR','RECHAZADO'), creado_en, actualizado_en)
revisiones(id, anteproyecto_id FK, revisor_id FK, rol_revisor ENUM('DIRECTOR','EVALUADOR'),
      nota DECIMAL(2,1) NULL (escala 0.0 a 5.0), observaciones TEXT,
      decision ENUM('APROBADO','CON_CORRECCIONES','RECHAZADO'), fecha)
eventos_calendario(id, titulo, descripcion, fecha_inicio, fecha_fin NULL, creado_por FK)
formatos_grado(id, nombre, descripcion, archivo_nombre, archivo_ruta,
      enlace_externo, subido_por FK, creado_en)
Los scripts NO incluyen CREATE DATABASE (yo la creo). Empiezan con USE trabajos_grado;

## Roles e historias de usuario (de la presentación del parcial)
- Administrador ("CREA USUARIOS"): registrar usuarios (docentes, coordinación,
  alumnos); ver, editar y eliminar los datos de los usuarios.
- Coordinación: CRUD de ideas de anteproyecto; agregar un director a un
  anteproyecto; buscar por código o nombre del estudiante para ver su
  proyecto/anteproyecto; informes del estado del proyecto por alumno, por
  director y por evaluador; consultar calendario académico y formatos de grado.
- Estudiante: seleccionar idea de proyecto; CRUD para subir su anteproyecto (en
  el CRUD aparece la información del director y del evaluador); informe para ver
  la calificación de su anteproyecto; consultar calendario y formatos.
- Director: CRUD para calificar los anteproyectos subidos por sus alumnos; ver
  la información del alumno; aprobar el anteproyecto para el evaluador;
  consultar calendario y formatos.
- Evaluador: CRUD de los anteproyectos aprobados por el director; aprobar
  anteproyectos para alumnos y coordinación; consultar calendario y formatos.

## Flujo del anteproyecto (supuesto de diseño)
1. Coordinación crea ideas (DISPONIBLE).
2. Estudiante toma una idea (pasa a TOMADA) y crea su anteproyecto (BORRADOR).
   Un estudiante tiene máximo un anteproyecto activo.
3. Coordinación asigna director y evaluador (deben ser distintos).
4. Estudiante sube el documento y lo entrega (ENTREGADO). Solo edita en
   BORRADOR o CON_CORRECCIONES.
5. Director revisa y registra una revisión: APROBADO -> APROBADO_DIRECTOR (pasa
   al evaluador); CON_CORRECCIONES -> vuelve al estudiante; RECHAZADO.
6. Evaluador revisa los APROBADO_DIRECTOR: APROBADO -> APROBADO_EVALUADOR (visible
   para estudiante y coordinación); CON_CORRECCIONES o RECHAZADO.
Las transiciones se validan en el servidor; nadie puede saltar pasos.

## Identidad visual (obligatoria, CSS con variables en :root)
- --color-primario: #C3D730 (Pantone 382 C). Botones principales, acentos,
  enlaces activos, bordes de foco. En fondo claro NO lo uses como color de
  texto (poco contraste); úsalo como fondo con texto oscuro (#1E1E1E).
- --gris-sobre-oscuro: #B3B3B3 (Cool Gray 5 C). Textos/iconos secundarios sobre
  fondos oscuros.
- --gris-sobre-claro: #878787 (Pantone 877 C). Textos secundarios, bordes y
  detalles sobre fondos claros.
- Neutros permitidos: blanco, #F5F5F5 y un casi negro (#222) para encabezado y
  menú lateral oscuro. Texto principal sobre claro: #222.
- UI limpia y responsive, formularios claros, tablas legibles, mensajes de
  éxito/error visibles. Contraste accesible (WCAG AA en texto principal).

## Reglas de trabajo
- Trabaja SOLO en el alcance del checkpoint pedido. No adelantes módulos.
- NO hagas git commit/push/branch (yo manejo git). NO ejecutes SQL contra mi base de datos:
  solo escribe los .sql en /db (los importo yo en phpMyAdmin).

## VERIFICACIÓN: lo único que puedes ejecutar
- SÍ: el script de build para verificar que compila y que el WAR se genera.
- NO: iniciar, detener ni configurar Tomcat; abrir puertos o servidores propios.
- NO: usar curl, wget, scripts de prueba HTTP, jars de cookies, Selenium ni
  ningún cliente que simule navegación o login.
- NO: crear archivos fuera de la carpeta del proyecto (nada en /tmp ni en otras rutas).
- NO: intentar conectarte a la base de datos.
- Las pruebas funcionales las hago yo a mano. Tu trabajo es dejar el código
  correcto y entregarme una LISTA DE PRUEBAS MANUALES (en el informe final,
  numerada, con URL, usuario, acción y resultado esperado).
- Verifica leyendo el código: sigue el flujo servlet -> DAO -> JSP y revisa que
  coincida con los criterios de aceptación. Si no puedes verificar algo sin
  ejecutarlo, escríbelo en "pendientes por probar", no lo pruebes tú.

## LÍMITES ANTI-BUCLE
- Si el build falla, corrige y reintenta como máximo 3 veces. Si sigue fallando,
  detente y repórtame el error exacto y tu hipótesis.
- Si algo no funciona y no puedes resolverlo leyendo el código, no lo depures
  por tu cuenta con scripts: repórtamelo y sigue con lo siguiente.
- No reescribas código que ya funciona para "mejorarlo" salvo que el
  checkpoint lo pida.
- Antes de cada tarea nueva, dime en una línea qué vas a hacer; si llevas más
  de 15 pasos en la misma tarea sin avanzar, para y pregúntame.