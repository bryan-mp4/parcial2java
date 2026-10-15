package edu.uts.grados.controller;

import edu.uts.grados.model.Usuario;
import edu.uts.grados.util.Roles;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Página de inicio: muestra la portada del rol del usuario autenticado.
 *
 * <p>También atiende {@code /admin/inicio}, {@code /coordinacion/inicio},
 * {@code /director/inicio}, {@code /evaluador/inicio} y
 * {@code /estudiante/inicio}; si la URL no coincide con el rol de la sesión,
 * RolFilter responde 403.</p>
 */
@WebServlet(name = "InicioServlet", urlPatterns = {"/inicio", "/admin/inicio",
    "/coordinacion/inicio", "/director/inicio", "/evaluador/inicio", "/estudiante/inicio"})
public class InicioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Usuario usuario = (Usuario) req.getSession(false).getAttribute("usuario");
        String rol = usuario.getNombreRol();
        req.setAttribute("titulo", "Inicio");
        req.setAttribute("encabezado", "Hola, " + usuario.getNombres());
        req.getRequestDispatcher(Roles.vistaInicio(rol)).forward(req, resp);
    }
}
