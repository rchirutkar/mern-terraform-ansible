## Disable MongoDB Authentication Temporarily

SSH into MongoDB EC2.

```bash 
# Edit the config:

sudo nano /etc/mongod.conf

# Find this section:

# security:
#   authorization: enabled

# Change it to:

# security:
#   authorization: disabled

# Save and exit.

# Restart MongoDB:

sudo systemctl restart mongod
sudo systemctl status mongod --no-pager

# Expected:

# Active: active (running)
```

## Create (or Reset) the Admin User

Open MongoDB shell:

```bash
mongosh

# Run these commands exactly:

use admin

db.createUser({
  user: "traveladmin",
  pwd: "TravelMemory@123",
  roles: [
    { role: "root", db: "admin" }
  ]
})

# Expected:

# Successfully added user
# If it says user already exists

# Run instead:

use admin

db.changeUserPassword(
  "traveladmin",
  "TravelMemory@123"
)

# Expected:

# { ok: 1 }

# Now verify:

db.getUsers()

# You should see `traveladmin`

```

## Re-enable Authentication

```bash
# Edit again:

sudo nano /etc/mongod.conf

# Change back to:

# security:
#   authorization: enabled

# Restart:

sudo systemctl restart mongod

```

## Verify Authentication

```bash
# Now authenticate properly:

mongosh \
  -u traveladmin \
  -p 'TravelMemory@123' \
  --authenticationDatabase admin
  
```

## Verify DB after elastic IP update

```bash 

ssh -J ubuntu@3.7.133.46 -i ~/.ssh/travel-key.pem ubuntu@10.20.2.110

mongosh -u traveladmin -p 'TravelMemory@123' --authenticationDatabase admin

show dbs

use travelmemory

show collections

db.tripdetails.find().pretty()

```