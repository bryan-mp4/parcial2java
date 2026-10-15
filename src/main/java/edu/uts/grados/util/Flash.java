package edu.uts.grados.util;

import javax.servlet.http.HttpServletRequest;

/**
 * Mensajes "flash": se guardan en sesión y se leen una sola vez por la vista
 * (patrón POST-Redirect-GET).
 */
public final class Flash {

    public static final String EXITO = "flashExito";
    public static final String ERROR = "flashError";

    private Flash() {
    }

    public static void exito(HttpServletRequest req, String mensaje) {
        req.getSession().setAttribute(EXITO, mensaje);
    }

    public static void error(HttpServletRequest req, String mensaje) {
        req.getSession().setAttribute(ERROR, mensaje);
    }

    /** Descarta los mensajes pendientes (por ejemplo tras iniciar sesión). */
    public static void limpiar(HttpServletRequest req) {
        req.getSession().removeAttribute(EXITO);
        req.getSession().removeAttribute(ERROR);
    }
}
