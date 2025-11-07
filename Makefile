include secrets/.env
export

NAME = INCEPTION

CLR_RMV		:= \033[0m
RED		    := \033[1;31m
GREEN		:= \033[1;32m
YELLOW		:= \033[1;33m
BLUE		:= \033[1;34m
CYAN 		:= \033[1;36m

all:
	@echo "$(YELLOW)⌛ Creando carpetas mariadb y wordpress ⌛$(CLR_RMV)"
	sudo mkdir -p /home/ngastana/data/mariadb
	sudo mkdir -p /home/ngastana/data/wordpress
	sudo chown -R $(whoami):$(whoami) /home/ngastana/data
	@echo "$(YELLOW)🚀 docker-compose up --build.... 🚀$(CLR_RMV)"
	docker-compose -f srcs/docker-compose.yml up --build

build:
	docker-compose -f srcs/docker-compose.yml build --no-cache

up:
	docker-compose -f srcs/docker-compose.yml up

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	@echo "$(YELLOW)🧹 Limpiando entorno de INCEPTION...$(CLR_RMV)"
	@docker-compose --env-file $(ENV_FILE) -f srcs/docker-compose.yml down -v || true
	@docker system prune -af --volumes
	@echo "$(BLUE)🧼 Eliminando datos persistentes...$(CLR_RMV)"
	@sudo mkdir -p /home/ngastana/data/mariadb /home/ngastana/data/wordpress
	@sudo rm -rf /home/ngastana/data/mariadb/* /home/ngastana/data/wordpress/*
	@sudo chown -R $(USER):$(USER) /home/ngastana/data
	@echo "$(GREEN)✅ Limpieza completa. Entorno listo para volver a construir.$(CLR_RMV)"

fclean: clean
	@echo "$(RED)⚠️ Eliminando TODO Docker (imágenes, volúmenes, redes)...$(CLR_RMV)"
	@docker stop $(docker ps -qa) 2>/dev/null || true
	@docker rm $(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $(docker images -qa) 2>/dev/null || true
	@docker volume rm $(docker volume ls -q) 2>/dev/null || true
	@docker network rm $(docker network ls -q) 2>/dev/null || true
	@echo "$(GREEN)🔥 Entorno Docker completamente reseteado.$(CLR_RMV)"

re: fclean all

.PHONY: all clean fclean re
