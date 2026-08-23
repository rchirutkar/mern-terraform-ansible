# TravelMemory – MERN Deployment on AWS using Terraform & Ansible

## Project Overview

This project demonstrates end-to-end deployment of the **TravelMemory MERN application** on AWS using Infrastructure as Code (Terraform) and Configuration Management (Ansible).

The solution provisions AWS infrastructure, configures application servers automatically, deploys the application, secures MongoDB inside a private subnet, and exposes the application through Nginx.

---

## Architecture

* AWS Region: **ap-south-1 (Mumbai)**
* Infrastructure Provisioning: Terraform
* Configuration Management: Ansible
* Web Server: Ubuntu EC2 + Nginx
* Backend Runtime: Node.js + PM2
* Database: MongoDB Community Edition (Private EC2)
* Reverse Proxy: Nginx
* State Management: Amazon S3 Backend

### Architecture Flow

Internet → Elastic IP → Nginx (Web EC2) → Express Backend (PM2) → MongoDB (Private EC2)

---

## Technology Stack

| Component       | Technology        |
| --------------- | ----------------- |
| Infrastructure  | Terraform 1.13    |
| Configuration   | Ansible           |
| Cloud Provider  | AWS               |
| OS              | Ubuntu            |
| Frontend        | React             |
| Backend         | Node.js / Express |
| Database        | MongoDB           |
| Process Manager | PM2               |
| Reverse Proxy   | Nginx             |

---

## AWS Resources Created

* Custom VPC
* Internet Gateway
* Public Subnet
* Private Subnet
* Route Tables
* Security Groups
* IAM Role
* IAM Instance Profile
* Web EC2 Instance
* MongoDB EC2 Instance
* Elastic IP
* S3 Backend Bucket

> NAT Gateway was created temporarily for package installation and destroyed afterward to reduce AWS cost.

---

## Project Structure

```text
terraform/
modules/
ansible/
backend/
frontend/
README.md
```

---

## Terraform Deployment

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

---

## Ansible Deployment

```bash
ansible all -m ping
ansible-playbook playbooks/database.yml
ansible-playbook playbooks/web.yml
ansible-playbook site.yml
```

---

## Application Deployment

### Backend

```bash
cd backend
npm install
pm2 start npm --name travelmemory-backend -- start
```

### Frontend

```bash
cd frontend
npm install
npm run build
```

Nginx serves the production build.

---

## Nginx Reverse Proxy

* `/` → React Build
* `/api/*` → Express Backend (`localhost:5000`)

---

## Security Features

* MongoDB deployed in private subnet.
* SSH restricted to administrator IP.
* MongoDB accessible only from Web EC2 Security Group.
* IAM Role attached to EC2.
* Elastic IP attached only to Web EC2.

---

## Cost Optimization

* No Application Load Balancer.
* No Auto Scaling Group.
* No DynamoDB lock table.
* No Secrets Manager.
* NAT Gateway destroyed after installation.
* Elastic IP attached only while EC2 is running.

---

## Validation

* Terraform remote state working.
* Ansible playbooks executed successfully.
* Backend managed using PM2.
* Frontend accessible through Nginx.
* MongoDB connected successfully.
* API available via `/api/trip`.

---

## Cleanup

Destroy infrastructure:

```bash
terraform destroy
```

Destroy only Elastic IP:

```bash
terraform destroy -target=module.elastic_ip
```

Destroy only NAT Gateway:

```bash
terraform destroy -target=module.nat_gateway
```

---

## Author

**Ranjeet Chirutkar**

AWS • Terraform • Ansible • DevOps Assignment
