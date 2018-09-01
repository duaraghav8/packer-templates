#!/bin/bash

set -xeou pipefail
sudo yum update -y

# Install and run Docker
sudo yum install docker-${docker_version} -y
sudo systemctl enable docker.service
sudo systemctl start docker

# Build and install AWS ECR credentials helper
sudo yum install git -y
cd /tmp/assets/docker-ecr
git clone \
    https://github.com/awslabs/amazon-ecr-credential-helper.git \
    /tmp/assets/docker-ecr/amazon-ecr-credential-helper

cd /tmp/assets/docker-ecr/amazon-ecr-credential-helper/
sudo make docker
sudo mv ./bin/local/docker-credential-ecr-login /usr/bin/
cd /home

# Test the installation
docker-credential-ecr-login -v

# Cleanup
sudo /bin/bash -c "docker images -q | xargs -n1 docker rmi"
sudo systemctl stop docker

# Place configuration files
sudo mkdir -p /root/.docker
sudo mv /tmp/assets/docker-ecr/docker-config.json /root/.docker/config.json
sudo chown -R root:root /root/.docker
sudo chmod -R 0644 /root/.docker