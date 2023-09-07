#! /bin/bash

gitdir=$(dirname "$(readlink -f "$0")")
iotdir="/usr/local/sbin/iot"

sudo mkdir -p $iotdir/mosquitto/config $iotdir/mosquitto/data $iotdir/mosquitto/log
sudo chown -R 8883:8883 $iotdir/mosquitto

read -p "Enter domain name (e.g. mywebsite.com): " domain
export domain
envsubst < $gitdir/docker-compose.yml | sudo tee "$iotdir/docker-compose.yml"

sudo cp $gitdir/mosquitto/config/mosquitto.conf $iotdir/mosquitto/config/mosquitto.conf


