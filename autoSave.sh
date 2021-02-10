#!/bin/bash

# Parameters
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

TAR_DIR=~/dolibarrAutosave
TAR_NAME=dolibarrBackup.tar.gz
TAR_ROOT="${TAR_DIR}/${TAR_NAME}"

# Launch DB backup
echo -e "${NC} Launch DB backup"
sudo automysqlbackup
if [ "$?" = "0" ]; then
  echo -e "${GREEN} Done"
else
  echo -e "${RED} Error in database backup create"
  exit 1
fi

# Configuration file backup
echo -e "${NC} Directory creation for config"
sudo mkdir -p /var/lib/automysqlbackup/daily/config
echo -e "${GREEN} Done"
echo -e "${NC} Copy Dolibarr config file"
sudo cp /etc/dolibarr/conf.php /var/lib/automysqlbackup/daily/config
echo -e "${GREEN} Done"

# Documents backup
echo -e "${NC} Directory creation for htdocs"
sudo mkdir -p /var/lib/automysqlbackup/daily/htdocs
echo -e "${GREEN} Done"
echo -e "${NC} Copy Dolibarr htdocs"
sudo cp -r /usr/share/dolibarr/htdocs /var/lib/automysqlbackup/daily/htdocs
echo -e "${GREEN} Done"

# Documents custom backup
echo -e "${NC} Directory creation for custom htdocs"
sudo mkdir -p /var/lib/automysqlbackup/daily/htdocs/custom
echo -e "${GREEN} Done"
echo -e "${NC} Copy Dolibarr custom htdocs"
sudo cp -r /usr/share/dolibarr/htdocs/custom /var/lib/automysqlbackup/daily/htdocs/custom
echo -e "${GREEN} Done"

# Generated documents backup
echo -e "${NC} Directory creation for htdocs"
sudo mkdir -p /var/lib/automysqlbackup/daily/var/lib/dolibarr/documents
echo -e "${GREEN} Done"
echo -e "${NC} Copy Dolibarr documents"
sudo cp -r /var/lib/dolibarr/documents /var/lib/automysqlbackup/daily/var/lib/dolibarr/documents
echo -e "${GREEN} Done"

# Create archive
echo -e "${NC} Create tar.gz"
sudo tar -czf "${TAR_ROOT}" /var/lib/automysqlbackup/daily

if [ "$?" = "0" ]; then
  echo -e "${GREEN} Done"
  # Remove old files
  echo -e "${NC} Remove temp files"
  sudo rm -rf /var/lib/automysqlbackup/daily/*
  if [ "$?" = "0" ]; then
    echo -e "${GREEN} Done"
    echo -e "${NC} Send data to the cloud using rclone"
    /usr/bin/rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s "${TAR_ROOT}" "gdriveComputingify:dolibarrBackup"
    if [ "$?" = "0" ]; then
      echo -e "${GREEN} Done"
      # Remove tar file
      echo -e "${NC} Remove tar file sent"
      rm -rf "${TAR_ROOT}"
      if [ "$?" = "0" ]; then
        echo -e "${GREEN} Done"
      else
        echo -e "${RED} Error when try to remove tar file backup"
	exit 1
      fi
    else
      echo -e "${RED} Error when sending backup to the cloud"
      exit 1
    fi
  else
    echo -e "${RED} Error removing old file in /var/lib/automysqlbackup/daily"
    exit 1
  fi
else
  echo -e "${RED} Error in compressed file creation"
fi
rm -rf TAR_ROOT
exit 0
