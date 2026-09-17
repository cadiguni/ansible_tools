SHELL := /bin/bash
INVENTORY ?= inventory/local.yml
PLAYBOOK ?= playbooks/workstation.yml
TAGS ?=
EXTRA ?=

TAG_ARG := $(if $(TAGS),--tags $(TAGS),)

.PHONY: help deps lint syntax check workstation server update bootstrap

help: ## Mostra os alvos disponiveis
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

deps: ## Instala as collections necessarias
	ansible-galaxy collection install -r requirements.yml

lint: ## Roda yamllint e ansible-lint
	yamllint .
	ansible-lint

syntax: ## Valida a sintaxe dos playbooks
	ansible-playbook -i $(INVENTORY) playbooks/workstation.yml --syntax-check
	ansible-playbook -i $(INVENTORY) playbooks/server.yml --syntax-check
	ansible-playbook -i $(INVENTORY) playbooks/bootstrap.yml --syntax-check
	ansible-playbook -i $(INVENTORY) playbooks/update.yml --syntax-check

check: ## Dry-run do playbook de workstation
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK) --check --diff --ask-become-pass $(TAG_ARG) $(EXTRA)

bootstrap: ## Instala Ansible/Git/unzip na maquina
	ansible-playbook -i $(INVENTORY) playbooks/bootstrap.yml --ask-become-pass

workstation: ## Aplica o playbook de workstation
	ansible-playbook -i $(INVENTORY) playbooks/workstation.yml --ask-become-pass $(TAG_ARG) $(EXTRA)

server: ## Aplica o playbook de servidor (use INVENTORY=inventory/servers.yml)
	ansible-playbook -i $(INVENTORY) playbooks/server.yml $(TAG_ARG) $(EXTRA)

update: ## Atualiza os pacotes dos hosts do inventario
	ansible-playbook -i $(INVENTORY) playbooks/update.yml --ask-become-pass $(EXTRA)
