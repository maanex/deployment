# RUN THIS FILE TO INIT THE HOST TO MANAGE A DOCKER SWARM



# # For Nextcloud
# mkdir /var/www/html/data
# touch /var/www/html/data/htaccesstest.txt
# chmod +rw /var/www/html/data/htaccesstest.txt



echo ":: Creating public network"
docker network create --driver=overlay proxy
docker network create --driver=overlay logging
docker network create --driver=overlay redis
docker network create --driver=overlay rabbits
docker network create --driver=overlay fsm-sockets
docker network create --driver=overlay fsm-micros
docker network create --driver=overlay metrics
docker network create --driver=overlay gibu
docker network create --driver=overlay devenv


docker node update --label-add slice=A co1
docker node update --label-add slice=A co2
docker node update --label-add slice=B co3
docker node update --label-add slice=B co4

