#!/bin/bash
set -e

echo ">>> 👾 Ejecutando init.sh"

if [ -d "/var/lib/mysql/mysql" ]; then
    echo ">>> 👻 Base de datos ya inicializada, saltando init.sh"
    exit 0
fi

echo ">>> 👾 Inicializando directorio de datos..."
mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

# Variables de entorno (si no se definen en .env, asigna valores por defecto)
: ${MYSQL_ROOT_PASSWORD:=root}
: ${MYSQL_DATABASE:=}
: ${MYSQL_USER:=}
: ${MYSQL_PASSWORD:=}

# Llamamos a create.sh para generar el SQL de inicialización
/tmp/create.sh "$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" "$MYSQL_USER" "$MYSQL_PASSWORD" > /tmp/create.sql

echo ">>> ✅ init.sh completado, listo para arrancar MariaDB"
