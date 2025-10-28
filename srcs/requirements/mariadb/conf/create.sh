#!/bin/bash
echo ">>> 👾 Generando create.sql con parámetros recibidos" >&2

# Configuración del usuario root
cat <<EOF
-- Configurar usuario root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
EOF

# Si hay base de datos, la creamos
if [ -n "$MYSQL_DATABASE" ]; then
    cat <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
EOF
fi

# Si hay usuario adicional, lo creamos y le otorgamos privilegios
if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
    cat <<EOF
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Terminar el script con un FLUSH GENERAL
cat <<EOF
FLUSH PRIVILEGES;
EOF
