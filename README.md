# MVP AWS Startup: Scalable, Secure, Observable Django on AWS

Welcome to the MVP AWS Startup repository — a fully automated, production-grade deployment of a Django web application on AWS. This project demonstrates end-to-end infrastructure automation, observability, security, and scalability using EC2, Terraform, GitHub Actions, and more.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Setup & Local Development](#setup--local-development)
- [CI/CD Workflow](#cicd-workflow)
- [Infrastructure Breakdown](#infrastructure-breakdown)
- [Monitoring & Observability](#monitoring--observability)
- [Published Articles](#published-articles)
- [License](#license)

---

## Architecture Overview

This project implements an EC2-based Django application deployment backed by:

- Immutable AMIs built with **Packer**
- Infrastructure provisioning via **Terraform**
- GitHub Actions CI/CD with **OIDC authentication** to AWS
- Auto Scaling and Load Balancing via **ALB + ASG**
- Secrets managed via **SSM Parameter Store**
- Logging, metrics, and alarms with **CloudWatch**

---

## Key Features

- Django + PostgreSQL web application (Gunicorn + Nginx)
- Immutable AMI builds with **HashiCorp Packer**
- Infrastructure as Code using **Terraform**
- Automated CI/CD pipeline with **GitHub Actions**
- Secure, scalable deployments with **ASG** and **ALB**
- Centralized logging and custom metrics using **CloudWatch Agent**
- Secrets management via **SSM Parameter Store**
- Database hosted on **Amazon RDS**, migrated using **AWS DMS**
- Load testing using **Locust**

---

## Tech Stack

| Category         | Tools & Services                                        |
|------------------|---------------------------------------------------------|
| Framework        | Django (Python)                                         |
| Web Server       | Gunicorn + Nginx                                        |
| Infrastructure   | Terraform, Packer                                       |
| CI/CD            | GitHub Actions (OIDC Auth)                              |
| Cloud Services   | AWS (EC2, ALB, ASG, RDS, S3, CloudFront, SSM)           |
| Monitoring       | CloudWatch Dashboards, Logs, SNS                        |
| Secrets          | SSM Parameter Store                                     |
| DB Migration     | AWS Database Migration Service (DMS)                    |
| Load Testing     | Locust                                                  |

---

## Setup & Local Development

```bash
git clone https://github.com/bhavikam28/mvp-aws-startup-infra.git
cd mvp-aws-startup-infra
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py runserver
```
🔐 **Update environment variables, secrets, and `settings.py` as required.**

---

## CI/CD Workflow

### 1. Build AMI with Packer
- Triggered on new GitHub release
- Installs Django app, dependencies, Nginx, Gunicorn, CloudWatch Agent

### 2. Provision Infrastructure with Terraform
- Deploys EC2 with Auto Scaling Group (ASG)
- Sets up Application Load Balancer (ALB)
- Creates IAM roles, security groups, and VPC networking components

### 3. Secrets & Configuration
- Uses **SSM Parameter Store** for secure secrets management
- Injects app configuration into EC2 instances via **User Data**

---

## Infrastructure Breakdown

### EC2 + ASG + ALB
- Custom AMIs launched into **Auto Scaling Group**
- **ALB** routes external traffic to instances
- Zero-downtime deployment using rolling updates

### PostgreSQL (RDS)
- AWS-managed PostgreSQL instance
- Migrated using **AWS Database Migration Service (DMS)**

### Storage
- Uploaded media/images stored in **Amazon S3**
- Delivered globally via **CloudFront CDN**

### Security
- IAM roles with **least-privilege access**
- EC2 access through **SSM Session Manager** (no SSH needed)

---

## Monitoring & Observability

- **CloudWatch Dashboards** for EC2, ALB, and RDS
- **CloudWatch Agent** collects memory, CPU, and disk metrics
- Log-based metric filters (e.g., image upload events)
- **SNS Alerts** for high CPU/memory or app failures
- Full observability provisioned via **Terraform**

---

## Published Articles

Explore the complete implementation and real-world use cases:

- [Launching MVP with Automated Infrastructure (Packer, Terraform, AWS SSM)](https://towardsaws.com/launching-mvp-with-automated-infrastructure-packer-amis-terraform-aws-ssm-ba77d9aac3a2)
- [From EC2 to AWS Managed Services — Migrating to RDS with DMS](https://towardsaws.com/from-ec2-to-aws-managed-services-migrating-to-aws-rds-with-dms-d16eb89605f3)
- [How I Scaled to 250+ Concurrent Users: Load Testing + ASG + ALB](https://towardsaws.com/how-i-scaled-to-250-concurrent-users-on-aws-load-testing-auto-scaling-load-balancing-37a591eac6f6)
- [Building Proactive Monitoring on AWS with EC2 + CloudWatch + Terraform](https://towardsaws.com/building-proactive-monitoring-on-aws-with-ec2-cloudwatch-terraform-from-setup-scripts-to-71bdc0e4a7dc)

---

## License

**MIT © [Bhavika Mantri](https://technestbybhavika.com)** — Free to use, fork, and build upon.

