package edu.uts.grados.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Fábrica de conexiones JDBC a MariaDB.
 *
 * <p>La configuración se busca en este orden:</p>
 * <ol>
 *   <li>Archivo externo indicado por la propiedad de sistema {@code db.props}
 *       o la variable de entorno {@code TRABAJOS_GRADO_DB_PROPS}.</li>
 *   <li>Recurso {@code db.properties} del classpath (lo empaqueta build.sh
 *       desde el {@code db.properties} de la raíz del proyecto).</li>
 *   <li>Valores por defecto locales (localhost:3306/trabajos_grado) con aviso.</li>
 * </ol>
 *
 * <p>Nunca se registra la contraseña.</p>
 */
public final class Conexion {

    private static final Logger LOG = Logger.getLogger(Conexion.class.getName());

    /** Driver de MariaDB (JAR en WEB-INF/lib). */
    public static final String DRIVER = "org.mariadb.jdbc.Driver";
    private static final String ARCHIVO = "db.properties";
    private static final String PROPIEDAD_RUTA = "db.props";
    private static final String ENV_RUTA = "TRABAJOS_GRADO_DB_PROPS";

    private static final Properties CONFIG = cargar();

    private Conexion() {
    }

    /** Abre una conexión nueva. El llamante la cierra (try-with-resources). */
    public static Connection getConexion() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("No se encontró el driver MariaDB (" + DRIVER
                    + "). Verifica mariadb-java-client-*.jar en WEB-INF/lib.", e);
        }
        return DriverManager.getConnection(
                "jdbc:mariadb://" + valor("host") + ":" + valor("puerto") + "/" + valor("base"),
                valor("usuario"),
                valor("contrasena"));
    }

    /** URL JDBC resultante, útil para depurar (sin credenciales). */
    public static String getUrl() {
        return "jdbc:mariadb://" + valor("host") + ":" + valor("puerto") + "/" + valor("base");
    }

    private static String valor(String clave) {
        return CONFIG.getProperty(clave, "").trim();
    }

    private static Properties cargar() {
        Properties props = new Properties();

        String rutaExterna = System.getProperty(PROPIEDAD_RUTA);
        if (rutaExterna == null || rutaExterna.trim().isEmpty()) {
            rutaExterna = System.getenv(ENV_RUTA);
        }
        if (rutaExterna != null && !rutaExterna.trim().isEmpty()) {
            try (InputStream in = new FileInputStream(rutaExterna.trim())) {
                props.load(in);
                return props;
            } catch (IOException e) {
                throw new IllegalStateException("No se pudo leer db.properties en: " + rutaExterna, e);
            }
        }

        try (InputStream in = Conexion.class.getClassLoader().getResourceAsStream(ARCHIVO)) {
            if (in != null) {
                props.load(in);
                return props;
            }
        } catch (IOException e) {
            LOG.log(Level.WARNING, "No se pudo leer db.properties del classpath", e);
        }

        LOG.warning("No se encontró db.properties; se usan valores por defecto "
                + "(localhost:3306/trabajos_grado). Copia db.properties.example y configúralo.");
        props.setProperty("host", "localhost");
        props.setProperty("puerto", "3306");
        props.setProperty("base", "trabajos_grado");
        props.setProperty("usuario", "root");
        props.setProperty("contrasena", "");
        return props;
    }
}
