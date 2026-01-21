#!/bin/bash
sudo apt update -y
# 1. Install Java (Jenkins dependency)
sudo apt install openjdk-17-jre -y

# 2. Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# 3. Install Docker (for building app images)
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# 4. Install Kubectl (to deploy to K8s)
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 

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