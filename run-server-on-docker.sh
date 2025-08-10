#!/bin/sh

build(){
    sudo docker build . --progress=plain -t lista_de_la_compra_server
}

run(){
    sudo docker run -it -p 4545:4545 lista_de_la_compra_server
}

build && run
