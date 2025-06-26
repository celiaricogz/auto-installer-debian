#!/bin/bash

#LOG
LOG_FILE="/root/installation/LOG/pkgs_log_$(date +'%Y%m%d_%H%M%S').log"
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

#PKGS FILE
PACKAGES_FILE="/root/installation/src/resources/pkgs-list.txt"
packages=()
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PACKAGES_FILE")

# Arrays para seguimiento de instalaciones
installed_packages=()
failed_packages=()

# Instalar paquetes y mostrar un mensaje despues de cada instalacion
for package in "${packages[@]}"; do
  echo "Instalando $package..." | tee -a "$LOG_FILE"
  if apt install -y $package; then >> "$LOG_FILE" 2>&1
    echo "$package instalado." | tee -a "$LOG_FILE"
    installed_packages+=($package)
  else
    echo "Error al instalar $package." | tee -a "$LOG_FILE"
    failed_packages+=($package)
  fi
  echo "" | tee -a "$LOG_FILE"
done

# Resumen de paquetes instalados y no instalados
echo "======================================"
echo "Resumen de la instalacion de paquetes:"
echo "======================================"

if [ ${#installed_packages[@]} -gt 0 ]; then
  echo "Paquetes instalados:" | tee -a "$LOG_FILE"
  for package in "${installed_packages[@]}"; do
    echo " $package" | tee -a "$LOG_FILE"
  done
else
  echo "No se instalaron paquetes." | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"

if [ ${#failed_packages[@]} -gt 0 ]; then
  echo "Paquetes que no se pudieron instalar:" | tee -a "$LOG_FILE"
  for package in "${failed_packages[@]}"; do
    echo " $package" | tee -a "$LOG_FILE"
  done
else
  echo "Todos los paquetes se instalaron correctamente." | tee -a "$LOG_FILE"
fi

echo "" | tee -a "$LOG_FILE"
