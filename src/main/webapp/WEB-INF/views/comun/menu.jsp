<%--
    Menú lateral. Cambia según el rol (JSTL c:if sobre sessionScope.usuario.nombreRol).
    Los módulos de checkpoints posteriores se listan como "próximamente" y no enlazan.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<aside class="menu">
    <div class="menu__marca">
        <strong>Trabajos de Grado</strong>
        <span>Unidades Tecnológicas de Santander</span>
    </div>

    <nav>
        <div class="menu__grupo">General</div>
        <a href="${pageContext.request.contextPath}/inicio"
           class="${pageContext.request.servletPath eq '/inicio' or pageContext.request.servletPath eq '/admin/inicio'
                     or pageContext.request.servletPath eq '/coordinacion/inicio' or pageContext.request.servletPath eq '/director/inicio'
                     or pageContext.request.servletPath eq '/evaluador/inicio' or pageContext.request.servletPath eq '/estudiante/inicio'
                     ? 'activo' : ''}">Inicio</a>

        <c:if test="${sessionScope.usuario.nombreRol == 'ADMIN'}">
            <div class="menu__grupo">Administración</div>
            <a href="${pageContext.request.contextPath}/admin/usuarios"
               class="${pageContext.request.servletPath eq '/admin/usuarios' ? 'activo' : ''}">Gestión de usuarios</a>
            <span class="menu__grupo">Reportes globales: próximamente</span>
        </c:if>

        <c:if test="${sessionScope.usuario.nombreRol == 'COORDINACION'}">
            <div class="menu__grupo">Coordinación</div>
            <span class="menu__grupo">Ideas de anteproyecto: próximamente</span>
            <span class="menu__grupo">Asignar director/evaluador: próximamente</span>
            <span class="menu__grupo">Buscar estudiante: próximamente</span>
            <span class="menu__grupo">Informes: próximamente</span>
        </c:if>

        <c:if test="${sessionScope.usuario.nombreRol == 'DIRECTOR'}">
            <div class="menu__grupo">Director</div>
            <span class="menu__grupo">Calificar anteproyectos: próximamente</span>
            <span class="menu__grupo">Mis estudiantes: próximamente</span>
        </c:if>

        <c:if test="${sessionScope.usuario.nombreRol == 'EVALUADOR'}">
            <div class="menu__grupo">Evaluador</div>
            <span class="menu__grupo">Anteproyectos aprobados: próximamente</span>
        </c:if>

        <c:if test="${sessionScope.usuario.nombreRol == 'ESTUDIANTE'}">
            <div class="menu__grupo">Estudiante</div>
            <span class="menu__grupo">Seleccionar idea: próximamente</span>
            <span class="menu__grupo">Mi anteproyecto: próximamente</span>
            <span class="menu__grupo">Mi calificación: próximamente</span>
        </c:if>

        <div class="menu__grupo">Compartido</div>
        <span class="menu__grupo">Calendario académico: próximamente</span>
        <span class="menu__grupo">Formatos de grado: próximamente</span>
    </nav>

    <div class="menu__pie">
        <c:if test="${not empty sessionScope.usuario}">
            <p class="usuario"><c:out value="${sessionScope.usuario.nombreCompleto}" /></p>
            <p class="rol"><c:out value="${sessionScope.usuario.codigo}" /> &middot; <c:out value="${sessionScope.usuario.nombreRol}" /></p>
            <a class="menu__salir" href="${pageContext.request.contextPath}/logout">Cerrar sesión</a>
        </c:if>
        <c:if test="${empty sessionScope.usuario}">
            <a class="menu__salir" href="${pageContext.request.contextPath}/login">Iniciar sesión</a>
        </c:if>
    </div>
</aside>
