#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/../scripts/common.sh"

log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Updating bash, ssh and lightdm configuration"

# Backup and apply .bashrc
mv /root/.bashrc "$backup_path"/.bashrc
cp ""$resources_path""/bashrc /root/.bashrc
dos2unix /root/.bashrc
source /root/.bashrc

# Backup and apply sshd_config
mv /etc/ssh/sshd_config "$backup_path"/sshd_config
cp ""$resources_path""/sshd_config /etc/ssh/

# Backup and apply lightdm config
mv /etc/lightdm "$backup_path"/lightdm
cp -r ""$resources_path""/lightdm /etc/
