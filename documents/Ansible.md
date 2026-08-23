# Ansible folder structure

```
ansible/
│
├── ansible.cfg
├── inventory.ini
├── site.yml
├── group_vars/
│   ├── all.yml
│
├── roles/
│   ├── common/
│   ├── nodejs/
│   ├── mongodb/
│   ├── backend/
│   └── frontend/
│
└── playbooks/
    ├── web.yml
    ├── database.yml
    └── security.yml
```
---

Create inventory.ini (Bastion Method)

Use Terraform outputs for IPs.

```INI
[web]
web-server ansible_host=<WEB_PUBLIC_IP>

[database]
db-server ansible_host=<MONGODB_PRIVATE_IP>

[database:vars]
ansible_ssh_common_args='-o ProxyJump=ubuntu@<WEB_PUBLIC_IP> -o IdentityFile=~/.ssh/travel-key.pem'
```

Replace:

<WEB_PUBLIC_IP> = terraform output web_public_ip

<MONGODB_PRIVATE_IP> = terraform output mongodb_private_ip

This is the important part

ProxyJump tells Ansible:

```
Laptop
   │ SSH (22)
   ▼
Web EC2 (Public Subnet)
   │ SSH (22 via Security Group)
   ▼
MongoDB EC2 (Private Subnet)
```

This is exactly how a bastion host works.

---


<br>

- Install Ansible in WSL

```bash
sudo apt update
sudo apt install ansible -y
ansible --version
```

- Create Ansible folder structure

```bash
mkdir -p ansible/{roles,playbooks,group_vars}
mkdir -p ansible/roles/{common,nodejs,mongodb,backend,frontend}/{tasks,handlers,templates,files}
```

- Test Web EC2

```bash
ssh -i ~/.ssh/travel-key.pem ubuntu@<WEB_PUBLIC_IP>
# output: ubuntu@ip-10-20-1-xxx
exit
```

- Test MongoDB EC2 Through Bastion
```bash
ssh -J ubuntu@<WEB_PUBLIC_IP> \
    -i ~/.ssh/travel-key.pem \
    ubuntu@<MONGODB_PRIVATE_IP>
# output: ubuntu@ip-10-20-2-xxx
exit
```

- Test Ansible Connectivity

    From inside the ansible folder:

```bash
ansible all -m ping

# Expected:
# web-server | SUCCESS
# db-server  | SUCCESS
```

---
<br>

## Install MongoDB and Web EC2 Using Ansible
EC2 Server |	Software
--|--
Web EC2|	Node.js 20 LTS, npm, PM2, Git, Nginx (later)
MongoDB EC2|	MongoDB Community Edition 8.x


<br>

- Create Database Playbook and run 

```bash
cd ansible

ansible-playbook playbooks/database.yml

# Expected output:
# PLAY RECAP
# db-server : ok=...
```

- Verify Ansible Is Using correct Config

```bash
ansible version

#config file = /home/.../mern-terraform-ansible/ansible/ansible.cfg

ansible-config dump | grep ROLE

# If It Still Doesn't Find Roles (Fallback)
# Use an explicit roles path:

ANSIBLE_ROLES_PATH=./roles ansible-playbook playbooks/database.yml

ansible-config dump | grep DEFAULT_ROLES_PATH

# Expected output:
# DEFAULT_ROLES_PATH(.../ansible/roles)
```

- Verify MongoDB

```bash
#SSH using ProxyJump:

ssh -J ubuntu@<WEB_PUBLIC_IP> \
    -i ~/.ssh/travel-key.pem \
    ubuntu@<MONGODB_PRIVATE_IP>
```

Then Run:

```bash
systemctl status mongod --no-pager

# Expected Output:
# Active: active (running)
```

Followed by Run:

```bash
mongod --version

# Expected Output:
# 
```

- Restart MongoDB
```bash
sudo systemctl restart mongod
sudo systemctl status mongod --no-pager
```

- Create Web Playbook

```bash
ansible-playbook playbooks/web.yml

# Expected Output:
# PLAY RECAP
# web-server : ok=...
```

- Verify Web Server

```bash
ssh -i ~/.ssh/travel-key.pem ubuntu@<WEB_PUBLIC_IP>

# Run:

node -v

# Expected output:
# v20.x.x

# Run:

npm -v

# Run:

pm2 -v

# Run:

git --version

```

- Configure both web and mongo ec2 using single command

```bash
ansible-playbook site.yml
```