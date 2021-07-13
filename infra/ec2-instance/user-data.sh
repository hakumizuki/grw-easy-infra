#!/bin/bash

# Update package
sudo yum update -y
# Install and Start Docker
sudo amazon-linux-extras install -y docker
sudo systemctl enable docker.service  # Auto activation
sudo systemctl start docker.service
# docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone growi
sudo yum update -y
sudo yum install git -y

sudo git clone https://github.com/hakumizuki/grw-light-docker-compose.git growi
cd growi
docker-compose up

# Add amazon-linux2 defualt user to docker group
sudo usermod -aG docker ec2-user
