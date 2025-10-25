#!/bin/bash
set -e

echo "🚀 Iniciando configuración de WordPress..."

# 🕒 Esperar a que MariaDB esté lista
echo "Esperando a que MariaDB (en ${MYSQL_HOST}) esté disponible..."
until nc -z -v -w30 ${MYSQL_HOST} 3306
do
  echo "⌛ Esperando base de datos..."
  sleep 2
done
echo "✅ Base de datos disponible!"

cd /var/www/html

# ⚙️ Crear wp-config.php si no existe
if [ ! -f wp-config.php ]; then
  echo "⚙️ Creando archivo wp-config.php..."
  cp wp-config-sample.php wp-config.php

  # Sustituir los valores por los del .env
  sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
  sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
  sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
  sed -i "s/localhost/${MYSQL_HOST}/" wp-config.php

  # Añadir configuración extra (salts y Redis)
  echo "🔐 Añadiendo claves de seguridad y configuración adicional..."
  curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php

  cat <<EOL >> wp-config.php

define('FS_METHOD', 'direct');
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_PASSWORD', '${REDIS_PASSWORD}');
define('WP_CACHE_KEY_SALT', '${DOMAIN_NAME}');
define('WP_CACHE', true);
EOL
else
  echo "📁 wp-config.php ya existe, no se modifica."
fi

# 👤 Ajustar permisos
echo "🔧 Ajustando permisos..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# 🏁 Iniciar PHP-FPM
echo "✅ Arrancando PHP-FPM..."
exec php-fpm8.2 -F
