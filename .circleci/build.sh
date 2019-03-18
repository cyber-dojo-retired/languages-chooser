#!/bin/bash
set -ev

readonly GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
readonly CREATE_IMAGE_SCRIPT=cyber_dojo_start_points_create.sh
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo-languages.XXXXXXXXX)

cleanup() { rm -rf ${TMP_DIR} > /dev/null; }
trap cleanup EXIT

cd ${TMP_DIR}
curl -O --silent "${GITHUB_ORG}/starter-base/master/${CREATE_IMAGE_SCRIPT}"
chmod 700 ./${CREATE_IMAGE_SCRIPT}

./${CREATE_IMAGE_SCRIPT} \
    cyberdojo/languages \
      --languages \
        "$(curl --silent "${GITHUB_ORG}/languages/master/url_list/all")"

./${CREATE_IMAGE_SCRIPT} \
    cyberdojo/languages-common \
      --languages \
        "$(curl --silent "${GITHUB_ORG}/languages/master/url_list/common")"
