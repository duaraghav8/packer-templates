#!/bin/bash

set -xeou pipefail

# Install Atlantis
sudo wget -q https://github.com/runatlantis/atlantis/releases/download/v${atlantis_version}/atlantis_linux_amd64.zip -O /tmp/assets/atlantis.zip
sudo unzip -q /tmp/assets/atlantis.zip -d /usr/bin
sudo chown root:root /usr/bin/atlantis
sudo chmod 0755 /usr/bin/atlantis

# Place server configuration
sudo mkdir -p /opt/atlantis/data
sudo mv /tmp/assets/atlantis/server-config.yaml /opt/atlantis/config.yaml
sudo chmod 0664 /opt/atlantis/config.yaml
sudo sed -i "s/__ATLANTIS_SERVER_PORT__/${atlantis_server_port}/" /opt/atlantis/config.yaml