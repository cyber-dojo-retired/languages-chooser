
<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

Not live yet. Working towards making it live on https://beta.cyber-dojo.org
[![CircleCI](https://circleci.com/gh/cyber-dojo/languages.svg?style=svg)](https://circleci.com/gh/cyber-dojo/languages)

Specifies the start-points used to create the cyberdojo/languages Docker image.

```bash
$ FILENAME=languages_list_all
$ URL=https://raw.githubusercontent.com/cyber-dojo/languages/master/${FILENAME}
$ curl -O ${URL}
$ LANGUAGES_URLS="$(< ./${FILENAME})"
$
$ ./cyber-dojo start-points create \
    cyberdojo/languages \
      --languages \
        "${LANGUAGES_URLS}"
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to https://cyber-dojo.org](https://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
