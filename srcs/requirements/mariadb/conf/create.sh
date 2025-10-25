#!/bin/bash
ROOT_PASS=$1
DB_NAME=$2
DB_USER=$3
DB_PASS=$4

echo ">>> 👾 Generando create.sql con parámetros recibidos" >&2

cat <<EOF
-- Configurar usuario root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';
FLUSH PRIVILEGES;
EOF

# Si hay base de datos
if [ -n "$DB_NAME" ]; then
cat <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
EOF
fi

# Si hay usuario adicional
if [ -n "$DB_USER" ] && [ -n "$DB_PASS" ]; then
cat <<EOF
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
EOF
fi

cat <<EOF
FLUSH PRIVILEGES;
EOF
