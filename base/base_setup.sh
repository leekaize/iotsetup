#! /bin/bash

sudo mkdir -p /usr/local/sbin/base/traefik
cd /usr/local/sbin/base
sudo touch ./traefik/traefik.yml
sudo touch ./traefik/traefik_api.yml
docker network create traefiknet
sudo mkdir -p /usr/local/sbin/base/portainer/data
sudo chown -R 9000:9000 /usr/local/sbin/base/portainer

sudo cp ~/base/docker-compose.yml ./
echo "Root domain: "
read domain
export domain
envsubst < ./docker-compose.yml | sudo tee "./docker-compose.yml"

sudo cp ~/base/traefik_api.yml ./traefik/traefik_api.yml
echo "Traefik username: "
read username
export username
echo "Traefik password: "
read password
export password
export secret=$(docker run --rm httpd htpasswd -nb $username $password)
envsubst < ./traefik/traefik_api.yml | sudo tee "./traefik/traefik_api.yml"

echo "Email for TLS: "
read email
export email
sudo cp ~/base/traefik.yml ./traefik/traefik.yml
envsubst < ./traefik/traefik.yml | sudo tee "./traefik/traefik.yml"

docker compose -p "base" up -d

