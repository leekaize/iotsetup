#! /bin/bash

iotdir="/usr/local/sbin/iot"
cd $iotdir
read -p "Enter Node-RED username: " NODERED_USERNAME
echo "Enter Node-RED password: "
NODERED_PASSWORD=$(echo "$(docker exec -it nodered npx node-red admin hash-pw)" | tail -n 1)
echo "$NODERED_PASSWORD"

cat <<-EOT | sudo tee tmp.txt
    adminAuth: {
        type: "credentials",
        users: [{
            username: "$NODERED_USERNAME",
            password: "${NODERED_PASSWORD//$'\015'}",
            permissions: "*"
        }]
    },
EOT
sudo sed -i '24 r tmp.txt' $iotdir/nodered/data/settings.js && sudo rm tmp.txt
docker compose restart nodered

