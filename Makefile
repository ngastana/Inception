NAME = INCEPTION

CLR_RMV		:= \033[0m
RED		    := \033[1;31m
GREEN		:= \033[1;32m
YELLOW		:= \033[1;33m
BLUE		:= \033[1;34m
CYAN 		:= \033[1;36m

SECRETS_DIR = secrets
SECRETS_FILES = db_root_password.txt db_password.txt wp_admin_password.txt wp_contrib_password.txt
SECRETS_PATHS = $(addprefix $(SECRETS_DIR)/, $(SECRETS_FILES))
DATA_DIR = /home/$(USER)/data

all:
	@echo "$(YELLOW)⌛ Creando carpetas mariadb y wordpress ⌛$(CLR_RMV)"
	sudo mkdir -p /home/ngastana/data/mariadb
	sudo mkdir -p /home/ngastana/data/wordpress
	sudo chown -R $(whoami):$(whoami) /home/ngastana/data
	@echo "$(YELLOW)🚀 docker-compose up --build.... 🚀$(CLR_RMV)"
	for secret in $(SECRETS_PATHS); do \
		[ -f $$secret ] || touch $$secret; \
	done
	PWD=$(shell pwd) docker-compose -f srcs/docker-compose.yml up --build

build:
	docker-compose -f srcs/docker-compose.yml build --no-cache

up:
	docker-compose -f srcs/docker-compose.yml up -d

down:
	docker-compose -f srcs/docker-compose.yml down

ps:
	docker-compose -f srcs/docker-compose.yml ps

logs:
	docker-compose -f srcs/docker-compose.yml logs -f

clean:
	@echo "$(YELLOW)🧹 Limpiando entorno de INCEPTION...$(CLR_RMV)"
	@docker-compose -f srcs/docker-compose.yml down -v || true
	@docker system prune -af --volumes
	@echo "$(BLUE)🧼 Eliminando datos persistentes...$(CLR_RMV)"
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


re: fclean build up

.PHONY: all clean fclean re
