<%--
    Página de inicio del Administrador.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="titulo" value="Inicio · Administrador" />

<jsp:include page="/WEB-INF/views/comun/header.jsp" />
<jsp:include page="/WEB-INF/views/comun/menu.jsp" />

<div class="contenido">
    <div class="barra">
        <span class="barra__titulo">Panel de administración</span>
        <span class="barra__ruta">Administrador</span>
    </div>

    <div class="principal">
        <div class="encabezado-pagina">
            <div>
                <h1>Hola, <c:out value="${sessionScope.usuario.nombres}" /></h1>
                <p>Desde aquí administras los usuarios del sistema de trabajos de grado.</p>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/comun/mensajes.jsp" />

        <div class="grilla">
            <article class="tarjeta">
                <span class="chip">Disponible</span>
                <h2 class="tarjeta__titulo">Gestión de usuarios</h2>
                <p class="tarjeta__texto">
                    Registrar, consultar, editar y desactivar usuarios (administradores,
                    coordinación, directores, evaluadores y estudiantes).
                </p>
                <a class="btn btn--primario" href="${pageContext.request.contextPath}/admin/usuarios">
                    Ir a usuarios
                </a>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Reportes globales</h2>
                <p class="tarjeta__texto">
                    Indicadores generales de anteproyectos, directores y evaluadores.
                </p>
            </article>

            <article class="tarjeta tarjeta--proximamente">
                <span class="chip chip--apagado">Próximamente</span>
                <h2 class="tarjeta__titulo">Parámetros del sistema</h2>
                <p class="tarjeta__texto">
                    Fechas de convocatoria, estados permitidos y mensajes institucionales.
                </p>
            </article>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/comun/footer.jsp" />
</div>
