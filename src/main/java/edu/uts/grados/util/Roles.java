package edu.uts.grados.util;

import java.util.HashMap;
import java.util.Map;

/**
 * Nombres de roles, prefijos de URL y página de inicio de cada rol.
 * Centraliza la correspondencia rol <-> ruta para no repetirla en filtros y servlets.
 */
public final class Roles {

    public static final String ADMIN = "ADMIN";
    public static final String COORDINACION = "COORDINACION";
    public static final String DIRECTOR = "DIRECTOR";
    public static final String EVALUADOR = "EVALUADOR";
    public static final String ESTUDIANTE = "ESTUDIANTE";

    /** Rutas compartidas por todos los roles autenticados. */
    public static final String[] RUTAS_COMPARTIDAS = {"/inicio", "/calendario", "/formatos"};

    private static final Map<String, String> VISTA_INICIO = new HashMap<>();
    private static final Map<String, String> PREFIJO = new HashMap<>();

    static {
        VISTA_INICIO.put(ADMIN, "/WEB-INF/views/admin/inicio.jsp");
        VISTA_INICIO.put(COORDINACION, "/WEB-INF/views/coordinacion/inicio.jsp");
        VISTA_INICIO.put(DIRECTOR, "/WEB-INF/views/director/inicio.jsp");
        VISTA_INICIO.put(EVALUADOR, "/WEB-INF/views/evaluador/inicio.jsp");
        VISTA_INICIO.put(ESTUDIANTE, "/WEB-INF/views/estudiante/inicio.jsp");

        PREFIJO.put(ADMIN, "/admin");
        PREFIJO.put(COORDINACION, "/coordinacion");
        PREFIJO.put(DIRECTOR, "/director");
        PREFIJO.put(EVALUADOR, "/evaluador");
        PREFIJO.put(ESTUDIANTE, "/estudiante");
    }

    private Roles() {
    }

    /** Ruta (pattern) a la que se redirige tras iniciar sesión. */
    public static String rutaInicio(String rol) {
        String ruta = PREFIJO.get(rol == null ? "" : rol.toUpperCase());
        return ruta == null ? "/inicio" : ruta + "/inicio";
    }

    /** JSP de inicio dentro de WEB-INF/views según el rol. */
    public static String vistaInicio(String rol) {
        String vista = VISTA_INICIO.get(rol == null ? "" : rol.toUpperCase());
        return vista == null ? "/WEB-INF/views/comun/sin_acceso.jsp" : vista;
    }

    /** Prefijo de URL propio del rol (para el menú activo). */
    public static String prefijo(String rol) {
        return PREFIJO.get(rol == null ? "" : rol.toUpperCase());
    }

    /** true si la ruta no es exclusiva de un rol (cualquier usuario autenticado). */
    public static boolean esRutaCompartida(String ruta) {
        if (ruta == null) {
            return false;
        }
        for (String compartida : RUTAS_COMPARTIDAS) {
            if (ruta.equals(compartida) || ruta.startsWith(compartida + "/")) {
                return true;
            }
        }
        return false;
    }

    /** Nombre legible del rol para las vistas. */
    public static String etiqueta(String rol) {
        if (rol == null) {
            return "";
        }
        switch (rol.toUpperCase()) {
            case ADMIN: return "Administrador";
            case COORDINACION: return "Coordinación";
            case DIRECTOR: return "Director";
            case EVALUADOR: return "Evaluador";
            case ESTUDIANTE: return "Estudiante";
            default: return rol;
        }
    }
}
