#!/bin/bash


# shellcheck disable=SC2039
ARGUMENT_LIST=(
    "master-ip"
    "local-id"
)

# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --"$opts"

# shellcheck disable=SC2039
while [[ $# -gt 0 ]]; do
    case "$1" in
        --master-ip)
            masterIp=$2
            shift 2
            ;;

        --local-id)
            localId=$2
            shift 2
            ;;

        *)
            break
            ;;
    esac
done

echo "Running Salt Minion Install Script"

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

echo "Installing salt-minion"

sudo apt install salt-minion -y -q
echo "Configuring your Salt Minion"

localConf="/etc/salt/minion.d/local.conf"

if [ ! -e "$localConf" ]; then
  sudo touch /etc/salt/minion.d/local.conf
  echo "master: $masterIp" >> /etc/salt/minion/local.conf
  echo "id: $localId" >> /etc/salt/minion/local.conf
fi

sudo service salt-minion restart

echo "Your Salt Minion has been installed"
