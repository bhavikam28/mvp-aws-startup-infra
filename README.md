# 🚀 MVP AWS Startup: Scalable, Secure, Observable Django on AWS

Welcome to the MVP AWS Startup repository — a fully automated, production-grade deployment of a Django web application on AWS. This project demonstrates end-to-end infrastructure automation, observability, security, and scalability using EC2, Terraform, GitHub Actions, and more.

---

## 📑 Table of Contents

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

## 🌐 Architecture Overview

This project implements an EC2-based Django application deployment backed by:

- Immutable AMIs built with **Packer**
- Infrastructure provisioning via **Terraform**
- GitHub Actions CI/CD with **OIDC authentication** to AWS
- Auto Scaling and Load Balancing via **ALB + ASG**
- Secrets managed via **SSM Parameter Store**
- Logging, metrics, and alarms with **CloudWatch**

![Architecture](./assets/architecture.png)

---

## ✨ Key Features

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

## 🧱 Tech Stack

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

## 💻 Setup & Local Development

```bash
git clone https://github.com/bhavikam28/mvp-aws-startup-infra.git
cd mvp-aws-startup-infra
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py runserver
```
