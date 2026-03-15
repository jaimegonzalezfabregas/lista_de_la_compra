#!/bin/sh

# TODO: Create Makefile
# TODO: Use docker or podman
# TODO: Move dockerfile and this build script to ./packages/lista_de_la_compra_server/

build(){
    sudo docker build . --progress=plain -t lista_de_la_compra_server -f ./docker/Dockerfile-server 
}

run(){
    sudo docker run --name lista_de_la_compra_server -p 4545:4545 lista_de_la_compra_server
}

build && run
