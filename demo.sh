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
  curl_200            GET  group_choose  exercise "$(url_exercise_param)"
  curl_url_params_302 GET  group_create "$(url_exercise_param)" "$(url_languages_param)"
  #curl_json_body_200  POST group_create "{$(json_exercise_param),$(json_languages_param)}"
  echo
  curl_200            GET  kata_choose   exercise "$(url_exercise_param)"
  curl_url_params_302 GET  kata_create  "$(url_exercise_param)" "$(url_language_param)"
  #curl_json_body_200  POST kata_create  "{$(json_exercise_param)&$(json_language_param)}"
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
  local -r type="${1}"           # eg GET
  local -r route="${2}"          # eg group_create
  local -r exercise_param="${3}" # eg "exercise_name=Fizz Buzz"
  local -r language_param="${4}" # eg "languages_names[]=Java, JUnit"
  curl  \
    --data-urlencode "${exercise_param}" \
    --data-urlencode "${language_param}" \
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
json() { echo -n "{\"${1}\":\"${2}\"}"; }

#url_params() { echo "$(url_exercise_param)&$(url_languages_param)"; }
#url_param() { url_exercise_param; }
url_exercise_param()  { url_param exercise_name "$(exercise_name)"; }
url_languages_param() { url_param languages_names[] "$(language_name)"; }
url_language_param()  { url_param language_name "$(language_name)"; }
url_param() { echo -n "${1}=${2}"; }

exercise_name() { echo -n 'Fizz Buzz'; }
language_name() { echo -n 'Java, JUnit'; }

tab() { printf '\t'; }
log_filename() { echo -n /tmp/languages-chooser.log ; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo "$@"
