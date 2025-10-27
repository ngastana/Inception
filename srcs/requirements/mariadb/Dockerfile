FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

COPY ./conf /tmp/

RUN apt-get update \
    && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql \
    && chmod +x /tmp/init.sh /tmp/create.sh \
    && cp /tmp/my.cnf /etc/mysql/my.cnf 

VOLUME /var/lib/mysql
EXPOSE 3306

USER mysql

# Cuando arranque el contenedor:
# 1. Ejecuta init.sh (puede crear usuarios o preparar entorno)
# 2. Genera el SQL con create.sh
# 3. Arranca MariaDB con ese SQL como init
CMD [ "sh", "-c", "/tmp/init.sh && /tmp/create.sh > /tmp/create.sql && exec mysqld --user=mysql --init-file=/tmp/create.sql" ]
