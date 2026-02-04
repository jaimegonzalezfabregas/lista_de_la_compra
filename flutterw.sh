#!/bin/bash

set -e
set -x

BUILDCACHE=./.build-container-cache
IMAGE=lista-de-la-compra-builder
DOCKERFILE=./docker/Dockerfile-builder


detect_container(){

    if [ "$DOCKER" != "" ]
    then
        return 0
    elif command -v podman > /dev/null 2>&1
    then
        DOCKER=podman
    elif command -v docker > /dev/null 2>&1
    then     
        DOCKER=docker
    else
        echo "Error: no container manager detected (like 'docker' or 'podman'), please define DOCKER variable"
        exit 2
    fi
}

clean_build_cache(){
  if [ -d $BUILDCACHE ]; then  rm -r $BUILDCACHE; fi
  if [ -d .dart_tool ]; then  rm -r .dart_tool; fi
  if [ -d build ]; then  rm -r build; fi
  $DOCKER builder prune
}

build_image(){
    local USERMAPING
    if [ $DOCKER = 'docker' ]
    then
        USERMAPING="--build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)"
    fi 
    $DOCKER build $USERMAPING -t $IMAGE -f $DOCKERFILE .
}

graphic_options(){

    is_x11(){
        [ "$XDG_SESSION_TYPE" = "x11" ] || [ "$DISPLAY" != "" ]
    }

    is_wayland(){
        [ "$XDG_SESSION_TYPE" = "wayland" ] || [ "$WAYLAND_DISPLAY" != "" ]
    }
    
    # DISPLAY IS ALSO DEFINED IN WAYLAND, SO TEST WAYLAND FIRST
    if is_wayland
    then
        echo "--env=XDG_RUNTIME_DIR=/run/user/$(id -u) --volume=/run/user/$(id -u)/$WAYLAND_DISPLAY:/run/user/$(id -u)/$WAYLAND_DISPLAY --group-add=video"
    elif is_x11
    then
        echo "--env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix --security-opt=label=disable"
    else
        echo "WARNING: no graphic environment" 1>&2
    fi
}

spi_options(){
    if [ -e /run/user/$(id -u)/at-spi/bus_0 ]
    then
      printf " %s " "--env AT_SPI_BUS=/run/user/$(id -u)/at-spi/bus_0"
    fi

    if [ -e /run/user/$(id -u)/at-spi ]
     then
      printf " %s " "--volume=/run/user/$(id -u)/at-spi:/run/user/$(id -u)/at-spi"
    fi
    if [ -e /dev/dri ]
    then
      printf " %s " "--device /dev/dri"
    fi
}

docker_options(){
    if [ "$DOCKER" = "podman" ]
    then
        #printf " %s " "--userns=keep-id"
        printf ""
    else
        printf " %s " "--user $(id -u):$(id -g)"
    fi
}

exec_in_container(){
    local SPIOPTIONS=$(spi_options)
    local GRAPHICOPTIONS=$(graphic_options)
    local DOCKEROPTIONS=$(docker_options)
    mkdir -p $BUILDCACHE

    $DOCKER run \
            -it \
            --init \
            --rm \
            $DOCKEROPTIONS \
            $GRAPHICOPTIONS \
            $SPIOPTIONS \
            -p ${WEBPORT:-8081}:8081 \
            -v $BUILDCACHE:/cache:z \
            -v .:/app:z \
            -e FLUTTER_FLAVOR=prod \
            $IMAGE \
            "$@"
}

main(){
    detect_container

    if [ "$1" = "--build" ]; then
        build_image
        return $?
    elif [ "$1" = "--cleancache" ]; then
        clean_build_cache
        return $?
    elif [ "$1" = "--exec" ]; then
        exec_in_container ${@:2}
        return $?
    else
        exec_in_container flutter ${@:1}
        return $?
    fi    

    echo "Usage: $0 {--build|--cleancache|--exec <command>| <flutter args>}"
    return 1
}

main "$@"
