#!/bin/bash

set -e

build_db_instance_images(){
    echo "***************** Build and upload db instance images ****************"
    make packer-build-master
    IMAGE_NAME='slave-db-01' make packer-build-slave
    IMAGE_NAME='slave-db-02' make packer-build-slave
}

build_haproxy_lb_instance_images(){
    echo "***************** Build and upload haproxy instance image ****************"
    make packer-build-haproxy
}

setup_infrastructure(){
    echo "***************** Orchestrate infrastructure ****************"
    cd infrastructure
    terraform init
    terraform apply -auto-approve
}

main() {
    build_db_instance_images
    build_haproxy_lb_instance_images
    setup_infrastructure
}

main
