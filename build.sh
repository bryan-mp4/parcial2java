#!/usr/bin/env bash
# ============================================================================
#  Compilación y empaquetado del proyecto "Trabajos de Grado" (SIN Maven/Gradle)
# ----------------------------------------------------------------------------
#  Qué hace:
#    1. Compila las clases de src/main/java con javac al classpath correcto.
#    2. Copia los recursos web (JSP, WEB-INF, assets) a build/stage.
#    3. Genera build/TrabajosGrado.war con la herramienta "jar".
#    4. (Opcional) Copia el WAR a la carpeta webapps de Tomcat 9.
#
#  Uso:
#     ./build.sh                  compila y empaqueta
#     ./build.sh --desplegar      compila, empaqueta y copia el WAR a Tomcat
#     ./build.sh --limpiar        borra la carpeta build/ y sale
#
#  Variables de entorno (también se pueden poner como valores por defecto abajo):
#     RUTA_TOMCAT   raíz o carpeta lib de Tomcat (donde están servlet-api.jar
#                   y jsp-api.jar)
#     RUTA_WEBAPPS  carpeta webapps de Tomcat
#     FORZAR=1      permite sobrescribir una carpeta de despliegue existente
#
#  Requisitos: JDK 11 o superior, Apache Tomcat 9.
# ============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
#  CONFIGURACIÓN PRINCIPAL: ajusta estas rutas a tu equipo
# ---------------------------------------------------------------------------
RUTA_TOMCAT="${RUTA_TOMCAT:-/usr/share/tomcat9}"          # Tomcat del sistema (Debian/Ubuntu)
# RUTA_TOMCAT="/opt/tomcat9"                               # instalación manual típica
RUTA_WEBAPPS="${RUTA_WEBAPPS:-/var/lib/tomcat9/webapps}"  # webapps de Tomcat
DESPLEGAR=0

for argumento in "$@"; do
  case "$argumento" in
    --desplegar|-d) DESPLEGAR=1 ;;
    --limpiar) rm -rf build; echo "Carpeta build/ eliminada."; exit 0 ;;
    --ayuda|-h)
      grep '^#' "$0" | sed 's/^# \{0,1\}//' | head -n 30
      exit 0 ;;
    *) echo "Opción desconocida: $argumento (usa --desplegar, --limpiar o --ayuda)"; exit 1 ;;
  esac
done

# ---------------------------------------------------------------------------
#  Rutas del proyecto
# ---------------------------------------------------------------------------
PROYECTO="$(cd "$(dirname "$0")" && pwd)"
WEBAPP="$PROYECTO/src/main/webapp"
FUENTES="$PROYECTO/src/main/java"
BUILD="$PROYECTO/build"
CLASES="$BUILD/classes"
STAGE="$BUILD/stage"
NOMBRE_WAR="TrabajosGrado"
CONTEXTO="/TrabajosGrado"

separador() { echo "------------------------------------------------------------"; }

# ---------------------------------------------------------------------------
#  Detección automática de Tomcat (por si las rutas de arriba no existen)
# ---------------------------------------------------------------------------
buscar_lib_tomcat() {
  local candidatos=(
    "$RUTA_TOMCAT" "$RUTA_TOMCAT/lib"
    "${CATALINA_HOME:-}/lib"
    /usr/share/tomcat9/lib /usr/share/tomcat9
    /opt/tomcat9/latest/lib /opt/tomcat9/latest /opt/tomcat9/lib /opt/tomcat9
    /usr/local/tomcat9/lib /usr/local/tomcat9
    /srv/tomcat9/lib /srv/tomcat9
  )
  for carpeta in "${candidatos[@]}"; do
    [ -n "$carpeta" ] || continue
    if [ -f "$carpeta/servlet-api.jar" ]; then
      echo "$carpeta"
      return 0
    fi
  done
  return 1
}

buscar_webapps() {
  local candidatos=(
    "$RUTA_WEBAPPS"
    "$RUTA_TOMCAT/webapps" "${CATALINA_HOME:-}/webapps"
    /var/lib/tomcat9/webapps
    /opt/tomcat9/latest/webapps /opt/tomcat9/webapps
    /usr/local/tomcat9/webapps /srv/tomcat9/webapps
  )
  for carpeta in "${candidatos[@]}"; do
    [ -n "$carpeta" ] || continue
    if [ -d "$carpeta" ]; then
      echo "$carpeta"
      return 0
    fi
  done
  return 1
}

echo "=== Build del Sistema de Trabajos de Grado (sin Maven) ==="
separador
echo "Proyecto : $PROYECTO"

# --- JDK ---
if ! command -v javac >/dev/null 2>&1; then
  echo "ERROR: no se encontró 'javac'. Instala el JDK (11 o superior)." >&2
  exit 1
fi
JDK_VERSION="$(javac -version 2>&1 | sed -E 's/^javac ([0-9]+).*/\1/')"
# JDK 9+ permite fijar la versión de bytecode con --release 11 (compatible con Tomcat 9).
if [ "${JDK_VERSION:-0}" -ge 9 ]; then
  OPCIONES_VERSION="--release 11"
else
  OPCIONES_VERSION=""
fi
echo "JDK      : $JDK_VERSION ($OPCIONES_VERSION)"

# --- libs de Tomcat ---
if ! LIB_TOMCAT="$(buscar_lib_tomcat)"; then
  echo "ERROR: no se encontró servlet-api.jar. Define RUTA_TOMCAT con la ruta de tu" >&2
  echo "       Tomcat (la que contiene lib/servlet-api.jar) y vuelve a ejecutar." >&2
  exit 1
