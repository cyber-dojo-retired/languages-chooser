#!/bin/bash
set -e

# Use this when you need to recreate the cyberdojo/languages:latest
# image locally. Eg after making a local change to starter-base
# you cannot update versioner to its new BASE_SHA because
# there is a versioner test that checks the languages image named
# in the .env file has a matching BASE_SHA env-var.
# ./local_build_all.sh
# SHA=$(docker run --rm cyberdojo/languages:latest sh -c 'echo $SHA')
# TAG=${SHA:0:7}
# docker tag cyberdojo/languages:latest cyberdojo/languages:${TAG}
# docker push cyberdojo/languages:latest
# docker push cyberdojo/languages:${TAG}
#
# and now you can update versioner's .env to
# CYBER_DOJO_LANGUAGES=cyberdojo/languages-common:${TAG}

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
