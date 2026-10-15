# Historias de Usuario

Formato: **Como** `<rol>` **quiero** `<acción>` **para** `<beneficio>`.
Cada historia incluye criterios de aceptación, prioridad (Alta / Media / Baja) y
el checkpoint en que se entrega.

Índice de estado del Checkpoint 1: todas las historias marcadas **CP1** están
implementadas.

---

## Checkpoint 1 — Fundamentos, login y módulo Administrador

### HU-01 · Iniciar sesión

**Como** usuario (cualquier rol) **quiero** iniciar sesión con mi correo y mi
contraseña **para** acceder a las funciones que me corresponden.

**Criterios de aceptación**

1. El formulario de login es público (`/login`) y pide correo y contraseña.
2. Si los datos son correctos y la cuenta está activa, se crea la sesión con el
   usuario y su rol.
3. El identificador de sesión se regenera al entrar.
4. Si los datos son incorrectos o la cuenta está inactiva, el mensaje es
   `Correo o contraseña incorrectos.` (no indica cuál dato falló).
5. Si falta algún campo, se muestra un mensaje claro.
6. Tras entrar, el usuario es redirigido a la página de inicio de su rol.

**Prioridad:** Alta · **Checkpoint:** CP1 · **Relacionado:** RF-01, RF-06, RF-07, RF-08, RF-09

---

### HU-02 · Cerrar sesión

**Como** usuario autenticado **quiero** cerrar mi sesión **para** que nadie más
use mi cuenta en el mismo equipo.

**Criterios de aceptación**

1. Existe el enlace "Cerrar sesión" en el menú lateral.
2. Al cerrar sesión se invalida la sesión y se vuelve a `/login`.
3. Se muestra el mensaje `Sesión cerrada correctamente…`.
4. Las páginas privadas dejan de ser accesibles con el botón "atrás".

**Prioridad:** Alta · **Checkpoint:** CP1 · **Relacionado:** RF-02, RF-03

---

### HU-03 · No poder entrar donde no me corresponde

**Como** administrador del sistema **quiero** que cada rol solo entre a sus
propias pantallas **para** proteger la información de los demás roles.

**Criterios de aceptación**

1. Sin sesión, al abrir `/admin/usuarios` el sistema redirige a `/login` con el
   mensaje `Debes iniciar sesión para acceder a esa página.`
2. Con sesión de otro rol, al abrir `/admin/*` se recibe un error **403** con la
   página "Acceso denegado".
3. Las rutas compartidas (`/inicio`) responden para cualquier rol autenticado.
4. Los usuarios inactivos no pueden iniciar sesión.

**Prioridad:** Alta · **Checkpoint:** CP1 · **Relacionado:** RF-03, RF-04, RF-05, RF-08

---

### HU-04 · Ver mi página de inicio

**Como** usuario autenticado **quiero** ver una página de inicio con los módulos
que me corresponden **para** saber qué puedo hacer en el sistema.

**Criterios de aceptación**

1. Cada rol tiene su propia página de inicio.
2. El menú lateral muestra únicamente las opciones del rol de la sesión.
3. Los módulos de checkpoints posteriores aparecen como tarjetas "Próximamente".
4. El menú muestra el nombre y el código del usuario.

**Prioridad:** Media · **Checkpoint:** CP1 · **Relacionado:** RF-11, RF-12

---

### HU-05 · Registrar usuarios

**Como** administrador **quiero** registrar usuarios (docentes, coordinación y
alumnos) **para** que puedan ingresar al sistema con su rol.

**Criterios de aceptación**

1. El formulario pide código, nombres, apellidos, correo, rol, contraseña y
   estado (activo).
2. El código y el correo deben ser únicos: si ya existen, se muestra el error y
   no se crea el usuario.
3. La contraseña debe tener al menos 8 caracteres.
4. La contraseña se guarda cifrada con PBKDF2 (nunca en claro).
5. Al crear se muestra el mensaje de éxito y se vuelve al listado.

**Prioridad:** Alta · **Checkpoint:** CP1 · **Relacionado:** RF-13, RF-22, RF-23, RF-26, RF-27, RF-28

---

### HU-06 · Consultar y buscar usuarios

**Como** administrador **quiero** listar los usuarios y buscarlos por nombre,
código o correo, filtrarlos por rol y paginarlos **para** encontrar rápido a una
persona.

**Criterios de aceptación**

