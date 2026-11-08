#!/bin/bash
# Author: Gian Micael Blanco
# Project: Secure Cloud-Hosted Portfolio on AWS EC2
# GitHub: https://github.com/GianMicael/aws-portfolio-project
#
# EC2 User Data script for Ubuntu.
# Runs once, automatically, as root when the instance first boots.
# It installs Nginx, a firewall, fail2ban and automatic security updates.

set -e
export DEBIAN_FRONTEND=noninteractive

# 1. Update the system
apt-get update -y
apt-get upgrade -y

# 2. Install web server, firewall, brute-force protection, auto-updates
apt-get install -y nginx ufw fail2ban unattended-upgrades

# 3. Firewall: allow SSH first (so you don't lock yourself out), then web traffic
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

# 4. Start services now and on every reboot
systemctl enable --now nginx
systemctl enable --now fail2ban

# 5. Turn on automatic security updates
echo 'APT::Periodic::Update-Package-Lists "1";' >  /etc/apt/apt.conf.d/20auto-upgrades
echo 'APT::Periodic::Unattended-Upgrade "1";'   >> /etc/apt/apt.conf.d/20auto-upgrades

# 6. Placeholder page (you will replace this with your real index.html)
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head><title>Gian Micael Blanco | AWS Server</title></head>
<body style="font-family:Arial;text-align:center;margin-top:80px;">
  <h1>Gian Micael Blanco's AWS server is live!</h1>
  <p>Deployed automatically with an EC2 User Data script.</p>
  <p><a href="https://github.com/GianMicael/aws-portfolio-project">View the project on GitHub</a></p>
</body>
</html>
EOF
