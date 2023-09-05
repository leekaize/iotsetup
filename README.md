# Quick Deployment for IoT Microservices Stacks
*Very novice on-going development repo, shell scripts has to be run one-by-one for now.*

The scripts are to setup the IoT cloud server (Debian) from fresh install through VPS.
Additional infrastructure setup can be done, for example: Cloudflare proxy, Wazuh SIEM.

## Initial Setup
The scripts are assuming basic setups on the server has already been done and a user with `sudo` privileges has been created. Example initial setup script:
```bash
#! /bin/bash

echo "Enter Timezone (e.g. Asia/Kuching): "
read timezone
timedatectl set-timezone $timezone
date
apt update && apt upgrade -y
apt install git -y

echo "Enter Username"
read username
useradd -m $username
passwd $username
usermod -aG sudo $username

cp -r /root/.ssh /home/$username/
chown -hR $username:$username /home/$username/.ssh
```

### Optional Terminal Setup
The **tmux** and **zsh** installation script is included.

### Docker Installation
Script following official Docker documentation is included (instead of using unofficial pakages of *docker.io* and *docker-compose*).

## Microservices Stacks
For migrating from old server, all the persistent volumes data should be migrated manually into `/usr/local/sbin` before running the scripts.

### Base Stack
1. **Traefik**: For reversed proxy and load balancing.
2. **Portainer**: Manage Docker containers.

The two can be installed through single docker-compose as `base` stack, where an external network: `traefiknet` is created to communicate with other microservices.

### IoT Stack
1. **Node-RED**: Configure IoT connections and communications.
2. **Ecplipse Mosquitto**: MQTT Broker.
3. **InfluxDB**: Time-series Database.
4. **Grafana**: Simple data monitoring.

### MariaDB Stack
1. **MariaDB**: Relational database.
2. **Adminer**: Minimal relational database management.

### Web Stack
1. **NTFY**: For alerts and events notifications.
2. **SvelteKit Website**: Fully customisable dashboard.
