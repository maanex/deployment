#!/bin/bash

export $(grep -v '^#' .env | xargs)

name=$1

echo ":: Deploying $name"
docker stack deploy -c dc-$name.yaml $name --with-registry-auth
