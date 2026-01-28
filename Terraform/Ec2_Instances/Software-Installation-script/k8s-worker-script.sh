#!/bin/bash

# 1. Start Error Handling & Logging immediately
set -e
set -o pipefail

LOG_FILE="/var/log/worker-join.log"
# Ensure the log file exists and is writable
sudo touch "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

check_status() {
    if [ $? -eq 0 ]; then
       log "$1 Succeeded"
    else 
       log "$1 Failed"
       exit 1
    fi
}

# 2. Wait for APT locks to release (Crucial for new cloud instances)
log "Waiting for other package managers to finish..."
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    log "Apt is locked, sleeping 5s..."
    sleep 5
done

# 3. Install Java (Jenkins dependency)
log "Updating and installing Java 17..."
sudo apt update -y
sudo apt install openjdk-17-jre -y
check_status "Java Installation"

# 4. Join Kubernetes Cluster
log "Waiting for join command from S3..."


# Loop until the master node uploads the join script
while true; do
   if aws s3 cp s3://autovotewebapp/cluster-join-command.sh /tmp/cluster-join-command.sh; then
       log "Join command found!"
       break
   else
       log "Join command not found in S3 yet, retrying in 20s..."
       sleep 20
   fi
done

log "Setting Permissions"
chmod +x /tmp/cluster-join-command.sh
check_status "Setting Permissions"

log "Running Join Command"
# Note: Join commands must be run as root
sudo bash /tmp/cluster-join-command.sh
check_status "Joining the Cluster"

log "✅ Worker Node Setup Complete!"
exit 0