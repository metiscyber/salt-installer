#!/bin/bash

echo "Running Salt Master Install Script"

uname=`uname`

if [[ "$uname" == "Darwin" ]]; then
  echo "This can only be ran on Linux machines"
  exit;
fi

# Install Salt Repos
echo "Installing Salt-Stack Repository Sources"

sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest/salt-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list

echo "Updating Repository Sources"
sudo apt update -y -q

echo "Installing salt-master and salt-api"

sudo apt install salt-master salt-api -y -q

echo "Your Salt Master is installed"
