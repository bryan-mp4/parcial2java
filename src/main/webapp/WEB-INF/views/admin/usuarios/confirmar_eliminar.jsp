<%--
    Confirmación para eliminar un usuario.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Eliminar usuario" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Eliminar usuario</span>
        <span class="barra__ruta">Administrador</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1>¿Eliminar a <c:out value="${usuario.nombreCompleto}" />?</h1>
                <p>Esta acción no se puede deshacer.</p>
            </div>
            <a class="btn btn--secundario" href="${pageContext.request.contextPath}/admin/usuarios">Volver al listado</a>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="formulario">
            <div class="tabla-envoltura">
                <table class="tabla">
                    <caption>Usuario que se va a eliminar</caption>
                    <tbody>
                        <tr>
                            <th scope="row" style="width: 200px;">Código</th>
                            <td><c:out value="${usuario.codigo}" /></td>
                        </tr>
                        <tr>
                            <th scope="row">Nombre</th>
                            <td><c:out value="${usuario.nombreCompleto}" /></td>
                        </tr>
                        <tr>
                            <th scope="row">Correo</th>
                            <td><c:out value="${usuario.correo}" /></td>
                        </tr>
                        <tr>
                            <th scope="row">Rol</th>
                            <td><c:out value="${usuario.nombreRol}" /></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <c:choose>
                <c:when test="${anteproyectos > 0}">
                    <div class="alerta alerta--aviso" style="margin-top: 16px;">
                        <span aria-hidden="true">&#9888;</span>
                        <span>
                            Este usuario tiene <strong><c:out value="${anteproyectos}" /></strong> anteproyecto(s)
                            asociado(s). No se puede eliminar: el sistema hará una
                            <strong>baja lógica</strong> (quedará con el estado "Inactivo") y conservará
                            el historial.
                        </span>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alerta alerta--aviso" style="margin-top: 16px;">
                        <span aria-hidden="true">&#9888;</span>
                        <span>
                            El usuario no tiene anteproyectos asociados, por lo que se eliminará
                            definitivamente de la base de datos. Si tiene información relacionada
                            (ideas, revisiones, eventos o formatos), el sistema lo desactivará
                            en lugar de borrarlo.
                        </span>
                    </div>
                </c:otherwise>
            </c:choose>

            <form method="post" action="${pageContext.request.contextPath}/admin/usuarios"
                  data-confirmar="¿Confirmas la eliminación de este usuario?">
                <input type="hidden" name="accion" value="eliminar">
                <input type="hidden" name="id" value="${usuario.id}">
                <div class="formulario__pie">
                    <button class="btn btn--peligro" type="submit">Sí, eliminar</button>
                    <a class="btn btn--secundario" href="${pageContext.request.contextPath}/admin/usuarios">Cancelar</a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
