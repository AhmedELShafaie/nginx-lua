#!/bin/bash
# shellcheck disable=SC1091

source supported_versions

function init_dockerfile() {
    DOCKERFILE_PATH="nginx/$NGINX_VER/$OS/$OS_VER"
    DOCKERFILE="$DOCKERFILE_PATH/Dockerfile"

    mkdir -p "$DOCKERFILE_PATH" 2> /dev/null
    cp "tpl/Dockerfile.$OS" "$DOCKERFILE"

    if [ "$(uname)" == "Darwin" ]; then
        sed -i "" "s/{{DOCKER_IMAGE}}/fabiocicerchia\/nginx-lua/" "$DOCKERFILE"
        sed -i "" "s/{{DOCKER_IMAGE_OS}}/$OS/"                    "$DOCKERFILE"
        sed -i "" "s/{{DOCKER_IMAGE_TAG}}/$OS_VER/"               "$DOCKERFILE"
        sed -i "" "s/{{VER_NGINX}}/$NGINX_VER/"                   "$DOCKERFILE"
    else
        sed -i "s/{{DOCKER_IMAGE}}/fabiocicerchia\/nginx-lua/" "$DOCKERFILE"
        sed -i "s/{{DOCKER_IMAGE_OS}}/$OS/"                    "$DOCKERFILE"
        sed -i "s/{{DOCKER_IMAGE_TAG}}/$OS_VER/"               "$DOCKERFILE"
        sed -i "s/{{VER_NGINX}}/$NGINX_VER/"                   "$DOCKERFILE"
    fi
}

set -eux

for NGINX_VER in "${NGINX[@]}"; do

    OS=alpine
    for OS_VER in "${ALPINE[@]}"; do init_dockerfile; done
    rm ./Dockerfile
    ln -s "nginx/$NGINX_VER/alpine/$OS_VER/Dockerfile" ./Dockerfile

    OS=amazonlinux
    for OS_VER in "${AMAZONLINUX[@]}"; do init_dockerfile; done

    OS=centos
    for OS_VER in "${CENTOS[@]}"; do init_dockerfile; done

    OS=debian
    for OS_VER in "${DEBIAN[@]}"; do init_dockerfile; done

    OS=fedora
    for OS_VER in "${FEDORA[@]}"; do init_dockerfile; done

    OS=ubuntu
    for OS_VER in "${UBUNTU[@]}"; do init_dockerfile; done

done
