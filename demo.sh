#!/bin/bash -Eeu

readonly SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/sh" && pwd)"
source "${SH_DIR}/build_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up.sh"
source "${SH_DIR}/ip_address.sh"

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo()
{
  build_images
  containers_up api-demo
  echo
  demo
  echo
  if [ "${1:-}" == '--no-browser' ]; then
    containers_down
  else
    open "http://${IP_ADDRESS}:80/languages-chooser/group_choose?exercise_name=$(exercise_name)"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo()
{
  echo API
  curl_json_body_200  GET  alive
  curl_json_body_200  GET  ready
  curl_json_body_200  GET  sha
  echo
  curl_200            GET  assets/app.css 'Content-Type: text/css'
  echo
  curl_200            GET  group_choose  exercise "$(url_params)"
  #curl_url_params_302 GET  group_create "$(url_params)"
  #curl_json_body_200  POST group_create "$(json_body)"
  echo
  curl_200            GET  kata_choose   exercise "$(url_params)"
  #curl_url_params_302 GET  kata_create  "$(url_params)"
  #curl_json_body_200  POST kata_create  "$(json_body)"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r type="${1}"    # eg GET|POST
  local -r route="${2}"   # eg group_create
  local -r json="${3:-}"  # eg '{"exercise_name":"Fizz Buzz"}'
  curl  \
    --data "${json}" \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "$(log_filename)")
  echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_url_params_302()
{
  local -r type="${1}"       # eg GET
  local -r route="${2}"      # eg group_create
  local -r url_params="${3}" # eg "exercise_name=Fizz Buzz"
  curl  \
    --data-urlencode "${url_params}" \
    --fail \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 302 "$(log_filename)" # eg HTTP/1.1 302 Moved Temporarily
  local -r result=$(grep Location "$(log_filename)" | head -n 1)
  echo "$(tab)${type} ${route} => 302 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_200()
{
  local -r type="${1}"         # eg GET
  local -r route="${2}"        # eg group_choose
  local -r pattern="${3}"      # eg exercise
  local -r url_params="${4:-}" # eg "exercise_name=Fizz Buzz"
  curl  \
    --data-urlencode "${url_params}" \
    --fail \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(grep "${pattern}" "$(log_filename)" | head -n 1)
  echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_LANGUAGES_CHOOSER_PORT}"; }
json_body() { json exercise_name "$(exercise_name)"; }
url_params() { url_param exercise_name "$(exercise_name)"; }
json() { echo -n "{\"${1}\":\"${2}\"}"; }
url_param() { echo -n "${1}=${2}"; }
exercise_name() { echo -n 'Fizz Buzz'; }
tab() { printf '\t'; }
log_filename() { echo -n /tmp/languages-chooser.log ; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo "$@"
