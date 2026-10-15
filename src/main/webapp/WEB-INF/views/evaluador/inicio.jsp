<%--
    Página de inicio del Evaluador.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Inicio · Evaluador" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Panel del evaluador</span>
        <span class="barra__ruta">Evaluador</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1>Hola, <c:out value="${sessionScope.usuario.nombres}" /></h1>
                <p>Evalúa los anteproyectos que el director aprobó.</p>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="grilla">
            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Anteproyectos aprobados por el director</h2>
                <p class="tarjeta__texto">
                    Lista de los anteproyectos que ya cuentan con la aprobación del director.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Registrar evaluación</h2>
                <p class="tarjeta__texto">
                    Nota, observaciones y decisión (aprobado, con correcciones o rechazado).
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Calendario académico</h2>
                <p class="tarjeta__texto">Fechas de evaluación y sustentación.</p>
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
