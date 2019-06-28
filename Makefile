SHELL=/bin/bash
CYAN=\\033[0;36m
NC=\\033[0m

# Packer image provisioning
packer-build-haproxy: ## Build haproxy db image.
	packer validate images/haproxy-lb/packer.json
	packer build images/haproxy-lb/packer.json
packer-build-master: ## Build master db image.
	packer validate images/master-db/packer.json
	packer build images/master-db/packer.json
packer-build-slave: ## Build slave db image.
	packer validate images/slave-db/packer.json
	packer build images/slave-db/packer.json