fi
echo "Tomcat   : $LIB_TOMCAT"
for jar in servlet-api.jar jsp-api.jar; do
  if [ ! -f "$LIB_TOMCAT/$jar" ]; then
    echo "ERROR: falta $jar en $LIB_TOMCAT" >&2
    exit 1
  fi
done

# --- JARs de la aplicación (no se descargan: deben estar en WEB-INF/lib) ---
if [ ! -d "$WEBAPP/WEB-INF/lib" ] || [ -z "$(ls -A "$WEBAPP/WEB-INF/lib" 2>/dev/null)" ]; then
  echo "AVISO: WEB-INF/lib está vacío. Copia allí jstl-1.2.jar y" >&2
  echo "       mariadb-java-client-3.x.jar antes de desplegar." >&2
fi
separador

# ---------------------------------------------------------------------------
#  1. Compilación
# ---------------------------------------------------------------------------
echo "[1/4] Compilando fuentes Java..."
rm -rf "$CLASES"
mkdir -p "$CLASES"

CLASSPATH="$LIB_TOMCAT/servlet-api.jar:$LIB_TOMCAT/jsp-api.jar:$WEBAPP/WEB-INF/lib/*"

find "$FUENTES" -name '*.java' -print > "$BUILD/fuentes.txt" 2>/dev/null || true
if [ ! -s "$BUILD/fuentes.txt" ]; then
  mkdir -p "$BUILD"
  find "$FUENTES" -name '*.java' > "$BUILD/fuentes.txt"
fi

javac $OPCIONES_VERSION -encoding UTF-8 -d "$CLASES" -cp "$CLASSPATH" "@$BUILD/fuentes.txt"
echo "      -> clases generadas en ${CLASES#$PROYECTO/}"

# ---------------------------------------------------------------------------
#  2. Copia de recursos web
# ---------------------------------------------------------------------------
echo "[2/4] Copiando recursos web..."
rm -rf "$STAGE"
mkdir -p "$STAGE/WEB-INF/classes"
cp -R "$WEBAPP/." "$STAGE/"

# Clases compiladas -> WEB-INF/classes/
cp -R "$CLASES/." "$STAGE/WEB-INF/classes/"
echo "      -> clases compiladas copiadas a WEB-INF/classes"

# db.properties: NO se versiona. Si existe en la raíz del proyecto se empaqueta
# dentro del WAR (WEB-INF/classes) para que util.Conexion lo encuentre.
if [ -f "$PROYECTO/db.properties" ]; then
  cp "$PROYECTO/db.properties" "$STAGE/WEB-INF/classes/"
  echo "      -> db.properties incluido en WEB-INF/classes"
else
  echo "      AVISO: no hay db.properties en la raíz; se usarán los valores por"
  echo "             defecto (localhost:3306/trabajos_grado). Copia el ejemplo:"
  echo "             cp db.properties.example db.properties"
fi

# ---------------------------------------------------------------------------
#  3. Empaquetado del WAR
# ---------------------------------------------------------------------------
echo "[3/4] Generando $NOMBRE_WAR.war..."
rm -f "$BUILD/$NOMBRE_WAR.war"
if ! command -v jar >/dev/null 2>&1; then
  echo "ERROR: no se encontró la herramienta 'jar' (¿tienes un JDK y no solo un JRE?)" >&2
  exit 1
fi
jar cf "$BUILD/$NOMBRE_WAR.war" -C "$STAGE" .
echo "      -> ${BUILD#$PROYECTO/}/$NOMBRE_WAR.war ($(du -h "$BUILD/$NOMBRE_WAR.war" | cut -f1))"

# ---------------------------------------------------------------------------
#  4. Despliegue (opcional)
# ---------------------------------------------------------------------------
if [ "$DESPLEGAR" -eq 1 ]; then
  if ! WEBAPPS="$(buscar_webapps)"; then
    echo "ERROR: no se encontró la carpeta webapps. Define RUTA_WEBAPPS." >&2
    exit 1
  fi
  DESTINO_DIR="$WEBAPPS/$NOMBRE_WAR"
  if [ -d "$DESTINO_DIR" ] && [ "${FORZAR:-0}" != "1" ]; then
    separador
    echo "ATENCIÓN: ya existe $DESTINO_DIR"
    echo "  Si esa carpeta es el código fuente (el proyecto vive dentro de webapps),"
    echo "  NO copies el WAR ahí: Tomcat expandiría el WAR y borraría el código."
    echo "  Opciones:"
    echo "    a) Mueve el proyecto fuera de webapps (recomendado)."
    echo "    b) Despliega con otro context path."
    echo "    c) Fuerza la copia con: FORZAR=1 ./build.sh --desplegar"
    exit 1
  fi
  cp "$BUILD/$NOMBRE_WAR.war" "$WEBAPPS/"
  echo "[4/4] WAR copiado en $WEBAPPS"
  echo "      Reinicia Tomcat y entra en: http://localhost:8080$CONTEXTO/login"
else
  echo "[4/4] Despliegue omitido (usa --desplegar para copiar el WAR a webapps)."
  echo "      También puedes copiar build/$NOMBRE_WAR.war a mano."
fi

separador
echo "Build terminado correctamente."
echo "Siguiente: $CONTEXTO/login  (por ejemplo http://localhost:8080$CONTEXTO/login)"
