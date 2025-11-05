#!/bin/bash
set -e

echo "🚀 Iniciando configuración de WordPress..."

echo "Esperando a que MariaDB (en ${MYSQL_HOST}) esté disponible..."
until nc -z -v -w30 ${MYSQL_HOST} 3306
do
  echo "⌛ Esperando base de datos..."
  sleep 2
done
echo "✅ Base de datos disponible!"

cd /var/www/html

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD)
export MYSQL_PASSWORD=$(cat /run/secrets/MYSQL_PASSWORD)
export WP_ADMIN_PASSWORD=$(cat /run/secrets/WP_ADMIN_PASSWORD)
export WP_CONTRIB_PASSWORD=$(cat /run/secrets/WP_CONTRIB_PASSWORD)

# ⚙️ Crear wp-config.php si no existe
if [ ! -f wp-config.php ]; then
  echo "⚙️ Creando archivo wp-config.php..."
  cp wp-config-sample.php wp-config.php

  # Sustituir los valores por los del .env
  sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
  sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
  sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
  sed -i "s/localhost/${MYSQL_HOST}/" wp-config.php

  cat <<EOL >> wp-config.php

define('FS_METHOD', 'direct');
EOL
else
  echo "📁 wp-config.php ya existe, no se modifica."
fi

# 👤 Ajustar permisos
echo "🔧 Ajustando permisos..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# 🧱 Instalar WordPress si no está instalado
if ! wp core is-installed --path=/var/www/html --allow-root; then
  echo "⚙️ Instalando WordPress..."

  wp core install \
    --url="https://${DOMAIN_NAME}" \
    --title="Inception WordPress" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --path=/var/www/html \
    --skip-email \
    --allow-root

  echo "✅ WordPress instalado con el usuario administrador '${WP_ADMIN_USER}'"

  #echo "🧹 Eliminando contenido por defecto..."
  #wp post delete 1 --force --allow-root --path=/var/www/html
  #wp comment delete 1 --force --allow-root --path=/var/www/html 2>/dev/null || true
  #wp term delete category 1 --allow-root --path=/var/www/html 2>/dev/null || true
  #echo "✅ Contenido inicial eliminado."

  # 🧑‍💻 Crear usuario colaborador
  if ! wp user get "${WP_CONTRIB_USER}" --allow-root --path=/var/www/html > /dev/null 2>&1; then
    echo "👤 Creando usuario colaborador..."
    wp user create "${WP_CONTRIB_USER}" "${WP_CONTRIB_EMAIL}" \
      --role=contributor \
      --user_pass="${WP_CONTRIB_PASSWORD}" \
      --allow-root \
      --path=/var/www/html
    echo "✅ Usuario colaborador '${WP_CONTRIB_USER}' creado con rol 'contributor'"
  else
    echo "📦 Usuario colaborador '${WP_CONTRIB_USER}' ya existe."
  fi
else
  echo "📦 WordPress ya está instalado."
fi



# 🏁 Iniciar PHP-FPM
echo "✅ Arrancando PHP-FPM..."
exec php-fpm8.2 -F
