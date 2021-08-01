
echo "Creating public network"
docker network create --driver=overlay traefik-public
docker network create --driver=overlay logging

#

echo "Deploying Infrastructure"
docker stack deploy -c docker-compose-infra.yml infra

echo "Deploying Microservices"
docker stack deploy -c docker-compose-micros.yml micros

echo "Deploying Apps"
docker stack deploy -c docker-compose-apps.yml apps --with-registry-auth
