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
	docker-compose -f srcs/docker-compose.yml  up -d --build

build:
	docker compose -f srcs/docker-compose.yml build --no-cache

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

ps:
	docker compose -f srcs/docker-compose.yml ps

logs:
	docker compose -f srcs/docker-compose.yml logs -fclean

clean: down
	docker system prune -af --volumes

re: clean build up

.PHONY: all clean fclean re

                                                                                   