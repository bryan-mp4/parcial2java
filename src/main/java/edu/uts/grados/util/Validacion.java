package edu.uts.grados.util;

import java.util.regex.Pattern;

/**
 * Validaciones de entrada (siempre en servidor, nunca se confía en el navegador).
 */
public final class Validacion {

    private static final Pattern CORREO = Pattern.compile("^[\\w.+-]{1,64}@[\\w-]{1,63}(\\.[\\w-]{1,63})+$");
    private static final Pattern CODIGO = Pattern.compile("^[A-Za-z0-9._-]{4,20}$");
    private static final Pattern NOMBRE = Pattern.compile("^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ' ]{2,60}$");

    public static final int LARGO_MINIMO_CLAVE = 8;
    public static final int LARGO_MAXIMO_CLAVE = 72;

    private Validacion() {
    }

    /** Normaliza un texto: null -> "", sin espacios externos. */
    public static String limpio(String texto) {
        return texto == null ? "" : texto.trim();
    }

    /** Correo en minúsculas y sin espacios (así se compara y se guarda). */
    public static String normalizarCorreo(String correo) {
        return limpio(correo).toLowerCase();
    }

    public static boolean esCorreo(String correo) {
        return CORREO.matcher(limpio(correo)).matches();
    }

    public static boolean esCodigo(String codigo) {
        return CODIGO.matcher(limpio(codigo)).matches();
    }

    public static boolean esNombre(String nombre) {
        return NOMBRE.matcher(limpio(nombre)).matches();
    }

    /** Mínimo 8 caracteres (requisito del proyecto), máximo 72 por límite de PBKDF2. */
    public static boolean esClaveValida(String clave) {
        return clave != null && clave.length() >= LARGO_MINIMO_CLAVE
                && clave.length() <= LARGO_MAXIMO_CLAVE && !clave.trim().isEmpty();
    }

    /** Convierte un id recibido por URL; devuelve -1 si no es válido. */
    public static int entero(String valor) {
        try {
            return Integer.parseInt(limpio(valor));
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    /** Página solicitada (1-based); devuelve 1 si viene vacía o inválida. */
    public static int pagina(String valor) {
        int n = entero(valor);
        return n < 1 ? 1 : n;
    }
}
