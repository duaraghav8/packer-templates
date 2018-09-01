#!/bin/bash

set -xeou pipefail

sudo wget -q https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip -O /tmp/assets/terraform.zip
sudo unzip -q /tmp/assets/terraform.zip -d /usr/bin
sudo chown root:root /usr/bin/terraform
sudo chmod 0755 /usr/bin/terraform