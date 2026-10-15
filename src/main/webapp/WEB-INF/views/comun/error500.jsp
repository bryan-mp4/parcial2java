<%--
    Página de error 500 (error interno del servidor). No muestra detalles
    técnicos al usuario; la traza queda en el log de Tomcat.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Error del servidor" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Error del servidor</span>
        <span class="barra__ruta">Error 500</span>
    </div>

    <div class="principal">
        <div class="formulario">
            <h1>Ocurrió un error inesperado</h1>
            <p>
                No se pudo completar la operación. El detalle quedó registrado en el
                log del servidor. Si el problema continúa, avisa al administrador.
            </p>
            <p>
                <a class="btn btn--primario" href="${pageContext.request.contextPath}/inicio">Volver a mi inicio</a>
                <a class="btn btn--secundario" href="javascript:history.back()">Regresar</a>
            </p>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
