<%--
    Detalle de un usuario (solo lectura).
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="titulo" value="Detalle del usuario" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Detalle del usuario</span>
        <span class="barra__ruta">Administrador</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1><c:out value="${usuario.nombreCompleto}" /></h1>
                <p><c:out value="${usuario.correo}" /></p>
            </div>
            <a class="btn btn--secundario" href="${pageContext.request.contextPath}/admin/usuarios">Volver al listado</a>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="tabla-envoltura">
            <table class="tabla">
                <caption>Información registrada del usuario. La contraseña no se muestra
                         porque se almacena cifrada.</caption>
                <tbody>
                    <tr>
                        <th scope="row" style="width: 200px;">Código</th>
                        <td><c:out value="${usuario.codigo}" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Nombres</th>
                        <td><c:out value="${usuario.nombres}" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Apellidos</th>
                        <td><c:out value="${usuario.apellidos}" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Correo</th>
                        <td><c:out value="${usuario.correo}" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Rol</th>
                        <td><c:out value="${usuario.nombreRol}" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Estado</th>
                        <td>
                            <c:choose>
                                <c:when test="${usuario.activo}">
                                    <span class="etiqueta etiqueta--activo">Activo</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="etiqueta etiqueta--inactivo">Inactivo</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Registrado el</th>
                        <td>
                            <fmt:formatDate value="${usuario.creadoEn}" pattern="dd/MM/yyyy HH:mm" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="formulario__pie">
            <a class="btn btn--primario"
               href="${pageContext.request.contextPath}/admin/usuarios?accion=editar&amp;id=${usuario.id}">Editar</a>
            <a class="btn btn--peligro"
               href="${pageContext.request.contextPath}/admin/usuarios?accion=confirmarEliminar&amp;id=${usuario.id}">Eliminar</a>
            <a class="btn btn--secundario" href="${pageContext.request.contextPath}/admin/usuarios">Volver</a>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
