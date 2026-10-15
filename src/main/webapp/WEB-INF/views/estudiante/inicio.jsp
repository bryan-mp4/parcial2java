<%--
    Página de inicio del Estudiante.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Inicio · Estudiante" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Panel del estudiante</span>
        <span class="barra__ruta">Estudiante</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1>Hola, <c:out value="${sessionScope.usuario.nombres}" /></h1>
                <p>Gestiona tu idea de grado y sube tu anteproyecto.</p>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="grilla">
            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Seleccionar idea de proyecto</h2>
                <p class="tarjeta__texto">
                    Elegir una de las ideas publicadas por la coordinación.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Mi anteproyecto</h2>
                <p class="tarjeta__texto">
                    Crear, editar y entregar el documento; ver la información del
                    director y del evaluador asignados.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Mi calificación</h2>
                <p class="tarjeta__texto">
                    Consultar las notas y observaciones del director y del evaluador.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Calendario académico</h2>
                <p class="tarjeta__texto">Fechas de entrega y sustentación.</p>
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
