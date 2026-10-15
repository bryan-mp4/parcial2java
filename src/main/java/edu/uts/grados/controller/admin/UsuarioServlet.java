package edu.uts.grados.controller.admin;

import edu.uts.grados.dao.UsuarioDAO;
import edu.uts.grados.model.Usuario;
import edu.uts.grados.util.Flash;
import edu.uts.grados.util.Roles;
import edu.uts.grados.util.Seguridad;
import edu.uts.grados.util.Validacion;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * CRUD de usuarios (módulo Administrador).
 *
 * <p>Un solo servlet con el parámetro {@code accion}: listar, nuevo, guardar,
 * editar, actualizar, ver, confirmarEliminar, eliminar, desactivar y activar.
 * Todas las operaciones que modifican datos usan POST-Redirect-GET con mensajes
 * flash en sesión.</p>
 *
 * <p>Reglas: código y correo únicos; contraseña mínima de 8 caracteres; un
 * administrador no puede eliminarse ni desactivarse a sí mismo; si el usuario
 * tiene anteproyectos asociados se hace baja lógica ({@code activo = 0}) en vez
 * de borrarlo.</p>
 */
@WebServlet(name = "UsuarioServlet", urlPatterns = {"/admin/usuarios"})
public class UsuarioServlet extends HttpServlet {

    private static final int POR_PAGINA = 8;

    private final UsuarioDAO dao = new UsuarioDAO();

    // ---------------------------------------------------------------- acciones

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String accion = Validacion.limpio(req.getParameter("accion"));
        if (accion.isEmpty()) {
            accion = "listar";
        }
        try {
            switch (accion) {
                case "nuevo":
                    mostrarFormulario(req, resp, new Usuario(), new ArrayList<>());
                    break;
                case "editar":
                    editar(req, resp);
                    break;
                case "ver":
                    verDetalle(req, resp);
                    break;
                case "confirmarEliminar":
                    confirmarEliminar(req, resp);
                    break;
                default:
                    listar(req, resp);
            }
        } catch (SQLException e) {
            errorInterno(req, resp, "No se pudo completar la operación del módulo de usuarios.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String accion = Validacion.limpio(req.getParameter("accion"));
        try {
            switch (accion) {
                case "guardar":
                    guardar(req, resp);
                    break;
                case "actualizar":
                    actualizar(req, resp);
                    break;
                case "eliminar":
                    eliminar(req, resp);
                    break;
                case "desactivar":
                    cambiarEstado(req, resp, false);
                    break;
                case "activar":
                    cambiarEstado(req, resp, true);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            }
        } catch (SQLException e) {
            errorInterno(req, resp, "No se pudo completar la operación del módulo de usuarios.", e);
        }
    }

    // ---------------------------------------------------------------- listar

    private void listar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String busqueda = Validacion.limpio(req.getParameter("buscar"));
        Integer rolId = filtroRol(req.getParameter("rol"));

        int total = dao.contar(busqueda, rolId);
        int paginas = (int) Math.ceil(total / (double) POR_PAGINA);
        if (paginas < 1) {
            paginas = 1;
        }
        int pagina = Validacion.pagina(req.getParameter("pagina"));
        if (pagina > paginas) {
            pagina = paginas;
        }

        req.setAttribute("usuarios", dao.listar(busqueda, rolId, pagina, POR_PAGINA));
        req.setAttribute("roles", dao.listarRoles());
        req.setAttribute("totalRegistros", total);
        req.setAttribute("paginas", paginas);
        req.setAttribute("pagina", pagina);
        req.setAttribute("buscar", busqueda);
        req.setAttribute("rolId", rolId == null ? 0 : rolId);
        req.setAttribute("titulo", "Gestión de usuarios");
        req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/lista.jsp").forward(req, resp);
    }

    private Integer filtroRol(String valor) {
        int id = Validacion.entero(valor);
        return id > 0 ? id : null;
    }

    // ---------------------------------------------------------------- crear

    private void guardar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        Usuario usuario = leerFormulario(req);
        String clave = req.getParameter("clave");
        List<String> errores = new ArrayList<>();

