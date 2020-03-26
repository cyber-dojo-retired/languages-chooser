#!/bin/bash -Eeu

readonly SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/sh" && pwd)"
source "${SH_DIR}/versioner_env_vars.sh"
export $(versioner_env_vars)
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
  curl_json_body_200  alive
  curl_json_body_200  ready
  curl_json_body_200  sha
  echo
  curl_200            assets/app.css 'Content-Type: text/css'
  echo
  curl_200            group_choose our "$(url_exercise_param)"
  curl_url_params_302 group_create "$(url_exercise_param)" "$(url_languages_param)"
  echo
  curl_200            kata_choose  my "$(url_exercise_param)"
  curl_url_params_302 kata_create  "$(url_exercise_param)" "$(url_language_param)"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r route="${1}" # eg ready
  curl  \
    --data '' \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "$(log_filename)")
  echo "$(tab)GET ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_200()
{
  local -r route="${1}"        # eg group_choose
  local -r pattern="${2}"      # eg exercise
  local -r url_params="${3:-}" # eg "exercise_name=Fizz Buzz"
  curl  \
    --data-urlencode "${url_params}" \
    --fail \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(grep "${pattern}" "$(log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_url_params_302()
{
  local -r route="${1}"          # eg group_create
  local -r exercise_param="${2}" # eg "exercise_name":"Fizz Buzz"
  local -r language_param="${3}" # eg "languages_names":["Java, JUnit"]
  curl  \
    --data-urlencode "${exercise_param}" \
    --data-urlencode "${language_param}" \
    --fail \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 302 "$(log_filename)" # eg HTTP/1.1 302 Moved Temporarily
  local -r result=$(grep Location "$(log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 302 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_LANGUAGES_CHOOSER_PORT}"; }

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
