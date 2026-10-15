package edu.uts.grados.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Hash y verificación de contraseñas con PBKDF2 (JDK, sin dependencias).
 *
 * <p>Formato almacenado (una sola cadena): {@code iteraciones:salBase64:hashBase64}.
 * Cada usuario tiene su propia sal aleatoria. Nunca se guarda ni se registra
 * una contraseña en claro.</p>
 *
 * <p>Incluye un {@code main} de consola para generar los hashes de los datos
 * de prueba (no imprime las contraseñas recibidas):</p>
 * <pre>java -cp "build/classes:WEB-INF/lib/*" edu.uts.grados.util.Seguridad clave1 clave2</pre>
 */
public final class Seguridad {

    /** Algoritmo disponible en cualquier JDK 11+. */
    private static final String ALGORITMO = "PBKDF2WithHmacSHA256";
    /** Iteraciones: costo deliberado del hash. */
    private static final int ITERACIONES = 200_000;
    /** Sal de 128 bits por usuario. */
    private static final int BYTES_SAL = 16;
    /** Hash derivado de 256 bits. */
    private static final int BITS_HASH = 256;
    private static final String SEPARADOR = ":";

    private static final SecureRandom ALEATORIO = new SecureRandom();

    private Seguridad() {
    }

    /** Devuelve el hash listo para guardar en {@code usuarios.password_hash}. */
    public static String generarHash(String clave) {
        if (clave == null || clave.isEmpty()) {
            throw new IllegalArgumentException("La contraseña no puede estar vacía");
        }
        byte[] sal = new byte[BYTES_SAL];
        ALEATORIO.nextBytes(sal);
        byte[] hash;
        try {
            hash = derivar(clave.toCharArray(), sal, ITERACIONES);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("No está disponible el algoritmo " + ALGORITMO, e);
        }
        return ITERACIONES + SEPARADOR + aBase64(sal) + SEPARADOR + aBase64(hash);
    }

    /** Verifica una contraseña en claro contra el hash almacenado. */
    public static boolean verificar(String clave, String hashAlmacenado) {
        if (clave == null || clave.isEmpty() || hashAlmacenado == null || hashAlmacenado.isEmpty()) {
            return false;
        }
        String[] partes = hashAlmacenado.split(SEPARADOR);
        if (partes.length != 3) {
            return false;
        }
        try {
            int iteraciones = Integer.parseInt(partes[0]);
            byte[] sal = Base64.getDecoder().decode(partes[1]);
            byte[] hashEsperado = Base64.getDecoder().decode(partes[2]);
            if (iteraciones < 1) {
                return false;
            }
            byte[] hashReal = derivar(clave.toCharArray(), sal, iteraciones);
            return MessageDigest.isEqual(hashEsperado, hashReal);
        } catch (IllegalArgumentException | InvalidKeySpecException | NoSuchAlgorithmException e) {
            return false;
        }
    }

    private static byte[] derivar(char[] clave, byte[] sal, int iteraciones)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        PBEKeySpec spec = new PBEKeySpec(clave, sal, iteraciones, BITS_HASH);
        try {
            return SecretKeyFactory.getInstance(ALGORITMO).generateSecret(spec).getEncoded();
        } finally {
            spec.clearPassword();
        }
    }

    private static String aBase64(byte[] datos) {
        return Base64.getEncoder().encodeToString(datos);
    }

    /**
     * Utilidad de consola: recibe contraseñas como argumentos e imprime, en el
     * mismo orden, una línea con el hash de cada una. No muestra las contraseñas.
     */
    public static void main(String[] args) {
        if (args.length == 0) {
            System.err.println("Uso: java " + Seguridad.class.getName() + " clave1 [clave2 ...]");
            System.exit(1);
        }
        for (String clave : args) {
            System.out.println(generarHash(clave));
        }
    }
}
