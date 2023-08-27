# === Makefile Helper ===

# Styles
YELLOW=$(shell echo "\033[00;33m")
RED=$(shell echo "\033[00;31m")
RESTORE=$(shell echo "\033[0m")


# Variables
UNAME_S := $(shell uname -s)
PHP_BIN := php
COMPOSER := composer
CURRENT_DIR := $(shell pwd)
SYMFONY := symfony
EZ_DIR := $(CURRENT_DIR)/ibexa
DOCKER := docker
CONSOLE := $(PHP_BIN) bin/console
IBEXA_VERSION ?= 4.*

.DEFAULT_GOAL := list

.PHONY: list
list:
	@echo "******************************"
	@echo "${YELLOW}Available targets${RESTORE}:"
	@grep -E '^[a-zA-Z-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf " ${YELLOW}%-15s${RESTORE} > %s\n", $$1, $$2}'
	@echo "${RED}==============================${RESTORE}"


.PHONY: installibexa
installibexa: ## Install Ibexa as the local project
	@ddev exec -d /var/www/html "$(COMPOSER) create-project 'ibexa/oss-skeleton:${IBEXA_VERSION}' --prefer-dist --no-progress --no-interaction ibexa"
	@echo "..:: Do Ibexa Install ::.."

	@ddev exec "$(CONSOLE) ibexa:install"
	@ddev exec "$(CONSOLE) ibexa:graphql:generate-schema"

.PHONY: documentation
documentation: ## Generate the documention
	@ddev exec "$(SYMFONY) run --watch src,documentation/templates,components  bin/releaser doc -n"

