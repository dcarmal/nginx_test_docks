#!/bin/bash
#
# Title: environment_down.sh
# Author: David C.
# Date: 15.07.2023
# Description: This script removes IP addresses from the network interface and runs docker-compose down.
#
if ! test -f "./Configs/settings.env"; then
    echo "The file Configs/settings.env does not exist"
    exit 1
fi

echo "Initializing with the contents of the file Configs/settings.env:"
cat ./Configs/settings.env
echo ""

source ./Configs/settings.env

if [ -z "$INTERFACE" ] || [ -z "$NGINX_PORT" ] || [ -z "$\*_SUBNET" ]; then
    echo "Required environment variables are missing in the file Configs/settings.env"
    exit 1
fi

sudo ip addr del $NET1_SUBNET dev $INTERFACE
sudo ip addr del $NET2_SUBNET dev $INTERFACE
docker-compose --env-file Configs/settings.env down