#!/bin/bash

# -------------------------------
# 🚀 Final Automated Deployment Script for Imran's Flask App
# -------------------------------

# Log file
LOGFILE="/var/log/deploy_app.log"

# App directory and Git repo
APP_DIR="/var/www/html/flask-sample-app"
GIT_REPO="https://github.com/imrancode93/bashdemo.git"

echo "===== Deployment started: $(date) =====" | tee -a $LOGFILE

# Step 1: Clone or pull the latest code
if [ -d "$APP_DIR/.git" ]; then
    echo "🔄 Pulling latest code..." | tee -a $LOGFILE
    cd "$APP_DIR" || exit
    git pull origin main >> $LOGFILE 2>&1
else
    echo "📥 Cloning app for the first time..." | tee -a $LOGFILE
    sudo rm -rf "$APP_DIR"
    git clone "$GIT_REPO" "$APP_DIR" >> $LOGFILE 2>&1
    cd "$APP_DIR" || exit
fi

# Step 2: Install dependencies (Flask if needed)
echo "📦 Installing Python requirements (if any)..." | tee -a $LOGFILE
if [ -f "requirements.txt" ]; then
    pip3 install -r requirements.txt >> $LOGFILE 2>&1
fi

# Step 3: Restart web service (NGINX as reverse proxy)
echo "🔁 Restarting NGINX..." | tee -a $LOGFILE
sudo systemctl restart nginx

echo "✅ Deployment finished: $(date)" | tee -a $LOGFILE
