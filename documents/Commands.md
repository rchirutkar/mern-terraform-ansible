# Aws Configuration

- check aws version

```bash
aws --version
# output: aws-cli/2.34.29 Python/3.14.3 Windows/10 exe/AMD64`
```

- configure aws profile

```bash
aws configure --profile terraform-user
```

- check aws user identity 

```bash
aws sts get-caller-identity
```

- check terraform-user identity

```bash
aws sts get-caller-identity --profile terraform-user
```

- Find your IP
```bash
curl ifconfig.me
cp ~/travel-key.pem ~/.ssh/
chmod 400 ~/.ssh/travel-key.pem
ssh -i ~/.ssh/travel-key.pem ubuntu@<WEB_PUBLIC_IP>

```

- verify terraform version

```bash
terraform version
```

- Terraform init

```bash
terraform init
terraform validate
```

- Terraform Modules

```bash 
mkdir -p modules/vpc modules/security-groups modules/ec2-web modules/ec2-db modules/iam modules/nat-gateway
```

- Terraform Validation

```bash
terraform fmt -recursive
terraform validate
# to save it in a file, used for production
terraform plan -out=tfplan 
terraform apply tfplan
# use it for development
terraform plan 
terraform apply

```

- Generate a Debug Log

    - Linux
    ```bash
    export TF_LOG=DEBUG
    export TF_LOG_PATH=./terraform.log
    terraform apply
    ```

    - Windows

    ```powershell
    $env:TF_LOG="DEBUG"
    $env:TF_LOG_PATH="./terraform.log"
    terraform apply
    ```

Open the newly generated terraform.log file and scroll to the bottom to find the underlying API error.

- Terraform Validate and Apply

```bash
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

- Check Terraform State

```bash
terraform state list
terraform output
```
Look for entries like:

```
module.iam.aws_iam_role.ec2
module.iam.aws_iam_instance_profile.ec2
module.iam.aws_iam_role_policy_attachment.ssm
```
<br>

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
ssh -J ubuntu@<WEB_PUBLIC_IP> -i ~/.ssh/travel-key.pem ubuntu@<MONGODB_PRIVATE_IP>
# output: ubuntu@ip-10-20-2-xxx

# Test MongoDB Authentication and verify the user exists
mongosh -u traveladmin -p 'TravelMemory@123' --authenticationDatabase admin
#Expected:
#test>

# then
show dbs

exit
```

- Test Ansible Connectivity

    From inside the ansible folder:

```bash
ansible all -m ping

Expected:
web-server | SUCCESS
db-server  | SUCCESS
```

- Use Terraform outputs directly to generate the inventory.

    After every terraform apply, run:

```bash
terraform output
```
Expected output something like:

```
web_public_ip = "13.xx.xx.xx"
mongodb_private_ip = "10.20.2.xxx"
```
Use those values in inventory.ini.

> This values will be generated to inventory.ini automatically from Terraform outputs, so we don't have to edit IP addresses manually. 

---

<br>

- Update Terrafrom after changes in tf file as 

```bash
terraform plan
terraform apply
# Expected output:
#  Plan: 1 to change, 0 to add, 0 to destroy.
```

- To delete only NAT gateway, Elastic IP

```bash
terraform destroy -target=module.nat_gateway
terraform destroy -target=module.elastic_ip

# to detroy everything
terraform destroy
```