#!/bin/bash
#
# Title: environment_up.sh
# Author: David C.
# Date: 15.07.2023
# Description: This script sets up a docker environment
#
if ! test -f "./Configs/settings.env"; then
    echo "The file Configs/settings.env does not exist"
    exit 1
fi

echo "Initializing with the contents of the file Configs/settings.env:"
cat ./Configs/settings.env
echo ""

DOCKERFILE_EXISTS=false
for file in Configs/Dockerfile*; do
    if test -f "$file"; then
        DOCKERFILE_EXISTS=true
        echo "Using Dockerfile: $file"
    fi
done

if ! $DOCKERFILE_EXISTS; then
    echo "No Dockerfile exists in the Configs directory"
    exit 1
fi

source ./Configs/settings.env

if [ -z "$INTERFACE" ] || [ -z "$NGINX_PORT" ] || [ -z "$\*_SUBNET" ]; then
    echo "Required environment variables are missing in the file Configs/settings.env"
    exit 1
fi

sudo ip addr add $NET1_SUBNET dev $INTERFACE
sudo ip addr add $NET2_SUBNET dev $INTERFACE
docker-compose --env-file Configs/settings.env up -d