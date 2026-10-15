<%--
    Formulario para crear o editar un usuario.
    La contraseña es obligatoria al crear y opcional al editar.
    No se muestra nunca el hash ni se rellena la contraseña.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="${usuario.id > 0 ? 'Editar usuario' : 'Nuevo usuario'}" />
<c:set var="editando" value="${usuario.id > 0}" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo"><c:out value="${editando ? 'Editar usuario' : 'Nuevo usuario'}" /></span>
        <span class="barra__ruta">Administrador</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1><c:out value="${editando ? 'Editar usuario' : 'Registrar usuario'}" /></h1>
                <c:if test="${editando}">
                    <p>Los campos código y correo deben seguir siendo únicos.</p>
                </c:if>
            </div>
            <a class="btn btn--secundario" href="${pageContext.request.contextPath}/admin/usuarios">Volver al listado</a>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <form class="formulario" method="post" action="${pageContext.request.contextPath}/admin/usuarios">
            <input type="hidden" name="accion" value="${editando ? 'actualizar' : 'guardar'}">
            <c:if test="${editando}">
                <input type="hidden" name="id" value="${usuario.id}">
            </c:if>

            <div class="campos">
                <div class="campo">
                    <label for="codigo">Código *</label>
                    <input type="text" id="codigo" name="codigo" required maxlength="20"
                           value="<c:out value="${usuario.codigo}" />">
                    <small>Entre 4 y 20 caracteres. Único en el sistema.</small>
                </div>

                <div class="campo">
                    <label for="correo">Correo institucional *</label>
                    <input type="email" id="correo" name="correo" required maxlength="120"
                           value="<c:out value="${usuario.correo}" />">
                    <small>Único en el sistema. Se usa para iniciar sesión.</small>
                </div>

                <div class="campo">
                    <label for="nombres">Nombres *</label>
                    <input type="text" id="nombres" name="nombres" required maxlength="60"
                           value="<c:out value="${usuario.nombres}" />">
                </div>

                <div class="campo">
                    <label for="apellidos">Apellidos *</label>
                    <input type="text" id="apellidos" name="apellidos" required maxlength="60"
                           value="<c:out value="${usuario.apellidos}" />">
                </div>

                <div class="campo">
                    <label for="rolId">Rol *</label>
                    <select id="rolId" name="rolId" required>
                        <option value="">Seleccione un rol</option>
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.id}" ${usuario.rolId eq r.id ? 'selected' : ''}>
                                <c:out value="${r.nombre}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="campo">
                    <label for="clave">
                        <c:out value="${editando ? 'Nueva contraseña (opcional)' : 'Contraseña *'}" />
                    </label>
                    <input type="password" id="clave" name="clave"
                           maxlength="72" ${editando ? '' : 'required'}
                           autocomplete="new-password">
                    <small>Mínimo 8 caracteres. Se guarda cifrada con PBKDF2.</small>
                </div>

                <div class="campo campo--check">
                    <input type="checkbox" id="activo" name="activo"
                           ${usuario.activo || usuario.id == 0 ? 'checked' : ''}>
                    <label for="activo">Usuario activo (puede iniciar sesión)</label>
                </div>
            </div>

            <div class="formulario__pie">
                <button class="btn btn--primario" type="submit">
                    <c:out value="${editando ? 'Guardar cambios' : 'Crear usuario'}" />
                </button>
                <a class="btn btn--secundario" href="${pageContext.request.contextPath}/admin/usuarios">Cancelar</a>
            </div>
        </form>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
