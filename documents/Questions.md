
- > Q. Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now. module.vpc.aws_vpc.this: Creating... Error: creating EC2 VPC: operation error EC2: CreateVpc, https response error StatusCode: 403, RequestID: 403e8753-6836-4686-b7ca-324b72b5a3f7, api error UnauthorizedOperation: You are not authorized to perform this operation. User: arn:aws:iam::xxxxxxxxxxxxx:user/terraform-user is not authorized to perform: ec2:CreateVpc on resource: arn:aws:ec2:ap-south-1:xxxxxxxxxxxxx:vpc/* because no identity-based policy allows the ec2:CreateVpc action

- > Q. Instead of importing existing SSH key from my wsl to ec2, can we use pem file from ec2? I already have a travel-key pem file with me in wsl as well.
Getting error after terraform validate
╷
│ Error: Reference to undeclared resource
│
│   on modules/ec2-db/main.tf line 3, in resource "aws_instance" "mongodb":
│    3:   ami = data.aws_ami.ubuntu.id
│
│ A data resource "aws_ami" "ubuntu" has not been declared in module.mongodb_ec2.
╵
╷
│ Error: Reference to undeclared resource
│
│   on modules/ec2-db/outputs.tf line 2, in output "instance_id":
│    2:   value = aws_instance.web.id
│
│ A managed resource "aws_instance" "web" has not been declared in module.mongodb_ec2.
╵
╷
│ Error: Reference to undeclared resource
│
│   on modules/ec2-db/outputs.tf line 6, in output "public_ip":
│    6:   value = aws_instance.web.public_ip
│
│ A managed resource "aws_instance" "web" has not been declared in module.mongodb_ec2.
╵
╷
│ Error: Reference to undeclared resource
│
│   on modules/ec2-db/outputs.tf line 10, in output "private_ip":
│   10:   value = aws_instance.web.private_ip
│
│ A managed resource "aws_instance" "web" has not been declared in module.mongodb_ec2.
╵
╷
│ Error: Reference to undeclared resource
│
│   on modules/ec2-web/main.tf line 3, in resource "aws_instance" "web":
│    3:   ami = data.aws_ami.ubuntu.id
│
│ A data resource "aws_ami" "ubuntu" has not been declared in module.web_ec2.


- > Q. Should we add 'instance_name' in ec2-web/output.tf? Are we placing MongoDB EC2 in the public subnet now or in next phase?

- >Q. getting error connecting with mongo private ip as below:
 ansible all -m ping
web-server | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Unhandled error in Python interpreter discovery for host db-server: Failed to connect to the host via ssh:
Connection timed out during banner exchange  Connection to UNKNOWN port 65535 timed out
db-server | UNREACHABLE! => {
    "changed": false,
    "msg": "Data could not be sent to remote host \"10.20.2.110\". Make sure this host can be reached over ssh: Connection timed out during banner exchange\r\nConnection to UNKNOWN port 65535 timed out\r\n",
    "unreachable": true
}

> A. The error is not Ansible—it's our AWS Security Group design. We built MongoDB in a private subnet, but we only allowed SSH from your laptop IP, not from the Web EC2 (bastion).
>
> This is a classic AWS networking issue and takes about 5 minutes to fix.
>
>Current MongoDB Security Group likely has:

Port | Source
---  | ---
22   | laptop IP (allowed_ssh_cidr) ❌
27017 | Web Security Group ✅

> When using ProxyJump, SSH reaches MongoDB from the Web EC2's private IP, not from your laptop.
>
> So AWS blocks port 22.

This means:

Traffic    | Allowed?
--- | ---
Laptop → MongoDB SSH | ❌ No
Web EC2 → MongoDB SSH | ✅ Yes
Web EC2 → MongoDB (27017)| ✅ Yes

This is the secure architecture the assignment expects.

- > Q. ansible ping works and shows success for both ec2. then i tested with ssh to each as asked. the web ssh work well, but after that when i tried mongo ssh it is showing below error: ubuntu@ip-xx-xx-xxx-125:~$ ssh ubuntu@xx.x.xx.110
The authenticity of host 'xx.x.xx.110 (xx.x.xx.110)' can't be established.
ED25519 key fingerprint is SHA256:HxxxxxxxxxxxxxYTVK/1D+xxxxxxxxxxxxxxxxxxxx.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'xx.x.xx.110' (ED25519) to the list of known hosts.
ubuntu@xx.x.xx.110: Permission denied (publickey).
ubuntu@ip-10-20-1-125:~$ ssh ubuntu@xx.x.xx.110
ubuntu@xx.x.xx.110: Permission denied (publickey).

> the Web EC2 tries to authenticate using keys on that server (~/.ssh/id_rsa, etc.). Since travel-key.pem is not present on the Web EC2, authentication fails with: Permission denied (publickey)

>Never SSH from Web EC2 to MongoDB manually.
>
>Use ProxyJump from your laptop whenever needed:
>
```bash
ssh -J ubuntu@<WEB_PUBLIC_IP> \
    -i ~/.ssh/travel-key.pem \
    ubuntu@<MONGODB_PRIVATE_IP>
```
> This is the same mechanism Ansible is already using successfully.
>
> Do not copy travel-key.pem to the Web EC2.

- > Q. ERROR! the role 'common' was not found in ~/projects/TerraformHV/mern-terraform-ansible/ansible/playbooks/roles:~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:~/projects/TerraformHV/mern-terraform-ansible/ansible/playbooks

The error appears to be in '~/projects/TerraformHV/mern-terraform-ansible/ansible/playbooks/database.yml': line 6, column 7, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

  roles:
    - common
      ^ here

This is how our tree inside ansible folder looks like:
```
.
├── ansible.cfg
├── group_vars
│   └── all.yml
├── inventory.ini
├── playbooks
│   └── database.yml
└── roles
    ├── backend
    │   ├── files
    │   ├── handlers
    │   ├── tasks
    │   └── templates
    ├── common
    │   ├── files
    │   ├── handlers
    │   ├── tasks
    │   │   └── main.yml
    │   └── templates
    ├── frontend
    │   ├── files
    │   ├── handlers
    │   ├── tasks
    │   └── templates
    ├── mongodb
    │   ├── files
    │   ├── handlers
    │   ├── tasks
    │   │   └── main.yml
    │   └── templates
    │       └── mongod.conf.j2
    └── nodejs
        ├── files
        ├── handlers
        ├── tasks
        │   └── main.yml
        └── templates
```

> Q. 
My repository structure is option A.
After running `pm2 start npm --name travelmemory-backend -- start` getting errored as status for backend.

> Q. The script section is "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "node index.js"
  },
  
  and the output of npm start is:

0|travelme |
0|travelme | Node.js v20.20.2
0|travelme | DB ERROR:  MongooseError: The `uri` parameter to `openUri()` must be a string, got "undefined". Make sure the first parameter to `mongoose.connect()` or `mongoose.createConnection()` is a string.
0|travelme |     at _createMongoClient (/opt/travelmemory/backend/node_modules/mongoose/lib/connection.js:805:11)
0|travelme |     at NativeConnection.openUri (/opt/travelmemory/backend/node_modules/mongoose/lib/connection.js:742:29)
0|travelme |     at Mongoose.connect (/opt/travelmemory/backend/node_modules/mongoose/lib/index.js:406:15)
0|travelme |     at Object.<anonymous> (/opt/travelmemory/backend/conn.js:4:10)
0|travelme |     at Module._compile (node:internal/modules/cjs/loader:1521:14)
0|travelme |     at Module._extensions..js (node:internal/modules/cjs/loader:1623:10)
0|travelme |     at Module.load (node:internal/modules/cjs/loader:1266:32)
0|travelme |     at Module._load (node:internal/modules/cjs/loader:1091:12)
0|travelme |     at Module.require (node:internal/modules/cjs/loader:1289:19)
0|travelme |     at require (node:internal/modules/helpers:182:18)
0|travelme | node:internal/process/promises:391
0|travelme |     triggerUncaughtException(err, true /* fromPromise */);
0|travelme |     ^
0|travelme |


> Q. cat ../backend/index.js
const express = require('express')
const cors = require('cors')
require('dotenv').config()

const app = express()
PORT = process.env.PORT
const conn = require('./conn')
app.use(express.json())
app.use(cors())

const tripRoutes = require('./routes/trip.routes')

app.use('/trip', tripRoutes) // http://localhost:3001/trip --> POST/GET/GET by ID

app.get('/hello', (req,res)=>{
    res.send('Hello World!')
})

app.listen(PORT, ()=>{
    console.log(`Server started at http://localhost:${PORT}`)
})