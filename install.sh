#!/bin/bash
set -euo pipefail

current_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
flag_file="$current_path/flags/state"

mkdir -p "$current_path/flags"

# Leer fase actual (o empezar desde cero)
current_phase=$(cat "$flag_file" 2>/dev/null || echo "start")

case "$current_phase" in
  start)
    bash "$current_path/scripts/01_prepare.sh"
    echo "phase1" > "$flag_file"
    (crontab -l 2>/dev/null; echo "@reboot sudo bash $current_path/install.sh") | crontab -
    reboot
    ;;
  phase1)
    bash "$current_path/scripts/02_update_sources.sh"
    bash "$current_path/scripts/03_nvidia_drivers.sh"
    echo "phase2" > "$flag_file"
    reboot
    ;;
  phase2)
    bash "$current_path/scripts/04_packages.sh"
    bash "$current_path/scripts/05_user_config.sh"
    bash "$current_path/scripts/08_services_config.sh"
    bash "$current_path/scripts/09_samba.sh"
    bash "$current_path/scripts/10_octave.sh"
    bash "$current_path/scripts/12_ntp.sh"
    bash "$current_path/scripts/13_network.sh"
    echo "done" > "$flag_file"
    crontab -r
    ;;
  done)
    echo "Installation already completed. Exiting."
    exit 0
    ;;
  *)
    echo "Unknown phase state: $current_phase"
    exit 1
    ;;
esac
