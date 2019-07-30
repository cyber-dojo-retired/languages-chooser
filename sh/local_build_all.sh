#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SHA_VALUE=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

readonly GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
readonly LANGUAGES_LIST="${GITHUB_ORG}/languages/master/url_list"

SHA="${SHA_VALUE}" \
  ${ROOT_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/languages-all \
      --languages \
        $(curl --silent --fail "${LANGUAGES_LIST}/all")

SHA="${SHA_VALUE}" \
  ${ROOT_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/languages-common \
      --languages \
        $(curl --silent --fail "${LANGUAGES_LIST}/common")

SHA="${SHA_VALUE}" \
  ${ROOT_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/languages-small \
      --languages \
        $(curl --silent --fail "${LANGUAGES_LIST}/small")
