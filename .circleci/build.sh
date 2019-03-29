#!/bin/bash
set -ev

readonly GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
readonly SCRIPT_NAME=cyber_dojo_start_points_create.sh
#readonly SCRIPT_NAME=cyber-dojo
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo-languages.XXXXXXXXX)

cleanup() { rm -rf ${TMP_DIR} > /dev/null; }
trap cleanup EXIT

cd ${TMP_DIR}
curl -O --silent "${GITHUB_ORG}/starter-base/master/${SCRIPT_NAME}"
#curl -O --silent "${GITHUB_ORG}/commander/master/${SCRIPT_NAME}"
chmod 700 ./${SCRIPT_NAME}

./${SCRIPT_NAME} start-point create \
    cyberdojo/languages \
      --languages \
        "$(curl --silent "${GITHUB_ORG}/languages/master/url_list/all")"

./${SCRIPT_NAME} start-point create \
    cyberdojo/languages-common \
      --languages \
        "$(curl --silent "${GITHUB_ORG}/languages/master/url_list/common")"
