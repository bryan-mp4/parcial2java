package edu.uts.grados.dao;

import edu.uts.grados.model.Rol;
import edu.uts.grados.model.Usuario;
import edu.uts.grados.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos de usuarios y roles. Solo PreparedStatement y
 * try-with-resources; nunca se construye SQL concatenando valores.
 */
public class UsuarioDAO {

    private static final String SELECT_USUARIO =
            "SELECT u.id, u.codigo, u.nombres, u.apellidos, u.correo, u.password_hash, "
            + "u.rol_id, r.nombre AS nombre_rol, u.activo, u.creado_en "
            + "FROM usuarios u INNER JOIN roles r ON r.id = u.rol_id ";

    /** Crea un usuario (el passwordHash debe venir ya generado con Seguridad). */
    public int crear(Usuario u) throws SQLException {
        String sql = "INSERT INTO usuarios (codigo, nombres, apellidos, correo, password_hash, rol_id, activo) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getCodigo());
            ps.setString(2, u.getNombres());
            ps.setString(3, u.getApellidos());
            ps.setString(4, u.getCorreo());
            ps.setString(5, u.getPasswordHash());
            ps.setInt(6, u.getRolId());
            ps.setBoolean(7, u.isActivo());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Actualiza los datos del usuario (no toca la contraseña). */
    public boolean actualizar(Usuario u) throws SQLException {
        String sql = "UPDATE usuarios SET codigo = ?, nombres = ?, apellidos = ?, correo = ?, "
                + "rol_id = ?, activo = ? WHERE id = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, u.getCodigo());
            ps.setString(2, u.getNombres());
            ps.setString(3, u.getApellidos());
            ps.setString(4, u.getCorreo());
            ps.setInt(5, u.getRolId());
            ps.setBoolean(6, u.isActivo());
            ps.setInt(7, u.getId());
            return ps.executeUpdate() == 1;
        }
    }

    /** Cambia únicamente la contraseña (recibe el hash ya generado). */
    public boolean actualizarPassword(int id, String passwordHash) throws SQLException {
        String sql = "UPDATE usuarios SET password_hash = ? WHERE id = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, passwordHash);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        }
    }

    /** Activa o desactiva un usuario (baja/alta lógica). */
    public boolean cambiarActivo(int id, boolean activo) throws SQLException {
        String sql = "UPDATE usuarios SET activo = ? WHERE id = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setBoolean(1, activo);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Elimina físicamente un usuario. La BD usa ON DELETE RESTRICT, así que
     * si existen referencias lanza SQLException y el llamante decides la baja lógica.
     */
    public boolean eliminar(int id) throws SQLException {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        }
    }

    /**
     * Paginación con filtro por texto (nombres, apellidos, código o correo)
     * y por rol. pagina es 1-based.
     */
    public List<Usuario> listar(String busqueda, Integer rolId, int pagina, int tamanio)
            throws SQLException {
        StringBuilder sql = new StringBuilder(SELECT_USUARIO);
        List<Object> params = new ArrayList<>();
        armarFiltros(sql, params, busqueda, rolId);
        sql.append(" ORDER BY u.apellidos, u.nombres LIMIT ? OFFSET ?");

        List<Usuario> lista = new ArrayList<>();
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int i = 1;
            for (Object p : params) {
                ps.setObject(i++, p);
            }
            ps.setInt(i++, tamanio);
            ps.setInt(i, (pagina - 1) * tamanio);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    /** Total de usuarios que cumplen el filtro (para calcular las páginas). */
    public int contar(String busqueda, Integer rolId) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM usuarios u WHERE 1 = 1 ");
        List<Object> params = new ArrayList<>();
        armarFiltros(sql, params, busqueda, rolId);
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            int i = 1;
            for (Object p : params) {
                ps.setObject(i++, p);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public Usuario buscarPorId(int id) throws SQLException {
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SELECT_USUARIO + "WHERE u.id = ?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    /** Búsqueda exacta por correo (usada en el login). */
    public Usuario buscarPorCorreo(String correo) throws SQLException {
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SELECT_USUARIO + "WHERE u.correo = ?")) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    public Usuario buscarPorCodigo(String codigo) throws SQLException {
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SELECT_USUARIO + "WHERE u.codigo = ?")) {
            ps.setString(1, codigo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    /** Código repetido; exceptoId permite ignorar el propio registro al editar. */
    public boolean existeCodigo(String codigo, Integer exceptoId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE codigo = ? "
                + (exceptoId == null ? "" : "AND id <> ?");
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, codigo);
            if (exceptoId != null) {
                ps.setInt(2, exceptoId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /** Correo repetido; exceptoId permite ignorar el propio registro al editar. */
    public boolean existeCorreo(String correo, Integer exceptoId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE correo = ? "
                + (exceptoId == null ? "" : "AND id <> ?");
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            if (exceptoId != null) {
                ps.setInt(2, exceptoId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /**
     * Anteproyectos en los que participa el usuario (como estudiante, director
     * o evaluador). Si es mayor que cero no se puede borrar: se hace baja lógica.
     */
    public int contarAnteproyectos(int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM anteproyectos "
                + "WHERE estudiante_id = ? OR director_id = ? OR evaluador_id = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, usuarioId);
            ps.setInt(3, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Id del rol por nombre, o 0 si no existe (útil para validaciones por id). */
    public int idDeRol(String nombre) throws SQLException {
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement("SELECT id FROM roles WHERE nombre = ?")) {
            ps.setString(1, nombre);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<Rol> listarRoles() throws SQLException {        List<Rol> roles = new ArrayList<>();
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement("SELECT id, nombre FROM roles ORDER BY id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(new Rol(rs.getInt("id"), rs.getString("nombre")));
            }
        }
        return roles;
    }

    private void armarFiltros(StringBuilder sql, List<Object> params, String busqueda, Integer rolId) {
        if (busqueda != null && !busqueda.trim().isEmpty()) {
            sql.append(" AND (u.nombres LIKE ? OR u.apellidos LIKE ? OR u.codigo LIKE ? OR u.correo LIKE ?) ");
            String like = "%" + busqueda.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (rolId != null && rolId > 0) {
            sql.append(" AND u.rol_id = ? ");
            params.add(rolId);
        }
    }

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setCodigo(rs.getString("codigo"));
        u.setNombres(rs.getString("nombres"));
        u.setApellidos(rs.getString("apellidos"));
        u.setCorreo(rs.getString("correo"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRolId(rs.getInt("rol_id"));
        u.setNombreRol(rs.getString("nombre_rol"));
        u.setActivo(rs.getBoolean("activo"));
        Timestamp creado = rs.getTimestamp("creado_en");
        u.setCreadoEn(creado);
        return u;
    }
}
