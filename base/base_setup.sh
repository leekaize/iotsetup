#! /bin/bash

gitdir=$(pwd)
sudo mkdir -p /usr/local/sbin/base/traefik
cd /usr/local/sbin/base
sudo touch ./traefik/traefik.yml
sudo touch ./traefik/traefik_api.yml
docker network create traefiknet
sudo mkdir -p /usr/local/sbin/base/portainer/data
sudo chown -R 9000:9000 /usr/local/sbin/base/portainer

sudo cp $gitdir/docker-compose.yml ./
read -p "Enter domain name (e.g. mywebsite.com): " domain
# export domain
envsubst < ./docker-compose.yml | sudo tee "./docker-compose.yml"

sudo cp $gitdir/traefik_api.yml ./traefik/traefik_api.yml
read -p "Set Traefik username: " username
# export username
while true; do
  read -p "Set Traefik password: " -s password
  echo
  read -p "Confirm password: " -s password2
  echo
  [ "$password" = "$password2" ] && break
  echo "Password not match, please try again."
done
# export password
export secret=$(docker run --rm httpd htpasswd -nb $username $password)
envsubst < ./traefik/traefik_api.yml | sudo tee "./traefik/traefik_api.yml"

read -p "Set Email for TLS cert: " email
# export email
sudo cp $gitdir/traefik.yml ./traefik/traefik.yml
envsubst < ./traefik/traefik.yml | sudo tee "./traefik/traefik.yml"

docker image rm httpd
docker compose up -d

