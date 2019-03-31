#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

${MY_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/languages-small \
      --languages \
        file://${MY_DIR}/../../cyber-dojo-languages/gcc-assert      \
        file://${MY_DIR}/../../cyber-dojo-languages/python-unittest \
        file://${MY_DIR}/../../cyber-dojo-languages/ruby-minitest
