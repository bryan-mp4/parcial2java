<%--
    Página de inicio del Director.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Inicio · Director" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Panel del director</span>
        <span class="barra__ruta">Director</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1>Hola, <c:out value="${sessionScope.usuario.nombres}" /></h1>
                <p>Revisa y califica los anteproyectos de los estudiantes que diriges.</p>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="grilla">
            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Calificar anteproyectos</h2>
                <p class="tarjeta__texto">
                    Registrar nota, observaciones y decisión sobre los anteproyectos
                    entregados por tus estudiantes.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Mis estudiantes</h2>
                <p class="tarjeta__texto">
                    Consultar la información y el estado del anteproyecto de cada estudiante.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Aprobar para el evaluador</h2>
                <p class="tarjeta__texto">
                    Enviar al evaluador los anteproyectos que apruebes como director.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Calendario académico</h2>
                <p class="tarjeta__texto">Fechas de revisión y sustentación.</p>
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
