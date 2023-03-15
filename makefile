# Set default no argument goal to help
.DEFAULT_GOAL := help

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Setup variables
#
# -> Project variables
PROJECT_NAME?=$(shell cat .env | grep -v ^\# | grep COMPOSE_PROJECT_NAME | sed 's/.*=//')

# -> App variables
APP_BASEURL?=$(shell cat .env | grep VIRTUAL_HOST | sed 's/.*=//')

# Every command is a PHONY, to avoid file naming confliction -> strengh comes from good habits!
.PHONY: help
help:
	@echo "=================================================================================="
	@echo "                          ENSG SDI with docker"
	@echo "             https://github.com/VincentHeau/ensg-local-sdi"
	@echo " "
	@echo " /!\ It's meant to be deployed behind a HTTPS reverse proxy "
	@echo " "
	@echo " Few hints:"
	@echo "  make build            # Checks that everythings's OK then builds the stack"
	@echo "  make up               # With working proxy, brings up the software stack"
	@echo "  make update           # Update the whole stack"
	@echo "  make hard-cleanup     # /!\ Remove images, containers, networks, volumes & data"
	@echo "  make postinstall      # If at ENSG local station lab, activates projet host file"
	@echo "=================================================================================="

.PHONY: build
build:
	docker compose build

.PHONY: up
up: build
	@echo "[INFO] Bringing up the stack"
	docker compose up -d --remove-orphans
	@echo "[WARNING] If at ENSG local station lab, please activate projet host file with -> # make set-hosts"

.PHONY: hard-cleanup
hard-cleanup:
	@echo "[INFO] Bringing done the HTTPS automated proxy"
	docker compose -f docker-compose.yml down --remove-orphans
	# Delete all hosted persistent data available in volumes
	@echo "[INFO] Cleaning up static volumes"
	docker volume rm -f $(PROJECT_NAME)_nginx_vhosts
	docker volume rm -f $(PROJECT_NAME)_nginx_html
	docker volume rm -f $(PROJECT_NAME)_geoserver_data
	docker volume rm -f $(PROJECT_NAME)_mapstore_data
	docker volume rm -f $(PROJECT_NAME)_postgis_data
	docker volume rm -f $(PROJECT_NAME)_pgadmin_data
	docker volume rm -f $(PROJECT_NAME)_pgbackups
	docker volume rm -f $(PROJECT_NAME)_mviewer-base
	docker volume rm -f $(PROJECT_NAME)_geoserver_fonts
	@echo "[INFO] Cleaning up containers & images"
	docker system prune -a

.PHONY: pull
pull: 
	docker compose pull

.PHONY: update
update: pull up wait
	docker image prune

.PHONY: wait
wait: 
	sleep 5
