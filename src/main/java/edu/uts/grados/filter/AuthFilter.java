package edu.uts.grados.filter;

import edu.uts.grados.model.Usuario;
import edu.uts.grados.util.Flash;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * AuthFilter: garantiza que toda ruta privada tenga sesión iniciada.
 *
 * <p>Las rutas públicas son {@code /login}, {@code /assets/*} y las páginas de
 * error; el resto se declara en web.xml con los patrones
 * {@code /admin/*}, {@code /coordinacion/*}, {@code /director/*},
 * {@code /evaluador/*}, {@code /estudiante/*}, {@code /inicio},
 * {@code /calendario/*} y {@code /formatos/*}.</p>
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig config) {
        // Sin configuración: los patrones vienen en web.xml.
    }

    @Override
    public void doFilter(ServletRequest sreq, ServletResponse sres, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) sreq;
        HttpServletResponse res = (HttpServletResponse) sres;

        // Las páginas de error se atienden sin sesión (403, 404, 500).
        if (esPaginaDeError(req)) {
            chain.doFilter(sreq, sres);
            return;
        }

        HttpSession sesion = req.getSession(false);
        Usuario usuario = sesion == null ? null : (Usuario) sesion.getAttribute("usuario");

        if (usuario == null) {
            Flash.error(req, "Debes iniciar sesión para acceder a esa página.");
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Nada de páginas privadas en el historial del navegador.
        res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        chain.doFilter(sreq, sres);
    }

    private boolean esPaginaDeError(HttpServletRequest req) {
        return req.getRequestURI().contains("/WEB-INF/views/comun/error");
    }

    @Override
    public void destroy() {
        // Nada que liberar.
    }
}
