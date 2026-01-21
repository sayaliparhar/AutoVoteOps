#!/bin/bash

sudo apt update -y
# 1. Install Java (Jenkins dependency)
sudo apt install openjdk-17-jre -y

# 2. Install k8s-worker script

set -e

LOG_FILE="/var/log/worker-join.log"
exec > >(tee -a "$LOG_FILE") 2>&1

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

check_status() {
    if [ $? -eq 0 ]; then
       log "$1 Succeeded"
    else 
       log "$1 Failed"
    fi
}

while true; do
   aws s3 cp s3://autovotewebapp/cluster-join-command.sh /tmp/cluster-join-command.sh && break
   sleep 10
done

log "Setting Permissions"
chmod +x /tmp/cluster-join-command.sh
check_status "Setting Permissions"

log "Running Join Command"
bash /tmp/cluster-join-command.sh
check_status "Running Join Command"

exit 0