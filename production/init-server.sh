# RUN THIS FILE TO SET UP A SERVER FROM SCRATCH

if [ ! -f "~/.ssh/authorized_keys" ]; then
    echo "~/.ssh/authorized_keys not found, creating..."
    mkdir ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
fi

read -p "Enter your key: " mykey
echo $mykey >> ~/.ssh/authorized_keys

# disable password login
sudo passwd -d root

# install docker
sh <(curl -s https://get.docker.com)

read -p "Swarm join token: " swtoken

 docker swarm join --token $swtoken




# # MASTER NODE ONLY:
# docker swarm init
# chmod +777 /var/run/docker.sock
# echo "create secrets"
# echo "clone repo"
