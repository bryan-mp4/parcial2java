<%--
    Mensajes "flash" (éxito/error) y lista de errores de validación.
    Los mensajes en sesión se eliminan después de mostrarlos (una sola vez).
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty flashExito}">
    <div class="alerta alerta--exito" role="status">
        <span aria-hidden="true">&#10003;</span>
        <span><c:out value="${flashExito}" /></span>
    </div>
    <c:remove var="flashExito" scope="session" />
</c:if>

<c:if test="${not empty flashError}">
    <div class="alerta alerta--error" role="alert">
        <span aria-hidden="true">&#9888;</span>
        <span><c:out value="${flashError}" /></span>
    </div>
    <c:remove var="flashError" scope="session" />
</c:if>

<c:if test="${not empty errores}">
    <div class="alerta alerta--error" role="alert">
        <span aria-hidden="true">&#9888;</span>
        <div>
            <strong>Revisa los siguientes datos:</strong>
            <ul>
                <c:forEach var="falla" items="${errores}">
                    <li><c:out value="${falla}" /></li>
                </c:forEach>
            </ul>
        </div>
    </div>
</c:if>
