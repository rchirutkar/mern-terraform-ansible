
## Create 2 EC2 instances and secure networking
Resource|	Purpose
---|---
IAM Role + Instance Profile	| EC2 permissions
Web Security Group	|SSH + HTTP + React + API
MongoDB Security Group	|Only Web EC2 can access MongoDB
Web EC2	|Node.js + React + Express
MongoDB EC2	|Private MongoDB server

---

## Should MongoDB EC2 be in Public or Private Subnet?
We'll use Ansible through the Web EC2 (bastion/proxy) to configure MongoDB.

This gives better marks because it demonstrates secure AWS networking.

We'll SSH only to the Web EC2 from your laptop. Web EC2 will communicate with MongoDB EC2 over its private IP.