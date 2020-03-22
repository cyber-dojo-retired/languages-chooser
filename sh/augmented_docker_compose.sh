#!/bin/bash -Eeu

# cyberdojo/service-yaml image lives at
# https://github.com/cyber-dojo/service-yaml

augmented_docker_compose()
{
  cd "${ROOT_DIR}" && cat "./docker-compose.yml" \
    | docker run --rm --interactive cyberdojo/service-yaml \
         custom-start-points \
      exercises-start-points \
      languages-start-points \
                     creator \
                       saver \
                    selenium \
    | tee /tmp/augmented-docker-compose.peek.yml \
    | docker-compose \
        --file -     \
        "$@"
}
