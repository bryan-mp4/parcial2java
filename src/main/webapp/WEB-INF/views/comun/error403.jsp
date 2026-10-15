<%--
    Página de error 403 (acceso denegado). La muestra el contenedor vía
    <error-page> en web.xml. Sin scriptlets: solo JSTL y atributos de error.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Acceso denegado" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Acceso denegado</span>
        <span class="barra__ruta">Error 403</span>
    </div>

    <div class="principal">
        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="formulario">
            <h1>No tienes permiso para ver esta página</h1>
            <p>
                Tu rol no permite acceder a esta sección. Si necesitas el acceso,
                solicítalo al administrador del sistema.
            </p>
            <p>
                <strong>Ruta intentada:</strong>
                <c:out value="${requestScope['javax.servlet.error.request_uri']}" default="(no disponible)" />
            </p>
            <p>
                <a class="btn btn--primario" href="${pageContext.request.contextPath}/inicio">Volver a mi inicio</a>
                <a class="btn btn--secundario" href="${pageContext.request.contextPath}/logout">Cerrar sesión</a>
            </p>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
