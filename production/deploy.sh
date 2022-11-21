#!/bin/bash

export $(grep -v '^#' .env | xargs)

name=$0

echo ":: Deploying $name"
# docker stack deploy -c cd-$name.yaml $name --with-registry-auth
echo $CODER_POSTGRES_PASSWORD
