FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

#con 80 estariamos en un HTTP pero con 443 es un HTTPS, esto hace que sea necesitas configurar SSL
RUN apt-get update && apt-get install -y nginx openssl && apt-get clean

# Crear directorio para los certificados
RUN mkdir -p /etc/nginx/ssl

# Generar certificado autofirmado (válido 365 días, CN=localhost)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/ngastana.key \
    -out /etc/nginx/ssl/ngastana.crt \
    -subj "/CN=ngastana.42.fr"

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./tools/index.html /var/www/html/index.html

EXPOSE 443

#para  ejecutar nginx. Le decimos daemon off porque no queremos que se quede en segundo plano y se cierre, sino que se quede en primer plano para que el contenedor no se cierre. Si Nginx se ejecuta en segundo plano, docker piensa que ha terminado y para
CMD ["nginx", "-g", "daemon off;"]