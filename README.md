# Programmatic Image Storage and Processing Service
This repository contains everything needed to deploy, scale, and monitor a high-performance image storage and processing API using Docker, Kubernetes, Helm, Terraform, and GitHub Actions CI/CD on AWS.

## 📌Project Overview
This service provides programmatic access to store, retrieve, and process images with capabilities like:
- Bulk storage & retrieval
- Image transformations (compression, rotation, filters, thumbnailing, masking)
- Operations on remote images via URL
- High-performance web services for bulk processing
- Scalability & cost-efficiency on AWS

## ✅ Prerequisites
```
Before deploying this project, ensure the following tools, services, and configurations are in place:<br>
🛠 Tooling
- Docker: For building and pushing container images
- AWS CLI v2: For authentication and infrastructure interaction
- kubectl: To interact with the Kubernetes cluster
- Helm v3: For managing Kubernetes deployments
- Terraform v1.4+: For provisioning AWS infrastructure

☁️ AWS Requirements 
- An active AWS account
- A configured ECR repository (Docker images are pushed here)
- IAM credentials with sufficient permissions (for ECR, EKS, EFS, ALB, ACM, Route 53)
- A domain name managed in Route 53

🔐 GitHub Actions CI/CD Secrets 
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
```
## 📂 Repository Structure
```
📦 image-api-task                    
├── 📁 image-api/                 # Contains source code
│   ├── Dockerfile                # Dockerfile to containerize the application
├── 📁 helm/                      # Helm charts for Kubernetes deployment
│   ├── values.yaml               # Configurable parameters
│   ├── Chart.yaml                # Helm metadata
│   ├── templates/                # Kubernetes manifests (Deployment, Service, Ingress, etc.)
├── 📁 terraform/                 # Terraform scripts to provision AWS infrastructure
│   ├── environment/prod/         # environment-specific configurations (dev,prod etc)
│   ├── modules                   # Modules for vpc,eks,efs.
├── .github/workflows/deploy.yaml # GitHub Actions pipeline for CI/CD
├──.gitignore                     # files ignored by Git
└── README.md                     # Documentation
```
## 🚀 Quick Start
Step 1: Authenticate AWS CLI
```
aws configure
It will ask you for Your access key,Your secret key, Default region name, Default output format
```
Step 2: Deploy AWS Infrastructure
```
terraform init
terraform apply
```
Step 3: Build & Push Docker Image
```
Authenticate with AWS ECR
- aws ecr get-login-password --region <AWS_REGION> | docker login --username AWS --password-stdin <ECR_REPO>

Build the Docker image
- docker build -t image-api ./image-api/

Tag the Docker image
- docker tag image-api:latest <ECR_REPO>/image-api:latest

Push the image to ECR
- docker push <ECR_REPO>/image-api:latest
```
Step 4: Get the EFS File System ID
```
aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --region <AWS_REGION>
```
Step 5: Connect to Kubernetes and Deploy
```
1. Update kubeconfig for EKS
aws eks update-kubeconfig --region <AWS_REGION> --name <EKS_CLUSTER_NAME>
This ensures kubectl and helm commands interact with the right cluster.

2. Verify Connection to Kubernetes
kubectl get nodes

3. Deploy the Helm Chart
helm upgrade --install image-api-release ./helm \
  --namespace image-api --create-namespace \
  --set efs.fileSystemId=<efs-id> \
  --set image.repository=<ECR_REPO>/image-api \
  --set image.tag=latest
```
## 💡 Key Considerations & Best Practices
### 1. How do we automate deployment when changes are merged into the main branch and ensure smooth rollouts of new features and updates, and rollback if needed?
```
To ensure seamless, automated deployment, we use GitHub Actions with rollback support to trigger a CI/CD pipeline whenever changes are pushed to the main branch.
📦 Deployment Workflow  
1. Checkout & AWS Authentication – Pulls latest code and authenticates AWS.  
2. Docker Build & Push – Builds image, tags with commit SHA, and pushes to Amazon ECR.  
3. Helm Lint Check – Ensures Helm chart is valid before deployment.  
4. Helm Deployment – Deploys to EKS with:  
   - Versioned image (`$GITHUB_SHA`)  
   - Namespace isolation (`image-api`)  
   - EFS integration (`efs.fileSystemId=<efs-id>`)  
5. Smart Rollout & Rollback Strategy
   - Automatic Rollback on Failure: If the Helm deployment fails, the pipeline captures the error and triggers an
     automatic rollback 
   - Versioned Deployments: Each deployment uses a unique image tag ($GITHUB_SHA) instead of latest, ensuring
     rollback to any previous version is possible.
   - Safe Helm Upgrades: Helm ensures only valid configurations are applied.
   - Real-time Monitoring & Alerts: Prometheus & Grafana track deployment performance, and alerts notify engineers of 
     failures.
```
### 2. What AWS Infrastructure is Used to Deploy the API and ensure that it can be accessed programmatically via a URL? How we would manage scaling, storage, and high availability.
```
The API is deployed on AWS EKS (Elastic Kubernetes Service) to ensure scalability, high availability, and programmatic access via a URL.
☁️ Infrastructure Components:
1. Amazon EKS – Orchestrates containerized workloads with automatic scaling.
2. AWS Application Load Balancer (ALB) & Ingress Controller  – Provides a stable, public-facing endpoint for API access.
3. Amazon EFS (Elastic File System) – Ensures persistent and shared storage for images.
4. Amazon ECR (Elastic Container Registry) – Stores versioned Docker images for seamless deployments.
5. AWS Auto Scaling & Horizontal Pod Autoscaler (HPA) – Dynamically adjusts resource allocation based on demand.
6. High Availability & Scalability:
   - Multi-AZ Deployment: EKS nodes are distributed across multiple AWS Availability Zones for resilience.
   - Auto Scaling Policies: Pods scale up/down automatically based on CPU/memory usage.
   - Persistent Storage – EFS ensures no data loss across deployments.
```
### 3. How might we make it easier to deploy changes to that infrastructure or deploy to new environments?
```
To streamline deployment and manage multiple environments efficiently. We use Kubernetes and Terraform for automation, scalability, and cost efficiency.
🛠️ Key Strategies for Deployment & Environment Management
1. Infrastructure as Code (IaC) with Terraform – Ensures consistent and repeatable AWS infrastructure provisioning.
2. Kubernetes & Helm Charts – Simplifies application deployment and configuration management across different environments.
3. Modular Terraform Configurations – Enables easy replication of infrastructure (e.g., dev, staging, production).
4. Parameterized Helm Values – Allows environment-specific configurations (e.g., resource limits, storage settings).
5. GitHub Actions for CI/CD – Automates deployment, reducing manual effort and minimizing human error.
6. Cost Optimization with Auto Scaling – Ensures efficient resource utilization, avoiding over-provisioning.
```
### Which tools would you use for monitoring,logging, and alerting? What metrics would you focus on for this service? How would you troubleshoot performance issues with both infrastructure and application layers?
```
For monitoring, logging, and alerting, we will use Prometheus and Grafana, 0-=\as they provide deep visibility into both infrastructure and application performance.
1. Prometheus (Monitoring & Alerting)
  - Collects real-time metrics from Kubernetes clusters, nodes, and application pods.
  - Stores time-series data for analysis.
  - Integrated Alertmanager for sending notifications (Slack, Email, PagerDuty).
2. Grafana (Visualization & Dashboards)
  - Connects with Prometheus to visualize metrics via custom dashboards.
  - Helps in detecting performance issues at a glance.

Key Metrics to Monitor
1. Application-Level Metrics (via Prometheus exporters)
  - API Response Time: Track latency across API .
  - Request Rate:	Number of requests per second.
  - Error Rate:	percentage of failed requests (4xx, 5xx).
  - Image Processing Time: Time taken to process images.
  - Queue Length:	Pending image processing requests.
2. Infrastructure-Level Metrics (via node-exporter, kube-state-metrics)
  - CPU & Memory Usage:	Ensure nodes and pods have enough resources.
  - Disk I/O:	Detect slow storage operations.
  - Pod Restarts:	Identify frequent crashes (e.g., OOM kills).
  - Network Latency:	Check response times for API calls.
  - EFS Storage Usage:	Monitor disk consumption to avoid out-of-space errors.

Troubleshooting Strategy
- High Resource Usage – Use Grafana to detect CPU/memory spikes. Ensure HPA and Cluster Autoscaler are working.
- Disk/EFS Bottlenecks – Monitor efs_io_latency and filesystem usage. Adjust throughput or access patterns if needed.
- Pod Failures – Check kubectl describe and logs for crashes or OOMKilled errors. Validate resource limits and probes.
- Application Errors – Use Prometheus metrics to track latency and 4xx/5xx errors. Investigate failing endpoints or 
  services.
- Network/Ingress Issues – Monitor ingress latency and ALB-related metrics. Verify DNS and ingress configurations.
- Slow Image Processing – Monitor job duration and queue length. Scale workers or optimize the pipeline.
- Alerting Gaps – Validate Prometheus alert rules and Alertmanager integrations (Slack, Email, etc.).
```
### What security best practices would you implement?
```
🔐 Security Best Practices
- IAM Roles with Least Privilege
   Define fine-grained IAM roles and policies to limit access to only what’s necessary.
- Secrets Management
   Store sensitive data like API keys and DB credentials using Kubernetes Secrets or AWS Secrets Manager.
- Private Container Registry & Scanning
   Use AWS ECR with vulnerability scanning enabled to store and verify Docker images.
- Kubernetes RBAC
   Enforce Role-Based Access Control to define user and service permissions clearly within the cluster.
- Network Policies
   Implement Kubernetes Network Policies to limit pod-to-pod communication where applicable.
- Regular Updates
   Patch base images, dependencies, and Helm charts frequently to mitigate known vulnerabilities.
- Audit Logging & Monitoring
   Monitor Kubernetes audit logs for unauthorized access attempts.
- Resource Limits
   Define CPU and memory limits for all pods to prevent abuse and ensure fair resource usage.
```

