
<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

[![CircleCI](https://circleci.com/gh/cyber-dojo/languages.svg?style=svg)](https://circleci.com/gh/cyber-dojo/languages)

Specifies the start-points used to create the
cyberdojo/languages-common and
cyberdojo/languages-all start-point images.

```bash
$ GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
$
$ curl --silent "${GITHUB_ORG}/commander/master/cyber-dojo" -o cyber-dojo
$ chmod 700 cyber-dojo
$
$ ./cyber-dojo start-point create \
    cyberdojo/languages-all \
      --languages \
        $(curl --silent "${GITHUB_ORG}/languages/master/url_list/all")
$
$ ./cyber-dojo start-point create \
    cyberdojo/languages-common \
      --languages \
        $(curl --silent "${GITHUB_ORG}/languages/master/url_list/common")

$ ./cyber-dojo up \
    --languages=cyberdojo/languages-common
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to https://cyber-dojo.org](https://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
