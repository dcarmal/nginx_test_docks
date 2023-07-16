#!/bin/bash
#
# Title: environment_up.sh
# Author: David C.
# Date: 15.07.2023
# Description: This script sets up a docker environment
#
# Checking settings file presence, if not found, error exit
if ! test -f "./Configs/settings.env"; then
    echo "The file Configs/settings.env does not exist"
    exit 1
fi
# Showing settings
echo "Initializing with the contents of the file Configs/settings.env:"
cat ./Configs/settings.env
echo ""
# Checking dockerfile presence and reporting it
DOCKERFILE_EXISTS=false
for file in Configs/Dockerfile*; do
    if test -f "$file"; then
        DOCKERFILE_EXISTS=true
        echo "Using Dockerfile: $file"
    fi
done
# If there's no dockerfile, error exit
if ! $DOCKERFILE_EXISTS; then
    echo "No Dockerfile exists in the Configs directory"
    exit 1
fi
# Using settings file
source ./Configs/settings.env
if [ -z "$NGINX_\*" ] || [ -z "$NGINX_PORT" ] || [ -z "$\*_SUBNET" ]; then
    echo "Required environment variables are missing in the file Configs/settings.env"
    exit 1
fi
# Launching containers and capturing output in log
docker-compose --env-file Configs/settings.env up -d 2>&1 | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' | tee docker-compose.log
# If an error is logged, warn the user and error exit
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "An error occurred while executing docker-compose. See \"docker-compose.log\" for details." 1>&2
    exit 1
else
  # If docker-compose is successfully executed then docker inspect is
  echo ""
  echo "Environment up:"
  docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq -f "name=web_dock_")
  echo ""
fi
# End of script