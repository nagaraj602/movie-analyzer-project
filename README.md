# Movie Analyzer Application - Complete Cloud & DevOps Platform

[![Terraform](https://img.shields.io/badge/Terraform-v1.10+-purple.svg)](https://www.terraform.io/)
[![AWS EKS](https://img.shields.io/badge/AWS%20EKS-1.37-orange.svg)](https://aws.amazon.com/eks/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-blue.svg)](https://www.postgresql.org/)
[![Java](https://img.shields.io/badge/Java-25%20LTS-orange.svg)](https://adoptium.net/)
[![Python](https://img.shields.io/badge/Python-3.13%20%7C%203.15-blue.svg)](https://www.python.org/)
[![Node.js](https://img.shields.io/badge/Node.js-24%20LTS-green.svg)](https://nodejs.org/)
[![React](https://img.shields.io/badge/React-19-blue.svg)](https://react.dev/)
[![Docker Compose](https://img.shields.io/badge/Docker%20Compose-v2%2B-blue.svg)](https://docs.docker.com/compose/)

This repository serves as the central DevOps and cloud infrastructure orchestration hub for the **Movie Analyzer Platform**, developed and maintained by **nagaraj602**. The platform showcases an enterprise-grade Continuous Integration and Continuous Deployment (CI/CD) microservices pipeline deployed on **Amazon EKS 1.37** and **AWS RDS PostgreSQL 17**, fully provisioned with **Terraform IaC**, automated via **Jenkins Multibranch Pipelines**, and packaged for immediate local execution with **Docker Compose**.

---

## 🔗 Platform Ecosystem & Repositories

All microservices and shared libraries are maintained across five dedicated repositories:

| Repository | GitHub Link | Purpose & Tech Stack |
| :--- | :--- | :--- |
| **Main Orchestration & IaC** | [nagaraj602/movie-analyzer-project](https://github.com/nagaraj602/movie-analyzer-project.git) | Terraform AWS IaC (VPC, EKS 1.37, RDS PostgreSQL 17, Jenkins Master/Agent, Bastion), Database Init Scripts, Docker Compose |
| **Backend Core Service** | [nagaraj602/project-movie-analyzer-backend](https://github.com/nagaraj602/project-movie-analyzer-backend.git) | Java 21/25 LTS, Spring Boot 3.5, Hibernate/JPA, Actuator, WebFlux client (**Port `7280`**) |
| **AI/ML Model Service** | [nagaraj602/project-movie-analyzer-model](https://github.com/nagaraj602/project-movie-analyzer-model.git) | Python 3.13/3.15, Flask 3.1, TextBlob, NLTK Sentiment Polarity & Rating Engine (**Port `7380`**) |
| **Frontend Portal** | [nagaraj602/project-movie-analyzer-frontend](https://github.com/nagaraj602/project-movie-analyzer-frontend.git) | React 19, Express 4, Node 24 LTS, White & Shades-of-White Design (**Port `7180`**) |
| **Jenkins Shared Libraries** | [nagaraj602/jenkins-sharedlibraries](https://github.com/nagaraj602/jenkins-sharedlibraries.git) | Reusable Jenkins Groovy steps (`trivyScan`, `sonarAnalysis`, `dockerECRImagePush`, `kubernetesEKSHelmDeploy`) |

---

## 🏗️ Architecture Overview

The system is architected as an event-driven, decoupled microservices mesh connecting to an AWS RDS PostgreSQL 17 database cluster:

```
[ User Browser ]
       │
       ▼ (HTTP Port 7180)
┌────────────────────────────────────────────────────────┐
│  Frontend Service (React 19 + Express Reverse Proxy)   │
│  - White & Shades-of-White Aesthetic (No Blue)         │
│  - Real-time Microservice Status Bar                   │
│  - Floating Chaos Engineering Admin Panel              │
└──────────────────────────┬─────────────────────────────┘
                           │ (API Proxy /api -> Port 7280)
                           ▼
┌────────────────────────────────────────────────────────┐
│  Backend Service (Spring Boot 3.5 on Java 25 LTS)     │
│  - RESTful Review Management & Stats Aggregation       │
│  - Spring Data JPA / Hibernate Connection Pool        │
│  - Spring Actuator Health & Chaos Simulation           │
└──────────────┬───────────────────────────┬─────────────┘
               │                           │
               ▼ (Port 7380)               ▼ (Port 5432 / 5438)
┌──────────────────────────────┐ ┌──────────────────────┐
│  AI/ML Model Service         │ │  PostgreSQL 17 DB    │
│  (Python 3.13/3.15 + Flask)  │ │  (AWS RDS / Docker)  │
│  - TextBlob Sentiment Engine │ │  - Database:         │
│  - Polarity & Rating Scorer  │ │    moviereviews      │
└──────────────────────────────┘ └──────────────────────┘
```

---

## 🚀 Non-Standard Port Matrix

To avoid conflicting with common developer and system services (e.g., standard ports `8080`, `5000`, `3000`, `80`, `443`), all microservices in this project use customized non-standard ports:

| Service | Port | Protocol | Purpose | Health Endpoint |
| :--- | :--- | :--- | :--- | :--- |
| **Frontend Web Portal** | **`7180`** | HTTP | User UI & Express reverse proxy gateway | `http://localhost:7180/health` |
| **Backend Core API** | **`7280`** | HTTP | Spring Boot REST API & Actuator diagnostics | `http://localhost:7280/actuator/health` |
| **AI/ML Model Service** | **`7380`** | HTTP | Python Flask sentiment analysis engine | `http://localhost:7380/health` |
| **PostgreSQL Database** | **`5438`** *(host)* / `5432` *(internal)* | TCP | Relational persistence & SQL review stats | `pg_isready -p 5432` |

---

## 🎨 UI Design System: White & Shades of White

In accordance with strict brand styling requirements:
* **Background Colors**: Pure white (`#ffffff`) complemented with elegant shades of white (`#f8fafc`, `#f1f5f9`, `#fafafa`, `#f4f4f5`).
* **High Contrast Typography**: Rich slate charcoal (`#0f172a`, `#1e293b`, `#334155`) for crystal-clear readability.
* **Monochrome Components**: Buttons, badges, and cards use refined slate/graphite and subtle light borders (`#e2e8f0`).
* **Zero Blue Color**: Blue gradients (`#667eea`, `#3b82f6`, `#2563eb`, `#4338ca`) are completely avoided.
* **Full Feature Parity**: All 6 movie cards (*Inception*, *The Dark Knight*, *Gladiator*, *Interstellar*, *Fight Club*, *The Shawshank Redemption*), live review submission, sentiment visualization, bottom status bar, and floating chaos admin panel are fully preserved.

---

## 🛠️ Prerequisites & Installation

Before provisioning cloud infrastructure or running the applications, install and configure the following required tools on your workstation or runner node:

### 1. Docker & Docker Compose
* **Docker Engine**: Version 24+ or 29+
* **Docker Compose**: Version v2.20+ or v5.6+
```bash
# Ubuntu/Debian installation
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
# Activate group without reboot
newgrp docker
docker --version
docker compose version
```

### 2. AWS CLI v2 & Credential Configuration
Install the official AWS CLI v2:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
Configure your AWS credentials:
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: ap-south-1 (or your preferred region)
# Default output format: json
```

Verify your identity:
```bash
aws sts get-caller-identity
```

### 3. AWS IAM Permissions
The provisioning IAM user or deployment role requires permissions across the following AWS services:
* **Amazon EKS**: Full cluster creation, node group management, OIDC provider setup (`eks:*`).
* **Amazon VPC & EC2**: VPC, Subnets, Internet Gateways, NAT Gateways, Elastic IPs, Route Tables, Security Groups, EC2 instances (`ec2:*`).
* **Amazon RDS**: PostgreSQL DB subnet groups and DB instances (`rds:*`).
* **AWS IAM**: Role and policy creation for EKS clusters, node groups, and ALB controller (`iam:*`).
* **Amazon ECR**: Container image repository management, push/pull authorizations (`ecr:*`).

<details>
<summary>📋 Sample AWS IAM Minimum Policy JSON</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:*",
        "ec2:*",
        "rds:*",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:GetRole",
        "iam:PassRole",
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:CreateOpenIDConnectProvider",
        "iam:DeleteOpenIDConnectProvider",
        "iam:TagOpenIDConnectProvider",
        "iam:CreateInstanceProfile",
        "iam:DeleteInstanceProfile",
        "iam:AddRoleToInstanceProfile",
        "iam:RemoveRoleFromInstanceProfile",
        "ecr:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
```
</details>

### 4. Terraform Installation (v1.10+)
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
terraform -version
```

### 5. Kubernetes Tools (kubectl & Helm)
* **kubectl** (Kubernetes 1.37 compatible):
  ```bash
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  kubectl version --client
  ```
* **Helm 3**:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  helm version
  ```

### 6. Development Runtimes
* **Java**: OpenJDK 21 or 25 LTS (`apt install -y openjdk-25-jre` or Temurin 25)
* **Python**: Python 3.13 / 3.15
* **Node.js**: Node 24 LTS & npm

---

## 🐳 Quick Start: Running the Entire Platform with Docker Compose

To run the complete full-stack platform (PostgreSQL 17, Model, Backend, and Frontend) locally with a single command:

### 1. Clone the Main Repository
```bash
git clone https://github.com/nagaraj602/movie-analyzer-project.git
cd movie-analyzer-project
```

### 2. Clone the Microservice Repositories Side-by-Side
```bash
# Clone sibling microservices
git clone https://github.com/nagaraj602/project-movie-analyzer-backend.git ../project-movie-analyzer-backend
git clone https://github.com/nagaraj602/project-movie-analyzer-model.git ../project-movie-analyzer-model
git clone https://github.com/nagaraj602/project-movie-analyzer-frontend.git ../project-movie-analyzer-frontend
```

### 3. Launch Services with Docker Compose
```bash
docker compose up -d
```

### 4. Verify Running Containers
```bash
docker compose ps
```
Expected output:
```
NAME                      IMAGE                            STATUS                    PORTS
movie-analyzer-database   postgres:17-alpine               Up (healthy)              0.0.0.0:5438->5432/tcp
movie-analyzer-model      movie-analyzer-model:latest      Up (healthy)              0.0.0.0:7380->7380/tcp
movie-analyzer-backend    movie-analyzer-backend:latest    Up (healthy)              0.0.0.0:7280->7280/tcp
movie-analyzer-frontend   movie-analyzer-frontend:latest   Up (healthy)              0.0.0.0:7180->7180/tcp
```

### 5. Access the Platform
* 🌐 **Frontend Application**: [http://localhost:7180](http://localhost:7180)
* ⚙️ **Backend Actuator Health**: [http://localhost:7280/actuator/health](http://localhost:7280/actuator/health)
* 🤖 **AI Model Service Health**: [http://localhost:7380/health](http://localhost:7380/health)
* 🗄️ **PostgreSQL Database**: `localhost:5438` (User: `movieuser`, Pass: `moviepass`, DB: `moviereviews`)

### 6. Test Review Sentiment Analysis
```bash
# Submit a positive movie review
curl -X POST http://localhost:7180/api/reviews \
  -H "Content-Type: application/json" \
  -d '{"movieId":"inception","reviewText":"An absolute Nolan masterpiece with stunning cinematography!"}'

# Check latest reviews
curl http://localhost:7180/api/reviews/latest
```

### 7. Stop Services
```bash
docker compose down
```

---

## ☁️ Cloud Infrastructure Provisioning (Terraform)

Terraform provisions a production-ready AWS foundation including:
* **Networking**: Custom VPC (CIDR `10.0.0.0/16`), 2 Public Subnets, 2 Private Application Subnets, 2 Private Data Subnets, NAT Gateway, Internet Gateway, and Route Tables.
* **Amazon EKS 1.37 Cluster**: Managed Kubernetes control plane with managed node group (`t2.medium` / `t3.medium`), AWS Load Balancer Controller IAM OIDC role, and ConfigMap `aws-auth`.
* **Amazon RDS PostgreSQL 17**: High-performance PostgreSQL database instance in private data subnets.
* **CI/CD Compute**: Jenkins Master EC2 instance with Application Load Balancer, and dedicated Jenkins Worker EC2 agent node with Docker, SonarQube, and Trivy pre-installed.
* **Bastion Host**: Secure public bastion for jumpbox administration and private RDS initialization.

### Step-by-Step Terraform Deployment
```bash
cd terraform

# 1. Initialize Terraform working directory
terraform init

# 2. Review execution plan
terraform plan

# 3. Apply infrastructure
terraform apply -auto-approve
```

Once provisioning completes, Terraform outputs the connection details:
```bash
terraform output
```

To configure `kubectl` to manage the newly provisioned EKS 1.37 cluster:
```bash
aws eks update-kubeconfig --region ap-south-1 --name movie-analyzer-project-eks
kubectl get nodes
```

---

## 🗄️ AWS RDS PostgreSQL Database Setup

The RDS instance runs PostgreSQL 17 in private subnets with security groups restricting access to the Bastion host and EKS cluster worker nodes.

### 1. Database Credentials & Schema
* **Host**: Output from Terraform (`module.rds.db_endpoint`)
* **Master User**: `postgres`
* **Password**: Configured via secrets / Terraform variables
* **Port**: `5432`

### 2. Initialize Database Tables & Seed Data
From the bastion host or local runner with VPC connectivity:
```bash
# Connect using psql
psql -h <RDS_ENDPOINT> -U postgres -d postgres

# Execute the initialization script
\i database_scripts/init.sql
```

The `init.sql` script creates:
* Dedicated user `movieuser` with password `moviepass`
* Multi-environment databases: `moviereviews` (Prod), `moviereviews_dev` (Dev), `moviereviews_staging` (Staging)
* Table `reviews` with indexing on `movie_id`, `created_at`, `sentiment`
* SQL statistical view `review_stats`
* Initial seed data for all 6 catalog movies

---

## 🚀 Jenkins CI/CD Setup & Multibranch Pipelines

Jenkins manages automated testing, static analysis, container image publishing, and Helm releases for all three microservice repositories.

### 1. Required Jenkins Plugins
Install the following plugins via **Manage Jenkins** -> **Plugins** -> **Available Plugins**:
1. **Multibranch Scan Webhook Trigger** (`multibranch-scan-webhook-trigger`): Enables webhook-triggered branch indexing.
2. **SonarQube Scanner for Jenkins** (`sonar`): Integrates SonarQube static analysis and quality gate checks.
3. **GitHub Branch Source** (`github-branch-source`): Discovers branches and pull requests across GitHub repositories.
4. **Pipeline: Shared Groovy Libraries** (`workflow-cps-global-lib`): Consumes `nagaraj602/jenkins-sharedlibraries`.
5. **Docker Pipeline** (`docker-workflow`): Allows pipeline stages to build and run container images.
6. **AWS Credentials Plugin** (`aws-credentials`): Authenticates securely to AWS ECR and EKS.
7. **Credentials Binding Plugin** (`credentials-binding`): Injects secrets into pipeline executions.

### 2. Required Jenkins Credentials
Navigate to **Manage Jenkins** -> **Credentials** -> **System** -> **Global credentials** to add:
* `githubCred`: **Username with Password** (GitHub Username and Personal Access Token with `repo`, `admin:repo_hook` scopes).
* `awsCred`: **AWS Credentials** (Access Key ID and Secret Access Key with ECR/EKS permissions).
* `sonarToken`: **Secret text** (Token generated in SonarQube -> My Account -> Security).

### 3. Register Jenkins Shared Library
1. Go to **Manage Jenkins** -> **System**.
2. Scroll to **Global Pipeline Libraries** and click **Add**:
   * **Name**: `sharedlibrary`
   * **Default version**: `main`
   * **Retrieval method**: Modern SCM -> **Git**
   * **Project Repository**: `https://github.com/nagaraj602/jenkins-sharedlibraries.git`
   * **Credentials**: `githubCred`
3. Click **Save**.

### 4. Configure SonarQube Scanner Tool
1. In **Manage Jenkins** -> **Tools**, scroll to **SonarQube Scanner**:
   * Name: `sonar-scanner`
   * Check **Install automatically**
2. In **Manage Jenkins** -> **System**, scroll to **SonarQube servers**:
   * Name: `sonar-server`
   * Server URL: `http://<jenkins-worker-public-ip>:9000`
   * Server authentication token: `sonarToken`

### 5. Multibranch Pipeline Jobs Configuration
Create two separate Multibranch Pipeline jobs for each microservice repository (`project-movie-analyzer-backend`, `project-movie-analyzer-frontend`, `project-movie-analyzer-model`):

1. **Pull Request Quality Gate (`Jenkinsfile.pr`)**:
   * **Branch Sources**: GitHub (`https://github.com/nagaraj602/<repo-name>.git`, credentials `githubCred`).
   * **Discover pull requests**: *The current pull request revision*.
   * **Build Configuration**: Mode `by Jenkinsfile`, Script Path `Jenkinsfile.pr`.
   * **Scan Triggers**: Check **Scan by webhook**, Token `<repo-name>-pr-trigger`.

2. **Continuous Delivery Pipeline (`Jenkinsfile`)**:
   * **Branch Sources**: GitHub (`https://github.com/nagaraj602/<repo-name>.git`, credentials `githubCred`).
   * **Discover branches**: `main master staging dev`.
   * **Build Configuration**: Mode `by Jenkinsfile`, Script Path `Jenkinsfile`.
   * **Scan Triggers**: Check **Scan by webhook**, Token `<repo-name>-deploy-trigger`.

### 6. GitHub Webhook Integration
In each GitHub repository, navigate to **Settings** -> **Webhooks** -> **Add webhook**:
* **Payload URL**: `http://<JENKINS_PUBLIC_URL>/multibranch-webhook-trigger/invoke?token=<TRIGGER_TOKEN>`
* **Content type**: `application/json`
* **Events**: Select **Let me select individual events** -> check **Pushes** and **Pull requests**.
* **Active**: Checked -> Click **Add webhook**.

---

## 🧪 Testing & Verification

### End-to-End Health Verification Script
Run the automated curl check against all services:
```bash
# Check Model Health
curl -s http://localhost:7380/health | jq .

# Check Backend Health
curl -s http://localhost:7280/actuator/health | jq .

# Check Backend Aggregated Services Status
curl -s http://localhost:7280/api/admin/health | jq .

# Check Frontend Health
curl -s http://localhost:7180/health | jq .
```

---

## 📄 License & Attribution

This project is maintained by [nagaraj602](https://github.com/nagaraj602). Designed as an educational DevOps and Cloud Architecture demonstration showcasing end-to-end continuous integration, continuous delivery, infrastructure as code, and cloud microservices deployment.
