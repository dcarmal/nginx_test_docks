#!/bin/bash
#
# Title: environment_down.sh
# Author: David C.
# Date: 15.07.2023
# Description: This script checks env variables and runs docker-compose down.
#
if ! test -f "./Docker_configs/settings.env"; then
    echo "The file Docker_configs/settings.env does not exist"
    exit 1
fi

echo "Initializing with the contents of the file Docker_configs/settings.env:"
cat ./Docker_configs/settings.env
echo ""

source ./Docker_configs/settings.env

if [ -z "$NGINX_\*" ] || [ -z "$NGINX_PORT" ] || [ -z "$\*_SUBNET" ]; then
    echo "Required environment variables are missing in the file Docker_configs/settings.env"
    exit 1
fi

docker-compose --env-file Docker_configs/settings.env down