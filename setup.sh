#!/bin/bash


# === Update and upgrade system packages ===
sudo apt update -y && sudo apt upgrade -y


# === Install Node.js and npm ===
sudo apt install nodejs -y
sudo apt install npm -y


# === Install global packages ===
sudo npm install -g pm2 serve


echo "✅ System and Node.js setup completed!"


# === Install backend dependencies and run server ===
npm install
pm2 start server.js --name ecommerce-backend
echo "✅ Backend server started with PM2."


# === Setup frontend ===
cd client
npm install


# === Install react-scripts explicitly in case it's missing ===
#npm install react-scripts --save
npm install

# === Get EC2 public IP ===
EC2_PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# === Overwrite existing .env in client/src/ with actual IP ===
echo "REACT_APP_API=http://$EC2_PUBLIC_IP:8080" > src/.env

# === Build frontend ===
npm run build

# === Serve frontend using 'serve' ===
pm2 serve build 3000 --name ecommerce-frontend --spa

echo "✅ Frontend running at: http://$EC2_PUBLIC_IP:3000"
echo "✅ Backend running at: http://$EC2_PUBLIC_IP:8080"
