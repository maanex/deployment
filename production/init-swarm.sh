# RUN THIS FILE TO INIT THE HOST TO MANAGE A DOCKER SWARM



# # For Nextcloud
# mkdir /var/www/html/data
# touch /var/www/html/data/htaccesstest.txt
# chmod +rw /var/www/html/data/htaccesstest.txt


echo ":: Giving absurd permissions to the docker socket"
chmod +777 /var/run/docker.sock


echo ":: Creating public networks"
docker network create --driver=overlay proxy
docker network create --driver=overlay logging
docker network create --driver=overlay redis
docker network create --driver=overlay rabbits
docker network create --driver=overlay fsm-sockets
docker network create --driver=overlay fsm-micros
docker network create --driver=overlay metrics
docker network create --driver=overlay gibu
docker network create --driver=overlay devenv


# "slice" devides the cluster into subsections
# "hasconf" is TRUE if the node has this repo cloned locally (config files)
# "persistent" is TRUE if the node is suitable for apps with persistent storage
# "autoscale" is TRUE if the node is suitable for apps that just deploy wherever
# "t_mchost" is TRUE if the node is the host for minecraft servers
# "t_fsbpu" is TRUE if the node is FreeStuffBot priority upstream (app specific)

echo ":: Labeling nodes"
docker node update \
  --label-add slice=A \
  --label-add hasconf=true \
  --label-add persistent=true \
  --label-add autoscale=true \
  --label-add t_mchost=false \
  --label-add t_fsbpu=false \
  co1
docker node update \
  --label-add slice=A \
  --label-add hasconf=false \
  --label-add persistent=false \
  --label-add autoscale=true \
  --label-add t_mchost=false \
  --label-add t_fsbpu=true \
  co2
docker node update \
  --label-add slice=B \
  --label-add hasconf=false \
  --label-add persistent=false \
  --label-add autoscale=false \
  --label-add t_mchost=true \
  --label-add t_fsbpu=false \
  co3
docker node update \
  --label-add slice=B \
  --label-add hasconf=false \
  --label-add persistent=false \
  --label-add autoscale=true \
  --label-add t_mchost=false \
  --label-add t_fsbpu=false \
  co4


