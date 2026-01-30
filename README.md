# AutoVoteOps: Production-Grade CI/CD Pipeline

![Architecture](https://img.shields.io/badge/Architecture-Microservices-blue)
![Infrastructure](https://img.shields.io/badge/IaC-Terraform-purple)
![Container](https://img.shields.io/badge/Container-Docker-blue)
![Orchestration](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5)
![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939)
![Cloud](https://img.shields.io/badge/Cloud-AWS-FF9900)

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Future Roadmap](#future-roadmap)

## 🌟 Overview

**AutoVoteOps** is a cloud-native voting application deployed using a robust CI/CD pipeline. This project demonstrates a "Gold Standard" DevOps workflow, integrating Infrastructure as Code (IaC), Containerization, and Kubernetes Orchestration.

**AutoVoteOps** is a distributed microservices application designed to demonstrate a high-availability voting system, which is deployed using production-grade DevOps practices. This project showcases:

- **Infrastructure as Code** using Terraform
- **Container orchestration** with Kubernetes (kubeadm cluster)
- **Automated CI/CD** pipelines with Jenkins
- **Microservices architecture** deployed on AWS
- **Database management** with AWS RDS MySQL
- **Automated cluster setup** with custom AMI, Shellscripting and S3 token sharing

### What This Project Demonstrates

✅ **Complete DevOps Lifecycle** - From infrastructure provisioning to application deployment  
✅ **Cloud-Native Architecture** - Microservices running on Kubernetes  
✅ **Automation** - Terraform for infrastructure, Jenkins for CI/CD  
✅ **Security Best Practices** - Private subnets, security groups, IAM roles  
✅ **Scalability** - Kubernetes deployments with replica management  
✅ **Real-World Patterns** - NAT Gateway, bastion host, RDS, container registry

## 🏗️ Architecture
### Application Architecture

```
User Request
    ↓
ALB (Security Group)
    ↓
Target Group
    ↓
K8s Worker Node (Private) :31000
    ↓
Nginx Service (NodePort Service)
    ↓
    ├──→ Frontend Pods
    │    └── Nginx serving static files
    │
    └──→ Backend Pods (Node.js/Express)
         └── API endpoints
              ↓
         RDS MySQL Database
         └── Voting data storage
```

## 🛠️ Tech Stack

### Infrastructure & Cloud
- **Cloud Provider:** AWS (EC2, VPC, RDS, S3, NAT Gateway)
- **IaC:** Terraform
- **AMI Building:** Packer 
- **Container Orchestration:** Kubernetes (kubeadm)
- **Networking:** VPC, Subnets, Security Groups, Route Tables
- ALB: For traffic distribution

### Application
- **Frontend:** index.html,style.css
- **Backend:** server.js,package.json,.env
- **Database:** MySQL (AWS RDS)
- **Containerization:** Docker
- **Reverse Proxy:** Nginx

### CI/CD & Automation
- **CI/CD:** Jenkins (Multi-job pipeline)
- **Version Control:** Git, GitHub
- **Container Registry:** DockerHub
- **Automation Scripts:** Bash, Shell scripts

### Kubernetes Components
- **CNI:** Calico Network
- **Service Types:** ClusterIP, NodePort
- **Workloads:** Deployments, Pods
- **Config Management:** ConfigMaps, Secrets

## 📁 Project Structure

```
AutoVoteOps/
│
├── Frontend/                      # web application
│   ├── src/
│   │   ├── index.html             # static files
│   │   ├── style.css              # style files
│   │    
│   │  
│   ├── Dockerfile              # Frontend container image
│   ├── default.conf            # Nginx config for serving
│  
│
├── Backend/                    # Express.js API
│   ├── server.js               # Main server file
│   ├── Dockerfile              # Backend container image
│   ├── .env                    # Environment variables
│   └── package.json
│
├── K8s/                        # Kubernetes manifests
│   ├── namespace.yaml          # Namespace definition
│   ├── config.yaml             # Nginx configuration
│   ├── backend.yaml            # Backend workload
│   ├── frontend.yaml           # Frontend workload
│   
│
├── Terraform/                  # Infrastructure as Code
│   ├── terraform.tf                 # Main configuration
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output value
│   │
│   ├── modules/
│   │   ├── vpc/                # VPC module
│   │   ├── ec2/                # EC2 instances
│   │   ├── rds/                # RDS database
│   │
│   └── user-data/
│       ├── master-init.sh      # K8s master installation
│       ├── worker-join.sh      # K8s worker join script
|       |__ Jenkins.sh          # Jenkins Installation
|       |__ Docker.sh           # Docker Installation
│
├── Jenkins/                    # Jenkins job definitions
│   ├── Frontend.Jenkinsfile    # Frontend build pipeline
    ├── Backend.Jenkinsfile     # Backend build pipeline
│   ├── Deploy.Jenkinsfile      # Deployment pipeline
│   └── Rollback.Jenkinsfile    # Rollback pipeline
│
├── docs/                       # Documentation
│   ├── Project-Documentation
│   ├── Workflows.pdf
|
|__Testcases                    # Project Implementation
├── .gitignore
├── README.md
```

## 🚀 Features

### Application Features
- **Dual-Option Interactive Voting**: Simple, intuitive "Team A" vs. "Team B" buttons for instant user engagement.
- **Dynamic Progress Visuals**: Real-time progress bars that visually compare the vote distribution between the two teams.
- **Live Leaderboard**: A stats section that displays the exact numerical vote count for each team.
- **Winner Declaration**: A reactive header that automatically updates to announce which team is currently in the lead or if the results are tied.


### DevOps Features
- 🏗️ **Infrastructure as Code** - Complete infrastructure defined in Terraform
- 🐳 **Containerized Services** - All services run in Docker containers
- ☸️ **Kubernetes Orchestration** - Automated deployment and scaling
- 🔄 **CI/CD Automation** - Automated build and deployment pipeline
- 🔒 **Security Best Practices** - Private subnets, security groups, secrets management
- 📊 **High Availability** - Multiple pod replicas, health checks
- 🔧 **Easy Rollback** - One-click rollback to previous version
- 📈 **Scalability** - Horizontal pod scaling capability
- 🌐 **Network Isolation** - Public/private subnet architecture
- 🔑 **Token-Based Authentication** - S3-based cluster token sharing

## 📋 Prerequisites

### Local Development
- Git
- Docker Desktop
- Node.js 18+
- kubectl
- Terraform 1.0+
- AWS CLI configured

### AWS Account
- AWS account with appropriate permissions
- IAM user with programmatic access
- AWS CLI configured with credentials

### Required AWS Resources
- VPC with public and private subnets
- NAT Gateway for private subnet internet access
- EC2 instances (t2.medium or higher)
- RDS MySQL instance (db.t3.micro or higher)
- S3 bucket for state/token storage

### Tools & Services
- GitHub account
- DockerHub account
- SSH key pair for EC2 access

---

## ⚡ Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/sayaliparhar/AutoVoteOps.git
cd AutoVoteOps
```

### 2. Setup AWS Credentials

```bash
Setup AWS credentials using aws configure
 aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: ap-south-1
# Default output format: json
```

### 3. Deploy Infrastructure

```bash
cd Terraform

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply -auto-approve

# Save output values
terraform output > ../outputs.txt
```

**This will create:**
- VPC with public and private subnets
- 4 EC2 instances (K8s master, worker, Jenkins, Docker)
- RDS MySQL instance
- Security groups and IAM roles
- S3 bucket for token sharing
- Kubernetes cluster (auto-configured)

### 5. Setup Jenkins

```bash
# Get Jenkins URL
JENKINS_IP=$(terraform output -raw jenkins_public_ip)
echo "Jenkins URL: http://${JENKINS_IP}:8080"

# Get initial admin password
ssh -i your-key.pem ubuntu@${JENKINS_IP} \
  "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

### 6. Configure CI/CD Pipeline

1. Open Jenkins at `http://<jenkins-ip>:8080`
2. Install suggested plugins
3. Setup the Global Credentials
3. Create jobs from jenkins/ directory
4. Configure GitHub webhook
5. Trigger first build!
---

## 📈 Future Roadmap
- [ ] **Scalability:** Migrate from Kubeadm to **AWS EKS** for a managed, production-ready Control Plane.
- [ ] **Observability:** Integrate **Prometheus and Grafana** for real-time monitoring and alerting.
- [ ] **GitOps:** Transition to **ArgoCD** to automate deployment synchronization directly from Git.
- [ ] **Security:** Implement **HashiCorp Vault** for centralized and encrypted secret management.

---

## 👥 Authors

- **Sayali Parhar** - *Initial work* - [YourGitHub](https://github.com/sayaliparhar)

---



