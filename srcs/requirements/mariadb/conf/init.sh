#!/bin/bash
set -e

echo ">>> 👾 Ejecutando init.sh"

if [ -d "/var/lib/mysql/mysql" ]; then
    echo ">>> 👻 Base de datos ya inicializada, saltando init.sh"
    exit 0
fi

echo ">>> 👾 Inicializando directorio de datos..."
mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

# Llamamos a create.sh para generar el SQL de inicialización
/tmp/create.sh > /tmp/create.sql

echo ">>> ✅ init.sh completado, listo para arrancar MariaDB"
