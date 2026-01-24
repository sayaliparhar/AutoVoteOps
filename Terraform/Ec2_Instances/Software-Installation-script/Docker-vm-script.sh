#!/bin/bash

sudo apt update -y
# 1. Install Java (Jenkins dependency)
sudo apt install openjdk-17-jre -y


# 2. Install Docker (for building app images)
set -e

echo "🛠️ Preparing Ubuntu for Docker installation..."

# 1. Update package index and install required system dependencies
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 2. Download and run the official Docker convenience script
echo "📦 Downloading and installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Setup permissions for the current Ubuntu user
echo "👤 Configuring user permissions..."
sudo usermod -aG docker $USER

# Enable Docker to start on boot
echo "⚙️ Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# 5. Cleanup
rm get-docker.sh

echo ""
echo "✅ Installation Complete!"
echo "-------------------------------------------------------"
echo "🚀 To start using Docker without sudo, run this command:"
echo "   newgrp docker"
echo "-------------------------------------------------------"