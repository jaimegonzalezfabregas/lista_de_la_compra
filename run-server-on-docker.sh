#!/bin/sh

build(){
    sudo docker build . --progress=plain -t lista_de_la_compra_server
}

run(){
    sudo docker run --name lista_de_la_compra_server -p 4545:4545 lista_de_la_compra_server
}

build && run
