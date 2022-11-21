# For Nextcloud
mkdir /var/www/html/data
touch /var/www/html/data/htaccesstest.txt
chmod +rw /var/www/html/data/htaccesstest.txt



echo ":: Creating public network"
docker network create --driver=overlay proxy
docker network create --driver=overlay logging
docker network create --driver=overlay redis
docker network create --driver=overlay rabbits
docker network create --driver=overlay fsm-sockets
docker network create --driver=overlay fsm-micros
docker network create --driver=overlay metrics
docker network create --driver=overlay gibu