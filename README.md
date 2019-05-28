
<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

[![CircleCI](https://circleci.com/gh/cyber-dojo/languages.svg?style=svg)](https://circleci.com/gh/cyber-dojo/languages)

Specifies the start-points used to create the following start-point images
* [cyberdojo/languages-all](https://hub.docker.com/r/cyberdojo/languages-all)
* [cyberdojo/languages-common](https://hub.docker.com/r/cyberdojo/languages-common)
* [cyberdojo/languages-small](https://hub.docker.com/r/cyberdojo/languages-small)

```bash
$ set -e
$ GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
$ LANGUAGES_LIST="${GITHUB_ORG}/languages/master/url_list"
$ curl --silent --fail "${GITHUB_ORG}/commander/master/cyber-dojo" -o cyber-dojo
$ chmod 700 cyber-dojo
$
$ IMAGE_NAME=cyberdojo/languages-all
$ ./cyber-dojo start-point create \
     "${IMAGE_NAME}" \
        --languages \
          $(curl --silent --fail "${LANGUAGES_LIST}/all")
$
$ IMAGE_NAME=cyberdojo/languages-common
$ ./cyber-dojo start-point create \
     "${IMAGE_NAME}"\
        --languages \
          $(curl --silent --fail "${LANGUAGES_LIST}/common")
$
$ IMAGE_NAME=cyberdojo/languages-small
$ ./cyber-dojo start-point create \
     "${IMAGE_NAME}" \
        --languages \
          $(curl --silent --fail "${LANGUAGES_LIST}/small")
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to https://cyber-dojo.org](https://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
