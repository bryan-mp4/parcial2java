<%--
    Página de inicio de Coordinación.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Inicio · Coordinación" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Panel de coordinación</span>
        <span class="barra__ruta">Coordinación</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1>Hola, <c:out value="${sessionScope.usuario.nombres}" /></h1>
                <p>Gestiona las ideas de anteproyecto y el avance de los estudiantes.</p>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="grilla">
            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Ideas de anteproyecto</h2>
                <p class="tarjeta__texto">
                    Crear, editar, consultar y eliminar las ideas disponibles para los estudiantes.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Asignar director y evaluador</h2>
                <p class="tarjeta__texto">
                    Elegir director y evaluador distintos para cada anteproyecto entregado.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Buscar estudiante</h2>
                <p class="tarjeta__texto">
                    Buscar por código o nombre para ver el anteproyecto de un estudiante.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Informes</h2>
                <p class="tarjeta__texto">
                    Estado de los proyectos por alumno, por director y por evaluador.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Calendario académico</h2>
                <p class="tarjeta__texto">Fechas de entrega, sustentaciones y correcciones.</p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Formatos de grado</h2>
                <p class="tarjeta__texto">Documentos oficiales y enlaces de descarga.</p>
            </article>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
