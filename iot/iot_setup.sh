#! /bin/bash

gitdir=$(dirname "$(readlink -f "$0")")
iotdir="/usr/local/sbin/iot"

sudo mkdir -p $iotdir/mosquitto/config $iotdir/mosquitto/data $iotdir/mosquitto/log
sudo chown -R 8883:8883 $iotdir/mosquitto

read -p "Enter domain name (e.g. mywebsite.com): " domain
export domain
envsubst < $gitdir/docker-compose.yml | sudo tee "$iotdir/docker-compose.yml"

sudo cp $gitdir/mosquitto/config/mosquitto.conf $iotdir/mosquitto/config/mosquitto.conf
echo "#" | sudo tee $iotdir/mosquitto/config/passwordfile
sudo chown -R 8883:8883 $iotdir/mosquitto

docker compose up -d
read -p "Set Mosquitto username: " username
while true; do
  read -p "Set Mosquitto password: " -s password
  echo
  read -p "Confirm password: " -s password2
  echo
  [ "$password" = "$password2" ] && break
  echo "Password not match, please try again."
done

docker exec -it mosquitto mosquitto_passwd -c /mosquitto/config/passwordfile -b $username $password
docker exec -it mosquitto chown root:root /mosquitto/config/passwordfile
docker exec -it mosquitto chmod 600 /mosquitto/config/passwordfile
docker compose restart mosquitto

