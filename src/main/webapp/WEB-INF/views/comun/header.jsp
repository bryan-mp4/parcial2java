<%--
    Vistas comunes: cabecera HTML, menú según rol y pie.
    Se incluyen desde cada JSP con <jsp:include page="/WEB-INF/views/comun/header.jsp" />
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${titulo}" default="Trabajos de grado" /> &middot; Sistema de Trabajos de Grado UTS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/estilos.css">
</head>
<body>
<div class="app">
