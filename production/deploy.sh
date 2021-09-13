
echo ":: Creating public network"
docker network create --driver=overlay traefik-public
docker network create --driver=overlay logging
docker network create --driver=overlay redis
docker network create --driver=overlay fsm-sockets
docker network create --driver=overlay metrics

#

echo ":: Deploying Infrastructure"
docker stack deploy -c docker-compose-infra.yml infra

echo ":: Deploying Swarmpit"
docker stack deploy -c docker-compose-swarmpit.yml swarmpit

echo ":: Deploying Microservices"
docker stack deploy -c docker-compose-micros.yml micros

echo ":: Deploying Apps"
docker stack deploy -c docker-compose-apps.yml apps --with-registry-auth

echo ":: Deploying Tude Stack"
docker stack deploy -c docker-compose-tude.yml tude --with-registry-auth
