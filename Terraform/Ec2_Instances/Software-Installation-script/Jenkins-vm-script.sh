#!/bin/bash
# Removed set -e for the update phase to prevent premature exiting
sudo apt update -y

echo "🛠️ Installing dependencies (gnupg, curl, etc)..."
sudo apt install -y gnupg2 curl ca-certificates

echo "☕ Installing Java 17..."
# Adding -y and --fix-broken to ensure it clears previous attempts
sudo apt install -y openjdk-17-jre
if [ $? -ne 0 ]; then
    echo "❌ Java installation failed. Attempting to fix and retry..."
    sudo apt --fix-broken install -y
    sudo apt install -y openjdk-17-jre
fi

echo "🔑 Adding Jenkins Key and Repo..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "📥 Installing Jenkins..."
sudo apt update
sudo apt install jenkins -y

echo "🚀 Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "✅ Success! Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword