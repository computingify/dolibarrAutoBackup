#!/bin/bash

# Parameters
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

##Update Raspberry
echo -e "Update the Raspberry Pi"
sudo apt update
sudo apt -y upgarde
sudo apt autoremove

exit 0
