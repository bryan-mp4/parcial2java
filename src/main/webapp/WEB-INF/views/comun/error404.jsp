<%--
    Página de error 404 (recurso no encontrado). Se muestra vía <error-page>.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Página no encontrada" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Página no encontrada</span>
        <span class="barra__ruta">Error 404</span>
    </div>

    <div class="principal">
        <div class="formulario">
            <h1>La página que buscas no existe</h1>
            <p>
                La dirección no corresponde a ningún módulo del sistema
                o el contenido fue movido.
            </p>
            <p>
                <strong>Ruta intentada:</strong>
                <c:out value="${requestScope['javax.servlet.error.request_uri']}" default="(no disponible)" />
            </p>
            <p>
                <a class="btn btn--primario" href="${pageContext.request.contextPath}/inicio">Ir a mi inicio</a>
                <a class="btn btn--secundario" href="${pageContext.request.contextPath}/login">Ir al login</a>
            </p>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
