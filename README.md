# IoT Microservices Stacks
The scripts are to setup the IoT cloud server (Debian) from fresh install through VPS.

## Initial Setup
The scripts are assuming basic setups on the server has already been done and a user with `sudo` privileges has been created. Example initial setup code:
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

### Base
The base stack consists of:
1. **traefik**: For reversed proxy and load balancing.
2. **portainer**: Manage Docker containers.

The two can be installed through single docker-compose as `base` stack, where an external network: `traefiknet` is created to communicate with other microservices.
