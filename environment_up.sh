#!/bin/bash
# -
# Title: environment_up.sh
# Author: David C.
# Date: 15.07.2023
# Description: This script sets up a docker environment
# Parameters:
#   -clearlogs: tries to find and delete log files specified in "log_files"
# -
#
# Variable section
#
# - Log files to clear
log_files=('./docker-compose.log' './NGINX_files/Logs/access.log' './NGINX_files/Logs/error.log')
#
# End of variable section
#
#
# Script start
#
# Checking settings file presence, if not found, error exit
if ! test -f "./Docker_configs/settings.env"; then
    echo "The file Docker_configs/settings.env does not exist"
    exit 1
fi

# Showing settings
echo "Initializing with the contents of the file Docker_configs/settings.env:"
cat ./Docker_configs/settings.env
echo ""

# Checking dockerfile presence and reporting it
DOCKERFILE_EXISTS=false
for file in Docker_configs/Dockerfile*; do
    if test -f "$file"; then
        DOCKERFILE_EXISTS=true
        echo "Using Dockerfile: $file"
    fi
done

# If there's no dockerfile, error exit
if ! $DOCKERFILE_EXISTS; then
    echo "No Dockerfile exists in the Docker_configs directory"
    exit 1
fi

# Using settings file
source ./Docker_configs/settings.env
if [ -z "$NGINX_\*" ] || [ -z "$NGINX_PORT" ] || [ -z "$\*_SUBNET" ]; then
    echo "Required environment variables are missing in the file Docker_configs/settings.env"
    exit 1
fi

# Parameter search
for arg in "$@"; do
# CLEARLOGS
    if [ "${arg}" = "-clearlogs" ]; then
        # Then log files found are cleared
        for file in "${log_files[@]}"; do
            if [[ -f ${file} ]]; then     # Verify its presence
                echo "Log file found: ${file}"
                rm ${file} && echo "Successfully deleted: ${file}" || echo "Failed deleting: ${file}"
            else
                echo "No encontrado: ${file}"
            fi 
        done
    fi
done

# Launching containers and capturing output in log
docker-compose --env-file Docker_configs/settings.env up -d 2>&1 | awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' | tee docker-compose.log

# If an error is logged, warn the user and error exit
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "An error occurred while executing docker-compose. See \"docker-compose.log\" for details." 1>&2
    exit 1
else
  # If docker-compose is successfully executed then docker inspect is
  echo ""
  echo "Environment up:"
  docker inspect -f '{{.Name}} - {{range $key, $value := .NetworkSettings.Networks}}{{$key}}: {{$value.IPAddress}} {{end}}{{println ""}}' $(docker ps -aq -f "name=web_dock_")
  echo ""
fi
#
# End of script