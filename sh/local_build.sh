#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SHA_VALUE=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

SHA="${SHA_VALUE}" \
  ${ROOT_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/languages-small \
      --languages \
        file://${ROOT_DIR}/../../cyber-dojo-languages/gcc-assert      \
        file://${ROOT_DIR}/../../cyber-dojo-languages/python-unittest \
        file://${ROOT_DIR}/../../cyber-dojo-languages/ruby-minitest
