#!/bin/bash
# -
# Title: environment_reload.sh
# Author: David C.
# Date: 16.07.2023
# Description: This script restarts a docker environment
# Parameters:
#   -clearlogs: tries to find and delete log files specified in "log_files"
# -
#
# Variable section
#
# - Log files to clear
log_files=('./NGINX_files/Logs/access.log' './NGINX_files/Logs/error.log')
#
# End of variable section
#
#
# Script start
#
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
                echo "Not found: ${file}"
            fi 
        done
    fi
done
# Obtain containers starting with "web_dock_"
container_names=$(docker ps --format '{{.Names}}' --filter 'name=web_dock_*')

# Restart containers
for container_name in $container_names
do
  echo "Restarting container:"
  docker restart "$container_name"
done
#
# End of script