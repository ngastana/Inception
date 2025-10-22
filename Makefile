NAME = INCEPTION

CLR_RMV		:= \033[0m
RED		    := \033[1;31m
GREEN		:= \033[1;32m
YELLOW		:= \033[1;33m
BLUE		:= \033[1;34m
CYAN 		:= \033[1;36m


define	ART
$(RED)

░██████░███    ░██   ░██████  ░██████████ ░█████████  ░██████████░██████  ░██████   ░███    ░██ 
  ░██  ░████   ░██  ░██   ░██ ░██         ░██     ░██     ░██      ░██   ░██   ░██  ░████   ░██ 
  ░██  ░██░██  ░██ ░██        ░██         ░██     ░██     ░██      ░██  ░██     ░██ ░██░██  ░██ 
  ░██  ░██ ░██ ░██ ░██        ░█████████  ░█████████      ░██      ░██  ░██     ░██ ░██ ░██ ░██ 
  ░██  ░██  ░██░██ ░██        ░██         ░██             ░██      ░██  ░██     ░██ ░██  ░██░██ 
  ░██  ░██   ░████  ░██   ░██ ░██         ░██             ░██      ░██   ░██   ░██  ░██   ░████ 
░██████░██    ░███   ░██████  ░██████████ ░██             ░██    ░██████  ░██████   ░██    ░███ 
                                                                                                
                                                                                                
 $(CLR_RMV)
endef
export	ART

all:
	@echo "$$ART"
	mkdir -p srcs/requirements/mariadb/data
	mkdir -p srcs/requirements/wordpress/data
	sudo chown -R $(USER):$(USER) srcs/requirements/mariadb/data
	sudo chown -R $(USER):$(USER) srcs/requirements/wordpress/data
	docker-compose -f srcs/docker-compose.yml up --build

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

clean: down
	@echo "$(YELLOW)🧹 Limpiando entorno de INCEPTION...$(CLR_RMV)"
	docker compose srcs/docker-compose.yml down -v || true
	docker system prune -af --volumes
	docker volume rm srcs_WP_Volume
	docker volume rm srcs_DB_Volume
	sudo chown -R $(USER):$(USER) srcs/requirements/mariadb/data
	sudo chown -R $(USER):$(USER) srcs/requirements/wordpress/data
	sudo rm -rf srcs/requirements/mariadb/data/* 
	sudo rm -rf srcs/requirements/wordpress/data/*

re: clean build up

.PHONY: all clean fclean re
