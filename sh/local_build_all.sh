#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

readonly GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
readonly LANGUAGES_LIST="${GITHUB_ORG}/languages/master/url_list"

export SHA_VALUE=$(cd "${ROOT_DIR}" && git rev-parse HEAD)
export CYBER_DOJO_LANGUAGES_PORT=4534

${ROOT_DIR}/../commander/cyber-dojo start-point create \
  cyberdojo/languages-all \
    --languages \
      $(curl --silent --fail "${LANGUAGES_LIST}/all")

${ROOT_DIR}/../commander/cyber-dojo start-point create \
  cyberdojo/languages-common \
    --languages \
      $(curl --silent --fail "${LANGUAGES_LIST}/common")

${ROOT_DIR}/../commander/cyber-dojo start-point create \
  cyberdojo/languages-small \
    --languages \
      $(curl --silent --fail "${LANGUAGES_LIST}/small")
