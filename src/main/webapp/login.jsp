<%--
    Página pública de inicio de sesión (accesible sin autenticación).
    Acceso: /TrabajosGrado/login
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar sesión &middot; Sistema de Trabajos de Grado UTS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/estilos.css">
</head>
<body>

<main class="login">
    <div class="login__tarjeta">
        <div class="login__cabeza">
            <strong>Trabajos de Grado &middot; UTS</strong>
            <span>Sistema de gestión y seguimiento</span>
        </div>

        <div class="login__cuerpo">
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

            <h1>Iniciar sesión</h1>
            <p class="encabezado-pagina">
                Ingresa con el correo y la contraseña asignados por la coordinación.
            </p>

            <form method="post" action="${pageContext.request.contextPath}/login">
                <div class="campo" style="margin-bottom: 12px;">
                    <label for="correo">Correo institucional</label>
                    <input type="email" id="correo" name="correo" required maxlength="120"
                           placeholder="admin@uts.edu.co" autocomplete="username" autofocus>
                </div>

                <div class="campo" style="margin-bottom: 16px;">
                    <label for="clave">Contraseña</label>
                    <input type="password" id="clave" name="clave" required maxlength="72"
                           placeholder="Mínimo 8 caracteres" autocomplete="current-password">
                </div>

                <button class="btn btn--primario" type="submit" style="width: 100%;">Entrar</button>
            </form>

            <p class="login__ayuda">
                ¿Problemas para entrar? Contacta al administrador del sistema.
            </p>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