1. El listado muestra código, nombre, correo, rol y estado.
2. La búsqueda funciona por nombres, apellidos, código o correo (parcial).
3. El filtro por rol muestra únicamente los usuarios de ese rol.
4. Los resultados se paginan (8 por página) y la paginación conserva la búsqueda
   y el filtro.
5. Si no hay resultados, se muestra un mensaje de "sin resultados".

**Prioridad:** Alta · **Checkpoint:** CP1 · **Relacionado:** RF-14, RF-15, RF-16, RF-17

---

### HU-07 · Ver y editar usuarios

**Como** administrador **quiero** ver el detalle de un usuario y editar sus datos
**para** mantener la información al día.

**Criterios de aceptación**

1. La vista de detalle muestra todos los datos, nunca la contraseña.
2. El formulario de edición permite cambiar código, nombres, apellidos, correo,
   rol y estado.
3. La contraseña es opcional: si se deja en blanco, no se modifica.
4. Si se escribe una contraseña nueva, debe tener al menos 8 caracteres.
5. El código y el correo deben seguir siendo únicos (sin contar el propio
   registro).
6. Un administrador no puede cambiarse su propio rol ni desactivarse a sí mismo.

**Prioridad:** Alta · **Checkpoint:** CP1 · **Relacionado:** RF-18, RF-19, RF-22, RF-24

---

### HU-08 · Eliminar o desactivar usuarios

**Como** administrador **quiero** eliminar un usuario con confirmación **para**
retirar del sistema a quien ya no participa.

**Criterios de aceptación**

1. Antes de eliminar se muestra una pantalla de confirmación con los datos del
   usuario.
2. El administrador no puede eliminarse ni desactivarse a sí mismo.
3. Si el usuario tiene anteproyectos asociados (como estudiante, director o
   evaluador), no se borra: se aplica baja lógica (`activo = 0`) y se informa de
   la situación.
4. Si no tiene anteproyectos pero tiene otra información relacionada (ideas,
   revisiones, eventos, formatos), el sistema también lo desactiva en lugar de
   borrarlo.
5. Desde el listado se puede activar o desactivar un usuario.
6. Toda operación termina con un mensaje de éxito o error.

**Prioridad:** Alta · **Checkpoint:** CP1 · **Relacionado:** RF-20, RF-21, RF-24, RF-25, RF-28

---

## Checkpoint 2 — Coordinación y Estudiante

### HU-09 · Administrar ideas de anteproyecto

**Como** coordinador **quiero** registrar, editar, consultar y eliminar ideas de
anteproyecto **para** ofrecer opciones de trabajo de grado a los estudiantes.

**Criterios de aceptación**

1. El formulario pide título y descripción.
2. Las ideas se crean en estado DISPONIBLE.
3. No se puede eliminar una idea que tenga anteproyecto asociado.
4. El listado permite buscar por título.

**Prioridad:** Alta · **Checkpoint:** CP2 · **Relacionado:** RF-29

---

### HU-10 · Asignar director y evaluador

**Como** coordinador **quiero** asignar director y evaluador a un anteproyecto
**para** que el estudiante tenga quién lo oriente y quién lo evalúe.

**Criterios de aceptación**

1. Solo se pueden asignar usuarios con rol DIRECTOR o EVALUADOR.
2. Director y evaluador deben ser distintos.
3. La asignación queda registrada en el anteproyecto.

**Prioridad:** Alta · **Checkpoint:** CP2 · **Relacionado:** RF-30

---

### HU-11 · Buscar estudiante y ver su anteproyecto

**Como** coordinador **quiero** buscar un estudiante por código o nombre **para**
ver el estado de su anteproyecto.

**Criterios de aceptación**

1. La búsqueda acepta código o nombre.
2. Se muestra el anteproyecto activo del estudiante con su estado.
3. Si el estudiante no tiene anteproyecto, se informa.

**Prioridad:** Media · **Checkpoint:** CP2 · **Relacionado:** RF-31

---

### HU-12 · Informes de seguimiento

**Como** coordinador **quiero** informes del estado de los proyectos por alumno,
por director y por evaluador **para** hacer seguimiento y tomar decisiones.

**Criterios de aceptación**

1. Se puede filtrar el informe por alumno, por director y por evaluador.
2. El informe muestra el estado actual de cada anteproyecto.
3. El informe se puede consultar en pantalla.

