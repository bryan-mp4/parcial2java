package edu.uts.grados.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * Asegura que el cuerpo de las peticiones se interprete como UTF-8.
 *
 * <p>Tomcat usa ISO-8859-1 por defecto para el cuerpo de los formularios, lo que
 * corrompe las tildes y las eñes ("Pérez" -> "PÃ©rez"). Este filtro, declarado
 * antes que los demás, fija UTF-8 antes de que se lean los parámetros.</p>
 */
public class CodificacionFilter implements Filter {

    private static final String CHARSET = "UTF-8";

    @Override
    public void init(FilterConfig config) {
        // Sin parámetros.
    }

    @Override
    public void doFilter(ServletRequest sreq, ServletResponse sres, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) sreq;
        if (req.getCharacterEncoding() == null) {
            try {
                req.setCharacterEncoding(CHARSET);
            } catch (IllegalArgumentException | UnsupportedOperationException e) {
                // Si el contenedor no lo permite se ignora: no es crítico.
            }
        }
        chain.doFilter(sreq, sres);
    }

    @Override
    public void destroy() {
        // Nada que liberar.
    }
}
