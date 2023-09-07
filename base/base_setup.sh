#! /bin/bash

# To obtain script location
gitdir=$(dirname "$(readlink -f "$0")")
basedir="/usr/local/sbin/base"
sudo mkdir -p /usr/local/sbin/base/traefik
sudo touch $basedir/traefik/traefik.yml
sudo touch $basedir/traefik/traefik_api.yml
docker network create traefiknet
sudo mkdir -p /usr/local/sbin/base/portainer/data
sudo chown -R 9000:9000 /usr/local/sbin/base/portainer

sudo cp $gitdir/docker-compose.yml $basedir/docker-compose.yml
read -p "Enter domain name (e.g. mywebsite.com): " domain
export domain
envsubst < $gitdir/docker-compose.yml | sudo tee "$basedir/docker-compose.yml"

sudo cp $gitdir/traefik/traefik_api.yml $basedir/traefik/traefik_api.yml
read -p "Set Traefik username: " username
export username
while true; do
  read -p "Set Traefik password: " -s password
  echo
  read -p "Confirm password: " -s password2
  echo
  [ "$password" = "$password2" ] && break
  echo "Password not match, please try again."
done
export password
export secret=$(docker run --rm httpd htpasswd -nb $username $password)
envsubst < $gitdir/traefik/traefik_api.yml | sudo tee "$basedir/traefik/traefik_api.yml"

read -p "Set Email for TLS cert: " email
export email
sudo cp $gitdir/traefik/traefik.yml $basedir/traefik/traefik.yml
envsubst < $gitdir/traefik/traefik.yml | sudo tee "$basedir/traefik/traefik.yml"

docker image rm httpd
cd $basedir
docker compose up -d

