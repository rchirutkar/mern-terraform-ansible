## Clone Repository on Web EC2

```bash
# SSH into Web EC2.

ssh -i ~/.ssh/travel-key.pem ubuntu@13.234.37.208

# Create deployment directory:

sudo mkdir -p /opt/travelmemory
sudo chown ubuntu:ubuntu /opt/travelmemory

cd /opt/travelmemory

# Clone your GitHub repository (Account 2).

git clone https://github.com/rchirutkar/mern-terraform-ansible.git .
```

## Install Backend Dependencies

```bash
cd backend

npm install

```

## Install Frontend Dependencies

```bash
cd ../frontend

npm install

# then build
npm run build
```

## Start Backend with PM2

```bash
cd ../backend

pm2 start npm --name travelmemory-backend -- start

# If backend uses Express entry file:

pm2 start server.js --name travelmemory-backend
# or 
pm2 start index.js --name travelmemory-backend

# Check PM2 logs:

pm2 logs travelmemory-backend --lines 50

# or 

pm2 describe travelmemory-backend

# Check:

pm2 status
# or 
ps aux | grep node
# or
ps aux | grep node | grep -v grep | wc -l

# to kill node
killall -9 node 

# Expected:

travelmemory-backend online

# Save PM2:

pm2 save

pm2 startup

# Restart PM2
pm2 restart travelmemory-backend

# Delete backend 
pm2 delete travelmemory-backend

pm2 start npm --name travelmemory-backend -- start

pm2 save

pm2 status

```

## Start Frontend with PM2

```bash
# Check for the package structrure
# change according to package in .env 
cat package.json | grep vite

# Install & Build Frontend
npm install

npm run build

# Serve Frontend with PM2
sudo npm install -g serve

# Start frontend:
pm2 start "serve -s dist -l 3000" --name travelmemory-frontend

# Save PM2 configuration:
pm2 save

# Check:
pm2 status

# Expected:
# travelmemory-backend    online
# travelmemory-frontend   online

# to list
pm2 list

# Stop PM2 frontend temporarily.
pm2 stop travelmemory-frontend

# Now run manually:
cd /opt/travelmemory/frontend
serve -s build -l 3000

# Expected terminal output:
# Serving!
# Local:    http://localhost:3000
# Network:  http://10.20.1.xxx:3000

# to list down how many react process running
ps aux | grep -E "vite|react-scripts|serve" | grep -v grep
# to count 
ps aux | grep -E "vite|react-scripts" | grep -v grep | wc -l
# by port trackinng
sudo lsof -i :5173
sudo lsof -i :3000

# quick clean up 
npx kill-port 5173
npx kill-port 3000
```
