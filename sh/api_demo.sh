#!/bin/bash -Eeu

readonly SH_DIR="$(cd "$(dirname "${0}")" && pwd)"
source "${SH_DIR}/versioner_env_vars.sh" # for build-image
export $(versioner_env_vars)
source "${SH_DIR}/ip_address.sh" # slow
readonly IP_ADDRESS="$(ip_address)"

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
main()
{
  "${SH_DIR}/build_images.sh"
  "${SH_DIR}/containers_up.sh" api-demo
  echo
  demo
  echo
  if [ "${1:-}" == '--no-browser' ]; then
    "${SH_DIR}/containers_down.sh"
  else
    open "http://${IP_ADDRESS}:80/languages-chooser/group_choose"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo()
{
  echo API
  curl_json_body_200 GET  alive
  curl_json_body_200 GET  ready
  curl_json_body_200 GET  sha
  echo
  curl_200           GET  assets/app.css 'Content-Type: text/css'
  echo
  curl_200           GET  language_choose  exercise
  #curl_params_302    GET  group_create "$(params_display_names)"
  #curl_json_body_200 POST group_create "$(json_display_names)"
  echo
  curl_200           GET  language_choose   exercise
  #curl_params_302    GET  kata_create  "$(params_display_name)"
  #curl_json_body_200 POST kata_create  "$(json_display_name)"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r log=/tmp/creator.log
  local -r type="${1}"   # eg GET|POST
  local -r route="${2}"  # eg create_group
  local -r json="${3:-}" # eg '{"display_name":"Java Countdown, Round 1"}'
  curl  \
    --data "${json}" \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "${log}" 2>&1

    grep --quiet 200 "${log}"             # eg HTTP/1.1 200 OK
    local -r result=$(tail -n 1 "${log}") # eg {"sha":"78c19640aa43ea214da17d0bcb16abbd420d7642"}
    echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_params_302()
{
  local -r log=/tmp/creator.log
  local -r type="${1}"     # eg GET|POST
  local -r route="${2}"    # eg create_kata
  local -r params="${3:-}" # eg "display_name=Java Countdown, Round 1"
  curl  \
    --data-urlencode "${params}" \
    --fail \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "${log}" 2>&1

    grep --quiet 302 "${log}"                 # eg HTTP/1.1 302 Moved Temporarily
    local -r result=$(grep Location "${log}") # Location: http://192.168.99.100:4536/kata/edit/5B65RC
    echo "$(tab)${type} ${route} => 302 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_200()
{
  local -r log=/tmp/creator.log
  local -r type="${1}"    # eg GET|POST
  local -r route="${2}"   # eg index_kata
  local -r pattern="${3}" # eg session
  curl  \
    --fail \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "${log}" 2>&1

    grep --quiet 200 "${log}" # eg HTTP/1.1 200 OK
    local -r result=$(grep "${pattern}" "${log}")
    echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_LANGUAGES_CHOOSER_PORT}"; }
json_display_names()   { echo -n "{\"display_names\":[\"$(display_name)\"]}"; }
params_display_names() { params display_names[] "$(display_name)"; }
json_display_name()    { json   display_name "$(display_name)"; }
params_display_name()  { params display_name "$(display_name)"; }
json() { echo -n "{\"${1}\":\"${2}\"}"; }
params() { echo -n "${1}=${2}"; }
display_name() { echo -n 'C (gcc), assert'; }
tab() { printf '\t'; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
main "${1:-}"
