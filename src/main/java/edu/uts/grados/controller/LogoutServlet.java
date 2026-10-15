package edu.uts.grados.controller;

import edu.uts.grados.util.Flash;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/** Cierra la sesión y vuelve al login. */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getSession(false) != null) {
            req.getSession().invalidate();
        }
        Flash.error(req, "Sesión cerrada correctamente. Vuelve a iniciar sesión.");
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