**Prioridad:** Media · **Checkpoint:** CP2 · **Relacionado:** RF-32

---

### HU-13 · Seleccionar idea y subir mi anteproyecto

**Como** estudiante **quiero** seleccionar una idea disponible y registrar mi
anteproyecto **para** iniciar mi trabajo de grado.

**Criterios de aceptación**

1. Solo se muestran las ideas en estado DISPONIBLE.
2. Al seleccionar la idea pasa a TOMADA.
3. El estudiante solo puede tener un anteproyecto activo.
4. El anteproyecto nace en estado BORRADOR.
5. Puede editarse mientras esté en BORRADOR o CON_CORRECCIONES.

**Prioridad:** Alta · **Checkpoint:** CP2 · **Relacionado:** RF-35, RF-36, RF-37

---

### HU-14 · Entregar el documento

**Como** estudiante **quiero** subir el archivo de mi anteproyecto y entregarlo
**para** que el director lo revise.

**Criterios de aceptación**

1. Se aceptan únicamente archivos PDF o DOCX de hasta 10 MB.
2. El archivo se guarda fuera del webapp con un nombre generado (UUID).
3. Al entregar, el anteproyecto pasa a ENTREGADO.
4. Se muestra la información del director y del evaluador asignados.

**Prioridad:** Alta · **Checkpoint:** CP2 · **Relacionado:** RF-38, RF-39

---

### HU-15 · Ver mi calificación

**Como** estudiante **quiero** ver la calificación y las observaciones de mi
anteproyecto **para** saber si debo corregirlo.

**Criterios de aceptación**

1. Se muestran las revisiones del director y del evaluador.
2. Se muestra la nota, las observaciones y la decisión.
3. El estudiante solo ve su propio anteproyecto.

**Prioridad:** Media · **Checkpoint:** CP2 · **Relacionado:** RF-40

---

### HU-16 · Consultar calendario y formatos

**Como** usuario autenticado **quiero** consultar el calendario académico y los
formatos de grado **para** cumplir las fechas y usar los documentos oficiales.

**Criterios de aceptación**

1. `/calendario` muestra los eventos ordenados por fecha.
2. `/formatos` lista los formatos con su enlace o descarga.
3. Las dos rutas son accesibles para cualquier rol autenticado.

**Prioridad:** Media · **Checkpoint:** CP2 · **Relacionado:** RF-33, RF-34, RF-41, RF-46, RF-49

---

## Checkpoint 3 — Director y Evaluador

### HU-17 · Calificar anteproyectos (Director)

**Como** director **quiero** calificar los anteproyectos de mis estudiantes
**para** aprobarlos, devolverlos con correcciones o rechazarlos.

**Criterios de aceptación**

1. Solo veo los anteproyectos donde soy director.
2. Puedo registrar nota (0.0–5.0), observaciones y decisión.
3. Con APROBADO el anteproyecto pasa a APROBADO_DIRECTOR.
4. Con CON_CORRECCIONES vuelve al estudiante.
5. Con RECHAZADO queda en RECHAZADO.
6. No puedo calificar un anteproyecto que no esté ENTREGADO.

**Prioridad:** Alta · **Checkpoint:** CP3 · **Relacionado:** RF-42, RF-44, RF-45

---

### HU-18 · Ver información del estudiante (Director)

**Como** director **quiero** ver la información de mi estudiante **para**
conocer sus datos de contacto y su avance.

**Criterios de aceptación**

1. Desde el anteproyecto puedo ver nombres, apellidos, código y correo.
2. Solo veo la información de mis propios estudiantes.

**Prioridad:** Baja · **Checkpoint:** CP3 · **Relacionado:** RF-43

---

### HU-19 · Evaluar anteproyectos (Evaluador)

**Como** evaluador **quiero** evaluar los anteproyectos que el director aprobó
**para** dar el visto bueno final.

**Criterios de aceptación**

1. Solo veo anteproyectos en estado APROBADO_DIRECTOR donde soy evaluador.
2. Puedo registrar nota, observaciones y decisión.
3. Con APROBADO el anteproyecto pasa a APROBADO_EVALUADOR (visible para el
   estudiante y la coordinación).
4. Con CON_CORRECCIONES o RECHAZADO se registra la decisión.
5. No puedo evaluar anteproyectos en otro estado.

**Prioridad:** Alta · **Checkpoint:** CP3 · **Relacionado:** RF-47, RF-48, RF-50
