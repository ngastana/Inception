FROM mariadb:11.7

COPY ./conf /tmp/

RUN apt-get update
RUN apt-get -y install mariadb-server
RUN service mariadb start
RUN chmod +x /tmp/create.sh
RUN chmod +x /tmp/init.sh

RUN /tmp/init.sh

EXPOSE 3306  
#estara escuchando este puerto para conexionaes entrantes
#puerto estandar de MariaDB

#CMD es na instruccion que se da cunado el docker se levante
#sh intérprete de comandos shell  en Bash
#-c que ejecute comando que le sigue como una cadena de texto
CMD [ "sh", "-c", "./tmp/create.sh > /tmp/create.sql && mysqld --init-file=/tmp/create.sql"]
#mysqld comando que inicia el servicio de bases de datos de MariaDB proceso principal)
#mysql se utiliza para interactuar con la base de datos, manejar las bases de datos d manera interactiva
#mysqldump para hacer copias de seguridad de las bases de datos

#--init-file: cuando se inicie ejecute
