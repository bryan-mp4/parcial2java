package edu.uts.grados.filter;

import edu.uts.grados.model.Usuario;
import edu.uts.grados.util.Roles;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * RolFilter: revisa que el rol de la sesión corresponda al prefijo de la URL.
 *
 * <p>Cada rol tiene su propio espacio de URLs: {@code /admin/*},
 * {@code /coordinacion/*}, {@code /director/*}, {@code /evaluador/*} y
 * {@code /estudiante/*}. Las rutas compartidas ({@code /inicio},
 * {@code /calendario/*}, {@code /formatos/*}) las permite cualquier usuario
 * autenticado. Si el rol no corresponde responde 403 (la página de error se
 * declara en web.xml).</p>
 */
public class RolFilter implements Filter {

    @Override
    public void init(FilterConfig config) {
        // La correspondencia rol <-> prefijo vive en util.Roles.
    }

    @Override
    public void doFilter(ServletRequest sreq, ServletResponse sres, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) sreq;
        HttpServletResponse res = (HttpServletResponse) sres;

        String ruta = rutaRelativa(req);
        String rolRequerido = rolRequerido(ruta);

        Usuario usuario = (Usuario) req.getSession(false).getAttribute("usuario");
        String rol = usuario == null ? null : usuario.getNombreRol();

        if (rolRequerido != null && !rolRequerido.equalsIgnoreCase(rol)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(sreq, sres);
    }

    /** Quita el context path de la URI: /TrabajosGrado/admin/usuarios -> /admin/usuarios. */
    private String rutaRelativa(HttpServletRequest req) {
        String uri = req.getRequestURI();
        String ctx = req.getContextPath();
        String ruta = uri.startsWith(ctx) ? uri.substring(ctx.length()) : uri;
        return ruta.isEmpty() ? "/" : ruta;
    }

    /** Rol necesario para la ruta, o null si es una ruta compartida/pública. */
    private String rolRequerido(String ruta) {
        if (Roles.esRutaCompartida(ruta)) {
            return null;
        }
        for (String rol : new String[]{Roles.ADMIN, Roles.COORDINACION, Roles.DIRECTOR,
                Roles.EVALUADOR, Roles.ESTUDIANTE}) {
            String prefijo = Roles.prefijo(rol);
            if (ruta.equals(prefijo) || ruta.startsWith(prefijo + "/")) {
                return rol;
            }
        }
        return null;
    }

    @Override
    public void destroy() {
        // Nada que liberar.
    }
}
