package edu.uts.grados.model;

import java.sql.Timestamp;

/** Usuario del sistema (tabla usuarios). */
public class Usuario {

    private int id;
    private String codigo;
    private String nombres;
    private String apellidos;
    private String correo;
    /** Hash PBKDF2 con formato iteraciones:salBase64:hashBase64. */
    private String passwordHash;
    private int rolId;
    /** Nombre del rol (viene del JOIN con roles); solo lectura. */
    private String nombreRol;
    private boolean activo;
    private Timestamp creadoEn;

    public Usuario() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public int getRolId() {
        return rolId;
    }

    public void setRolId(int rolId) {
        this.rolId = rolId;
    }

    public String getNombreRol() {
        return nombreRol;
    }

    public void setNombreRol(String nombreRol) {
        this.nombreRol = nombreRol;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public Timestamp getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(Timestamp creadoEn) {
        this.creadoEn = creadoEn;
    }

    public String getNombreCompleto() {
        return (nombres == null ? "" : nombres) + " " + (apellidos == null ? "" : apellidos);
    }

    /** true si el usuario tiene el rol indicado. */
    public boolean esRol(String rol) {
        return nombreRol != null && nombreRol.equalsIgnoreCase(rol);
    }
}
