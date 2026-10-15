package edu.uts.grados.controller;

import edu.uts.grados.dao.UsuarioDAO;
import edu.uts.grados.model.Usuario;
import edu.uts.grados.util.Flash;
import edu.uts.grados.util.Seguridad;
import edu.uts.grados.util.Validacion;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Login por correo y contraseña.
 *
 * <p>El mensaje de error es siempre el mismo (no revela si falló el correo o la
 * contraseña), y una cuenta inactiva recibe el mismo tratamiento. Tras entrar
 * se regenera el id de sesión y se guarda el usuario y su rol.</p>
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getSession(false) != null && req.getSession(false).getAttribute("usuario") != null) {
            resp.sendRedirect(req.getContextPath() + "/inicio");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String correo = Validacion.normalizarCorreo(req.getParameter("correo"));
        String clave = req.getParameter("clave");

        Usuario usuario = null;
        try {
            usuario = dao.buscarPorCorreo(correo);
        } catch (SQLException e) {
            getServletContext().log("Error consultando el usuario para el login", e);
        }

        boolean ok = usuario != null && usuario.isActivo() && Seguridad.verificar(clave, usuario.getPasswordHash());

        if (!ok) {
            // Mensaje único: no indica si el correo existe, si la clave es incorrecta
            // o si la cuenta está inactiva.
            Flash.error(req, "Correo o contraseña incorrectos.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Regenera el identificador de sesión para evitar fijación de sesión.
        // La petición debe tener una sesión asociada antes de cambiarle el id.
        req.getSession(true);
        req.changeSessionId();
        HttpSession sesion = req.getSession();
        Flash.limpiar(req);
        sesion.setAttribute("usuario", usuario);
        sesion.setAttribute("rol", usuario.getNombreRol());
        Flash.exito(req, "Bienvenido, " + usuario.getNombreCompleto() + ".");

        resp.sendRedirect(req.getContextPath() + "/inicio");
    }
}
