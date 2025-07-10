#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/../scripts/common.sh"

log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Installing and configuring Samba"

apt install -y samba samba-common-bin

# Backup and replace configuration files
mv /etc/samba/lmhosts $backup_path/lmhosts
mv /etc/samba/smbusers $backup_path/smbusers
mv /etc/samba/smb.conf $backup_path/smb.conf

cp $resources_path/lmhosts /etc/samba/
cp $resources_path/smbusers /etc/samba/
cp $resources_path/smb.conf /etc/samba/

testparm /etc/samba/smb.conf

# Set Samba password for 'user_name' user
(echo "passwd"; echo "passwd") | smbpasswd -a user_name

/etc/init.d/smbd restart
