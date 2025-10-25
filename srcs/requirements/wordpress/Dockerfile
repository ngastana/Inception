FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar herramientas y PHP
RUN apt-get update && \
    apt-get install -y curl wget netcat-openbsd tar unzip php8.2 php8.2-fpm php8.2-mysql php8.2-gd php8.2-xml php8.2-curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Crear carpeta para WordPress
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Descargar WordPress
RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    unzip /tmp/wordpress.zip -d /tmp/ && \
    mv /tmp/wordpress/* /var/www/html/ && \
    rm -rf /tmp/wordpress /tmp/wordpress.zip

# Ajustar permisos
RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

# Exponer puerto 9000 para PHP-FPM
EXPOSE 9000


# Copiar script de inicialización
COPY ./conf/init-wordpress.sh /usr/local/bin/init-wordpress.sh
RUN chmod +x /usr/local/bin/init-wordpress.sh

# Ejecutar script al inicio
CMD ["init-wordpress.sh"]