#!/bin/bash
set -e

echo "☕ Installing Java (Required for Jenkins)..."
sudo apt update
sudo apt install fontconfig openjdk-17-jre -y

echo "🔑 Adding Jenkins Repository Key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "📂 Adding Jenkins Debian Repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "📥 Installing Jenkins..."
sudo apt update
sudo apt install jenkins -y

echo "🚀 Starting Jenkins Service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "✅ Jenkins installation complete!"
echo "Your Initial Admin Password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# 4. Install Mysql
sudo apt update -y

echo "Installing MySQL Client..."
# This installs just the command-line tools
sudo apt install -y mysql-client

# Verify installation
if command -v mysql &> /dev/null; then
    echo "MySQL Client installed successfully!"
    mysql --version
else
    echo "Installation failed."
    exit 1
fi