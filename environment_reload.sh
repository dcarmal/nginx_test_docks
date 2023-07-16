#!/bin/bash
# -
# Title: environment_reload.sh
# Author: David C.
# Date: 16.07.2023
# Description: This script restarts a docker environment
# -
#

# Obtener los nombres de los contenedores que comienzan con "web_dock_"
container_names=$(docker ps --format '{{.Names}}' --filter 'name=web_dock_*')

# Reiniciar los contenedores
for container_name in $container_names
do
  echo "Restarting container:"
  docker restart "$container_name"
done