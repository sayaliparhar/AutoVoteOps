#!/bin/bash

# 1. Error Handling & Logging
set -e
set -o pipefail
LOG_FILE="/var/log/k8s-master-init.log"
exec > >(tee -a ${LOG_FILE}) 2>&1

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

# 2. Fix Java Installation (Jenkins dependency)
log "Updating package lists..."
sudo apt update -y || (sleep 5 && sudo apt update -y)

log "Installing Java 17 and dependencies..."
# We add software-properties-common to ensure apt-repository commands work
sudo apt install -y software-properties-common fontconfig
sudo apt install -y openjdk-17-jre
check_status "Java Installation"

# Verify Java immediately
java -version || { log "Java not found after install"; exit 1; }

# 3. Initialize Kubernetes Cluster
log "Initializing Kubernetes Cluster"


# Get the actual Private IP of the instance
API_SERVER_IP=$(hostname -I | awk '{print $1}')
log "Using IP: $API_SERVER_IP"

# Kubeadm init (Added --pod-network-cidr for Calico compatibility)
sudo kubeadm init --apiserver-advertise-address=$API_SERVER_IP --pod-network-cidr=192.168.0.0/16 | tee /tmp/kubeadm-init.log
check_status "kubeadm init"

# 4. Setup Kubectl for Ubuntu user
log "Setting up kubectl for ubuntu user"
mkdir -p /home/ubuntu/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
check_status "Kubectl Configuration"

# 5. Networking (Calico)
log "Installing Calico CNI"

sudo -u ubuntu kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
check_status "Calico Installation"

# 6. Generate and Upload Join Command
log "Generating Worker Join Command"
JOIN_COMMAND=$(sudo kubeadm token create --print-join-command)

echo "#!/bin/bash" > /tmp/cluster-join-command.sh
echo "$JOIN_COMMAND" >> /tmp/cluster-join-command.sh
chmod +x /tmp/cluster-join-command.sh

log "Uploading to S3..."
# Ensure the instance has an IAM Role with S3 Write access!
aws s3 cp /tmp/cluster-join-command.sh s3://autovotewebapp/cluster-join-command.sh
check_status "S3 File Upload"

log "✅ Master Node Setup Complete!"
exit 0