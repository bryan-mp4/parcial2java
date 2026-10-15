<%--
    Lista de usuarios: búsqueda por nombre/código/correo, filtro por rol y paginación.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Usuarios" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Gestión de usuarios</span>
        <span class="barra__ruta">Administrador</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1>Usuarios registrados</h1>
                <p>
                    Total de registros: <strong><c:out value="${totalRegistros}" /></strong>
                    &middot; página <c:out value="${pagina}" /> de <c:out value="${paginas}" />
                </p>
            </div>
            <a class="btn btn--primario" href="${pageContext.request.contextPath}/admin/usuarios?accion=nuevo">
                Nuevo usuario
            </a>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <%-- Búsqueda y filtro por rol (GET: la consulta es compartible por URL) --%>
        <form class="filtros" method="get" action="${pageContext.request.contextPath}/admin/usuarios">
            <input type="hidden" name="accion" value="listar">
            <div class="campo" style="min-width: 240px;">
                <label for="buscar">Buscar</label>
                <input type="text" id="buscar" name="buscar" value="<c:out value="${buscar}" />"
                       maxlength="100" placeholder="Nombre, código o correo">
            </div>
            <div class="campo">
                <label for="rol">Rol</label>
                <select id="rol" name="rol">
                    <option value="0">Todos los roles</option>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.id}" ${rolId eq r.id ? 'selected' : ''}>
                            <c:out value="${r.nombre}" />
                        </option>
                    </c:forEach>
                </select>
            </div>
            <button class="btn btn--primario" type="submit">Buscar</button>
            <a class="btn btn--secundario" href="${pageContext.request.contextPath}/admin/usuarios">Limpiar</a>
        </form>

        <div class="tabla-envoltura">
            <table class="tabla">
                <caption>Listado de usuarios del sistema de trabajos de grado.</caption>
                <thead>
                    <tr>
                        <th scope="col">Código</th>
                        <th scope="col">Nombre</th>
                        <th scope="col">Correo</th>
                        <th scope="col">Rol</th>
                        <th scope="col">Estado</th>
                        <th scope="col">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty usuarios}">
                            <tr>
                                <td colspan="6" class="vacio">
                                    No se encontraron usuarios con esos filtros.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${usuarios}">
                                <tr>
                                    <td><c:out value="${u.codigo}" /></td>
                                    <td><c:out value="${u.nombreCompleto}" /></td>
                                    <td><c:out value="${u.correo}" /></td>
                                    <td><c:out value="${u.nombreRol}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.activo}">
                                                <span class="etiqueta etiqueta--activo">Activo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="etiqueta etiqueta--inactivo">Inactivo</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="acciones">
                                        <a class="btn btn--secundario btn--chico"
                                           href="${pageContext.request.contextPath}/admin/usuarios?accion=ver&amp;id=${u.id}">
                                            Ver
                                        </a>
                                        <a class="btn btn--secundario btn--chico"
                                           href="${pageContext.request.contextPath}/admin/usuarios?accion=editar&amp;id=${u.id}">
                                            Editar
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/usuarios"
                                              data-confirmar="${u.activo ? '¿Desactivar este usuario?' : '¿Activar este usuario?'}">
                                            <input type="hidden" name="id" value="${u.id}">
                                            <input type="hidden" name="accion"
                                                   value="${u.activo ? 'desactivar' : 'activar'}">
                                            <button class="btn btn--secundario btn--chico" type="submit">
                                                <c:out value="${u.activo ? 'Desactivar' : 'Activar'}" />
                                            </button>
                                        </form>
                                        <a class="btn btn--peligro btn--chico"
                                           href="${pageContext.request.contextPath}/admin/usuarios?accion=confirmarEliminar&amp;id=${u.id}">
                                            Eliminar
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- Paginación --%>
        <nav class="paginacion" aria-label="Paginación de usuarios">
            <c:if test="${pagina > 1}">
                <c:url var="urlAnterior" value="/admin/usuarios">
                    <c:param name="buscar" value="${buscar}" />
                    <c:param name="rol" value="${rolId}" />
                    <c:param name="pagina" value="${pagina - 1}" />
                </c:url>
                <a href="${urlAnterior}">&laquo; Anterior</a>
            </c:if>

            <c:forEach var="numero" begin="1" end="${paginas}">
                <c:url var="urlPagina" value="/admin/usuarios">
                    <c:param name="buscar" value="${buscar}" />
                    <c:param name="rol" value="${rolId}" />
                    <c:param name="pagina" value="${numero}" />
                </c:url>
                <c:choose>
                    <c:when test="${numero eq pagina}">
                        <span class="actual"><c:out value="${numero}" /></span>
                    </c:when>
                    <c:otherwise>
                        <a href="${urlPagina}"><c:out value="${numero}" /></a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${pagina < paginas}">
                <c:url var="urlSiguiente" value="/admin/usuarios">
                    <c:param name="buscar" value="${buscar}" />
                    <c:param name="rol" value="${rolId}" />
                    <c:param name="pagina" value="${pagina + 1}" />
                </c:url>
                <a href="${urlSiguiente}">Siguiente &raquo;</a>
            </c:if>

            <span class="info">Se muestran 8 registros por página.</span>
        </nav>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
