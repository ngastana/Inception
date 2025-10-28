#!/bin/bash
echo ">>> 👾 Generando create.sql con parámetros recibidos" >&2

cat <<EOF
-- Configurar usuario root
ALTER USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Si hay base de datos
if [ -n "$MYSQL_DATABASE" ]; then
cat <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
EOF
fi

# Si hay usuario adicional
if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
cat <<EOF
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
EOF
fi

cat <<EOF
FLUSH PRIVILEGES;
EOF