        if (!Validacion.esCodigo(usuario.getCodigo())) {
            errores.add("El código debe tener entre 4 y 20 caracteres (letras, números, punto, guion o guion bajo).");
        } else if (dao.existeCodigo(usuario.getCodigo(), null)) {
            errores.add("El código ya está registrado por otro usuario.");
        }
        if (!Validacion.esCorreo(usuario.getCorreo())) {
            errores.add("El correo no tiene un formato válido.");
        } else if (dao.existeCorreo(usuario.getCorreo(), null)) {
            errores.add("El correo ya está registrado por otro usuario.");
        }
        if (!Validacion.esClaveValida(clave)) {
            errores.add("La contraseña debe tener al menos 8 caracteres.");
        }
        validarNombre(usuario, errores);

        if (!errores.isEmpty()) {
            mostrarFormulario(req, resp, usuario, errores);
            return;
        }

        usuario.setPasswordHash(Seguridad.generarHash(clave));
        dao.crear(usuario);
        Flash.exito(req, "El usuario " + usuario.getNombreCompleto() + " fue creado correctamente.");
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
    }

    private void editar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        Usuario usuario = dao.buscarPorId(Validacion.entero(req.getParameter("id")));
        if (usuario == null) {
            Flash.error(req, "El usuario no existe.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }
        usuario.setPasswordHash(null);
        mostrarFormulario(req, resp, usuario, new ArrayList<>());
    }

    private void actualizar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        Usuario usuario = leerFormulario(req);
        usuario.setId(Validacion.entero(req.getParameter("id")));
        String clave = req.getParameter("clave");
        List<String> errores = new ArrayList<>();

        Usuario actual = usuarioEnSesion(req);
        Usuario previo = dao.buscarPorId(usuario.getId());
        int idAdmin = dao.idDeRol(Roles.ADMIN);
        if (usuario.getId() < 1 || previo == null) {
            Flash.error(req, "El usuario no existe.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }
        // El nombre del rol se necesita para las validaciones y para no perderlo en el formulario.
        usuario.setNombreRol(previo.getNombreRol());

        if (!Validacion.esCodigo(usuario.getCodigo())) {
            errores.add("El código debe tener entre 4 y 20 caracteres (letras, números, punto, guion o guion bajo).");
        } else if (dao.existeCodigo(usuario.getCodigo(), usuario.getId())) {
            errores.add("El código ya está registrado por otro usuario.");
        }
        if (!Validacion.esCorreo(usuario.getCorreo())) {
            errores.add("El correo no tiene un formato válido.");
        } else if (dao.existeCorreo(usuario.getCorreo(), usuario.getId())) {
            errores.add("El correo ya está registrado por otro usuario.");
        }
        validarNombre(usuario, errores);
        if (clave != null && !clave.trim().isEmpty() && !Validacion.esClaveValida(clave)) {
            errores.add("La contraseña debe tener al menos 8 caracteres.");
        }

        // Protección: el administrador no puede cambiarse su propio rol ni desactivarse.
        if (usuario.getId() == actual.getId()) {
            if (usuario.getRolId() != idAdmin) {
                errores.add("No puedes cambiar tu propio rol de administrador.");
            }
            if (!usuario.isActivo()) {
                errores.add("No puedes desactivar tu propio usuario.");
            }
        }

        if (!errores.isEmpty()) {
            mostrarFormulario(req, resp, usuario, errores);
            return;
        }

        dao.actualizar(usuario);
        if (clave != null && !clave.trim().isEmpty()) {
            dao.actualizarPassword(usuario.getId(), Seguridad.generarHash(clave));
        }
        Flash.exito(req, "Los datos de " + usuario.getNombreCompleto() + " fueron actualizados.");
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
    }

    // ---------------------------------------------------------------- detalle y baja

    private void verDetalle(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        Usuario usuario = dao.buscarPorId(Validacion.entero(req.getParameter("id")));
        if (usuario == null) {
            Flash.error(req, "El usuario no existe.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }
        req.setAttribute("usuario", usuario);
        req.setAttribute("titulo", "Detalle del usuario");
        req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/detalle.jsp").forward(req, resp);
    }

    private void confirmarEliminar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        Usuario usuario = dao.buscarPorId(Validacion.entero(req.getParameter("id")));
        if (usuario == null) {
            Flash.error(req, "El usuario no existe.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }
        req.setAttribute("usuario", usuario);
        req.setAttribute("anteproyectos", dao.contarAnteproyectos(usuario.getId()));
        req.setAttribute("titulo", "Eliminar usuario");
        req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/confirmar_eliminar.jsp").forward(req, resp);
    }

    private void eliminar(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        int id = Validacion.entero(req.getParameter("id"));
        Usuario actual = usuarioEnSesion(req);

        if (id == actual.getId()) {
            Flash.error(req, "No puedes eliminar tu propio usuario.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }
        Usuario usuario = dao.buscarPorId(id);
        if (usuario == null) {
            Flash.error(req, "El usuario no existe.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }

        int asociados = dao.contarAnteproyectos(id);
        if (asociados > 0) {
            // Baja lógica: no se puede borrar alguien con anteproyectos asociados.
            dao.cambiarActivo(id, false);
            Flash.exito(req, "El usuario " + usuario.getNombreCompleto()
                    + " tiene " + asociados + " anteproyecto(s) asociado(s), por eso se desactivó"
                    + " (baja lógica) en lugar de eliminarlo.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }

        try {
            dao.eliminar(id);
            Flash.exito(req, "El usuario " + usuario.getNombreCompleto() + " fue eliminado.");
        } catch (SQLException e) {
            // Otras tablas (ideas, revisiones, eventos, formatos) lo referencian:
            // la FK impide el borrado, así que se desactiva.
            getServletContext().log("No se pudo eliminar el usuario " + id, e);
            dao.cambiarActivo(id, false);
            Flash.exito(req, "El usuario " + usuario.getNombreCompleto()
                    + " tiene información asociada en el sistema, por eso se desactivó (baja lógica).");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
    }

    private void cambiarEstado(HttpServletRequest req, HttpServletResponse resp, boolean activo)
            throws SQLException, IOException {
        int id = Validacion.entero(req.getParameter("id"));
        Usuario actual = usuarioEnSesion(req);

        if (!activo && id == actual.getId()) {
            Flash.error(req, "No puedes desactivar tu propio usuario.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }
        Usuario usuario = dao.buscarPorId(id);
        if (usuario == null) {
            Flash.error(req, "El usuario no existe.");
            resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
            return;
        }
        dao.cambiarActivo(id, activo);
        Flash.exito(req, "El usuario " + usuario.getNombreCompleto()
                + (activo ? " fue activado." : " fue desactivado."));
        resp.sendRedirect(req.getContextPath() + "/admin/usuarios");
    }

    // ---------------------------------------------------------------- utilidades

    private Usuario usuarioEnSesion(HttpServletRequest req) {
        return (Usuario) req.getSession(false).getAttribute("usuario");
    }

    private Usuario leerFormulario(HttpServletRequest req) {
        Usuario u = new Usuario();
        u.setCodigo(Validacion.limpio(req.getParameter("codigo")));
        u.setNombres(Validacion.limpio(req.getParameter("nombres")));
        u.setApellidos(Validacion.limpio(req.getParameter("apellidos")));
        u.setCorreo(Validacion.normalizarCorreo(req.getParameter("correo")));
        // Casilla "activo": si no viene en el formulario, el usuario queda inactivo.
        u.setActivo(req.getParameter("activo") != null);
        int rolId = Validacion.entero(req.getParameter("rolId"));
        u.setRolId(rolId > 0 ? rolId : 0);
        return u;
    }

    private void validarNombre(Usuario u, List<String> errores) {
        if (!Validacion.esNombre(u.getNombres())) {
            errores.add("Los nombres deben tener entre 2 y 60 letras.");
        }
        if (!Validacion.esNombre(u.getApellidos())) {
            errores.add("Los apellidos deben tener entre 2 y 60 letras.");
        }
    }

    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse resp,
            Usuario usuario, List<String> errores)
            throws SQLException, ServletException, IOException {
        req.setAttribute("usuario", usuario);
        req.setAttribute("errores", errores);
        req.setAttribute("roles", dao.listarRoles());
        req.setAttribute("titulo", usuario.getId() > 0 ? "Editar usuario" : "Nuevo usuario");
        req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/formulario.jsp").forward(req, resp);
    }

    private void errorInterno(HttpServletRequest req, HttpServletResponse resp,
            String mensaje, SQLException e) throws IOException {
        getServletContext().log(mensaje, e);
        resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, mensaje);
    }
}
