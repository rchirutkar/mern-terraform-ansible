## Verify Git Account
```bash
git config user.name
git config user.email
```


## Commit

```bash
git add .

git status

git commit -m "Complete TravelMemory AWS deployment using Terraform and Ansible"

git push origin main
```

## Push from Laptop (WSL) — Recommended Workflow


Step 1 — Copy Code from EC2 → Laptop

From WSL:

```bash 
scp -i ~/.ssh/travel-key.pem -r \
ubuntu@<ELASTIC_IP>:/opt/travelmemory/backend \
~/projects/TerraformHV/mern-terraform-ansible/

Same for frontend if needed:

scp -i ~/.ssh/travel-key.pem -r \
ubuntu@<ELASTIC_IP>:/opt/travelmemory/frontend \
~/projects/TerraformHV/mern-terraform-ansible/

```
This copies only project code.

Step 2 — Review
```bash
cd ~/projects/TerraformHV/mern-terraform-ansible

git diff
```
Verify only intended changes.

Step 3 — Commit
```bash
git add .

git commit -m "Complete TravelMemory deployment using Terraform and Ansible"
```

Step 4 — Push
```bash
git push origin main
```

This uses your GitHub Account 2 already configured in WSL/VS Code.

Recommendation: Push from WSL instead of EC2.