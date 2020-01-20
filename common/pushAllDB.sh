#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: buildAllDB.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.03.13
# Revision...:  
# Purpose....: Build script to build all trivadis/xxx docker images
# Notes......: 
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at http://oss.oracle.com/licenses/upl.
# -----------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# -----------------------------------------------------------------------------

# - Customization -----------------------------------------------------------
# - End of Customization ----------------------------------------------------

# - Default Values ----------------------------------------------------------
DOCKER_USER=${DOCKER_USER:-"trivadis"}
DOCKER_REPO=${DOCKER_REPO:-"ora_db"}
DOCKER_LOCAL_USER=${DOCKER_LOCAL_USER:-"oracle"}
DOCKER_LOCAL_REPO=${DOCKER_LOCAL_REPO:-"database"}

echo "--------------------------------------------------------------------------------"
echo " Process all ${DOCKER_LOCAL_USER}/${DOCKER_LOCAL_REPO}:* images ...."

ORACLE_IMAGES=$(docker images --filter=reference="${DOCKER_LOCAL_USER}/${DOCKER_LOCAL_REPO}:*" --format "{{.Repository}}:{{.Tag}}")

for i in ${ORACLE_IMAGES}; do
    version=$(echo $i|cut -d: -f2)
    echo " tag image ${DOCKER_LOCAL_USER}/${DOCKER_LOCAL_REPO}:$version"
    docker tag ${DOCKER_LOCAL_USER}/${DOCKER_LOCAL_REPO}:$version ${DOCKER_USER}/${DOCKER_REPO}:$version
    echo " push image ${DOCKER_USER}/${DOCKER_REPO}:$version"
    docker push ${DOCKER_USER}/${DOCKER_REPO}:$version
    echo " untag image ${DOCKER_USER}/${DOCKER_REPO}:$version"
    docker rmi ${DOCKER_USER}/${DOCKER_REPO}:$version
done
# --- EOF -------------------------------------------------------------------