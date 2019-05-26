#!/bin/bash
set -ev

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SHA_VALUE=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

readonly GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
readonly REPO_NAME=commander

readonly SCRIPT_NAME=cyber-dojo
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo-languages.XXXXXXXXX)

cleanup() { rm -rf ${TMP_DIR} > /dev/null; }
trap cleanup EXIT

cd ${TMP_DIR}
curl -O --silent "${GITHUB_ORG}/${REPO_NAME}/master/${SCRIPT_NAME}"
chmod 700 ./${SCRIPT_NAME}

SHA="${SHA_VALUE}" \
  ./${SCRIPT_NAME} start-point create \
    cyberdojo/languages \
      --languages \
        $(curl --silent "${GITHUB_ORG}/languages/master/url_list/all")

SHA="${SHA_VALUE}" \
  ./${SCRIPT_NAME} start-point create \
    cyberdojo/languages-common \
      --languages \
        $(curl --silent "${GITHUB_ORG}/languages/master/url_list/common")

SHA="${SHA_VALUE}" \
  ./${SCRIPT_NAME} start-point create \
    cyberdojo/languages-small \
      --languages \
        $(curl --silent "${GITHUB_ORG}/languages/master/url_list/small")
