#!/bin/bash

# 1. Start Error Handling & Logging immediately
set -e
set -o pipefail

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# 2. Wait for APT locks (Fixes the "Java not installing" issue)
log "Checking for package manager locks..."
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    log "Waiting for other software updates to finish..."
    sleep 5
done

# 3. Install Java 17
log "☕ Installing Java (Jenkins dependency)..."
sudo apt update -y
sudo apt install -y openjdk-17-jre
# Verify Java immediately
java -version || (log "❌ Java failed to install" && exit 1)

# 4. Install Docker
log "🛠️ Preparing for Docker installation..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

log "📦 Running official Docker installation script..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 5. Permissions and Service Setup
log "👤 Configuring Docker permissions..."
# We add both the current user AND the jenkins user (if it exists)
sudo usermod -aG docker $USER
if id "jenkins" &>/dev/null; then
    sudo usermod -aG docker jenkins
    log "Added 'jenkins' user to docker group"
fi

sudo systemctl enable docker
sudo systemctl start docker

# Cleanup
rm get-docker.sh

log "✅ All systems go! Java and Docker are installed."
echo "-------------------------------------------------------"
echo "🚀 IMPORTANT: Run 'newgrp docker' to use Docker now."
echo "-------------------------------------------------------"