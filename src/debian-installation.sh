#!/bin/bash

# Definir el archivo de log con nombre dinámico basado en fecha y hora
LOG_FILE="/root/installation/LOG/installation_log_$(date +'%Y%m%d_%H%M%S').log"

previous_debian_frontend=$DEBIAN_FRONTEND
export DEBIAN_FRONTEND=noninteractive

# Función para escribir en el log
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Archivo de marcador temporal
FLAG="/root/installation/src/flags/continue_after_reboot"

# Verificar si se pasó el argumento 'dgcc'
DOWNGRADE_GCC=false
NORT=false
ISA=false
for arg in "$@"; do
    case $arg in
        dgcc)
            DOWNGRADE_GCC=true
            ;;
        nort)
            NORT=true
            ;;
        isa)
            ISA=true
            ;;
    esac
done

if [ "$NORT" = true ]; then
    # Modificar el archivo sources.list
    mv /etc/apt/sources.list /root/installation/backup-files/sources.list
    cp /root/installation/resources/sources.list /etc/apt
    apt install -y dos2unix >> "$LOG_FILE" 2>&1
    # Convertir archivos de Windows a formato Unix
    dos2unix /root/installation/resources/* >> "$LOG_FILE" 2>&1
    dos2unix /root/installation/src/debian-installation.sh >> "$LOG_FILE" 2>&1
    dos2unix /root/installation/src/packages-installation.sh >> "$LOG_FILE" 2>&1
    dos2unix /root/installation/src/resources/pkgs-list.txt >> "$LOG_FILE" 2>&1

    for i in {1..5}; do
        apt update && break || sleep 1 >> "$LOG_FILE" 2>&1
    done
    echo "Part 1 completed" >> "$FLAG"
fi



# Primera Parte: Antes del primer reinicio
if [ ! -f "$FLAG" ]; then
    crontab -r
    echo "" | tee -a "$LOG_FILE"
    echo "*************FIRST EXECUTION**************" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    # Modificar el archivo sources.list
    mv /etc/apt/sources.list /root/installation/backup-files/sources.list
    cp /root/installation/resources/sources.list /etc/apt
    apt install -y dos2unix >> "$LOG_FILE" 2>&1
    # Convertir archivos de Windows a formato Unix
    dos2unix /root/installation/resources/* >> "$LOG_FILE" 2>&1
    dos2unix /root/installation/src/debian-installation.sh >> "$LOG_FILE" 2>&1
    dos2unix /root/installation/src/packages-installation.sh >> "$LOG_FILE" 2>&1
    dos2unix /root/installation/src/resources/pkgs-list.txt >> "$LOG_FILE" 2>&1

    for i in {1..5}; do
        apt update && break || sleep 1 >> "$LOG_FILE" 2>&1
    done

    # Actualizar paquetes hasta que no haya más actualizaciones

    apt install -y linux-image-rt-amd64 >> "$LOG_FILE" 2>&1
    apt install -y linux-headers-rt-amd64 >> "$LOG_FILE" 2>&1

    echo "" | tee -a "$LOG_FILE"
    echo "*************FIRST REBOOT**************" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    # Crear el archivo de marcador
    echo "Part 1 completed" >> "$FLAG"

    # Agregar el script a cron para ejecutarse al reiniciar
    (crontab -l ; echo "@reboot /root/installation/src/debian-installation.sh") | crontab -

    # Reiniciar el sistema
    /sbin/reboot
    exit 0
fi

if grep -q "Part 1 completed" "$FLAG"; then
    : > "$FLAG"
    echo "" | tee -a "$LOG_FILE"
    echo "*************SECOND EXECUTION**************" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    echo "" | tee -a "$LOG_FILE"
    echo "----------NVIDIA DRIVER INSTALLATION AND CONFIGURATION-----------" | tee -a "$LOG_FILE"

    # Instalar drivers Nvidia y configurar DKMS
    apt install -y nvidia-driver >> "$LOG_FILE" 2>&1
    apt install -y firmware-misc-nonfree >> "$LOG_FILE" 2>&1
    if lsmod | grep -q nvidia; then
        echo "NVIDIA module already loaded" >> "$LOG_FILE" 2>&1
    else
        if modprobe nvidia >> "$LOG_FILE" 2>&1; then
            echo "NVIDIA module loaded successfully" >> "$LOG_FILE" 2>&1
        else
            echo "Error: Failed to load NVIDIA module" >> "$LOG_FILE" 2>&1
        fi
    fi
    apt install --reinstall -y nvidia-kernel-dkms >> "$LOG_FILE" 2>&1
    mv /var/lib/dkms/nvidia-current/470.256.02/source/dkms.conf /root/installation/backup-files/dkms.conf
    cp /root/installation/resources/dkms.conf /var/lib/dkms/nvidia-current/470.256.02/source/
    export IGNORE_PREEMPT_RT_PRESENCE=1
    /sbin/dpkg-reconfigure nvidia-kernel-dkms >> "$LOG_FILE" 2>&1

    echo "" | tee -a "$LOG_FILE"
    echo "*************SECOND REBOOT**************" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    # Crear el archivo de marcador
    echo "Part 2 completed" >> "$FLAG"

    # Reiniciar el sistema
    /sbin/reboot
    exit 0

fi

# Segunda Parte: Después del primer reinicio
if grep -q "Part 2 completed" "$FLAG"; then
    : > "$FLAG"
    echo "" | tee -a "$LOG_FILE"
    echo "*************SECOND EXECUTION**************" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    echo "" | tee -a "$LOG_FILE"
    echo "----------NVIDIA VERIFICATION-----------" | tee -a "$LOG_FILE"

    # Verificación de Nvidia
    nvidia-smi >> "$LOG_FILE" 2>&1

    #añadir la arquitectura de 32
    dpkg --add-architecture i386
    echo "" | tee -a "$LOG_FILE"
    echo "----------ARCH VERIFICATION-----------" | tee -a "$LOG_FILE"
    dpkg --print-foreign-architecture >> "$LOG_FILE" 2>&1

    # Configurar el script de instalación adicional
    cd /root/installation/src
    chmod +x /root/installation/src/packages-installation.sh
    
    echo "" | tee -a "$LOG_FILE"
    echo "----------PACKAGES INSTALLATION SCRIPT-----------" | tee -a "$LOG_FILE"
    ./packages-installation.sh >> "$LOG_FILE" 2>&1
    

    echo "" | tee -a "$LOG_FILE"
    echo "----------USER CONFIG-----------" | tee -a "$LOG_FILE"
    # Crear usuario de prueba y asignar permisos
    chown -R indra:indra /home/indra

    echo "" | tee -a "$LOG_FILE"
    echo "USERS CREATED: indra" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"

    echo "" | tee -a "$LOG_FILE"
    echo "----------Safe Shutdown-----------" | tee -a "$LOG_FILE"
    cd /root/installation/resources/shutdown
    chmod +x install.sh
    ./install.sh >> "$LOG_FILE" 2>&1
    systemctl status safe-shutdown.service >> "$LOG_FILE" 2>&1

    if [ "$DOWNGRADE_GCC" = true ]; then
        echo "" | tee -a "$LOG_FILE"
        echo "----------Downgrade gcc-----------" | tee -a "$LOG_FILE"
        cd /root/installation/resources/gcc-4.8.5
        chmod +x host-tools.sh
        ./host-tools.sh >> "$LOG_FILE" 2>&1
        gcc --version >> "$LOG_FILE" 2>&1
    fi

    if [ "$ISA" = true ]; then
        echo "" | tee -a "$LOG_FILE"
        echo "----------MOUNT ISA and NAS volumes-----------" | tee -a "$LOG_FILE"
        tail -n 4 /root/installation/resources/fstab >> /etc/fstab
        mount -a >> "$LOG_FILE" 2>&1

        echo "" | tee -a "$LOG_FILE"
        echo "----------ISA CONFIG-----------" | tee -a "$LOG_FILE"
        cp /root/installation/resources/
    fi

    echo "" | tee -a "$LOG_FILE"
    echo "----------BASH, SSH AND LIGHTDM CONFIGURATION-----------" | tee -a "$LOG_FILE"

    # Actualización de configuración de bash, ssh y lightdm
    mv /root/.bashrc /root/installation/backup-files/.bashrc
    cp /root/installation/resources/bashrc /root/.bashrc
    dos2unix /root/.bashrc >> "$LOG_FILE" 2>&1
    source ~/.bashrc
    mv /etc/ssh/sshd_config /root/installation/backup-files/sshd_config
    cp /root/installation/resources/sshd_config /etc/ssh/
    mv /etc/lightdm /root/installation/backup-files/lightdm
    cp -r /root/installation/resources/lightdm /etc/

    echo " -> Bash, ssh and lightdm configuration completed." | tee -a "$LOG_FILE"

    echo "" | tee -a "$LOG_FILE"
    echo "----------SAMBA CONFIGURATION-----------" | tee -a "$LOG_FILE"

    apt install -y samba >> "$LOG_FILE" 2>&1
    apt install -y samba-common-bin >> "$LOG_FILE" 2>&1

    # Configuración de Samba
    mv /etc/samba/lmhosts /root/installation/backup-files/lmhosts
    mv /etc/samba/smbusers /root/installation/backup-files/smbusers
    mv /etc/samba/smb.conf /root/installation/backup-files/smb.conf
    cp /root/installation/resources/lmhosts /etc/samba/
    cp /root/installation/resources/smbusers /etc/samba/
    cp /root/installation/resources/smb.conf /etc/samba/
    testparm /etc/samba/smb.conf >> "$LOG_FILE" 2>&1
    (echo "ofic1"; echo "ofic1") | smbpasswd -a ofic
    /etc/init.d/smbd restart >> "$LOG_FILE" 2>&1

    echo " -> Samba configuration completed." | tee -a "$LOG_FILE"

    # Copiar rc.local a la carpeta tmp
    mv /etc/rc.local /root/installation/backup-files
    cp /root/installation/resources/rc.local /etc

    echo "" | tee -a "$LOG_FILE"
    echo "----------OCTAVE CONFIGURATION-----------" | tee -a "$LOG_FILE"

    apt install -y octave >> "$LOG_FILE" 2>&1
    apt install -y liboctave-dev >> "$LOG_FILE" 2>&1

    # Instalar paquetes de Octave
    octave --eval "
    pkg install /root/installation/packages/octave_packages/control-3.2.0.tar.gz;
    pkg install /root/installation/packages/octave_packages/io-2.4.13.tar.gz;
    pkg install /root/installation/packages/octave_packages/signal-1.4.1.tar.gz;
    pkg install /root/installation/packages/octave_packages/struct-1.0.16.tar.gz;
    pkg install /root/installation/packages/octave_packages/optim-1.6.0.tar.gz;
    pkg list
    " >> "$LOG_FILE" 2>&1
    
    echo " -> Octave configuration completed." | tee -a "$LOG_FILE"

    echo "" | tee -a "$LOG_FILE"
    echo "----------LATEX CONFIGURATION-----------" | tee -a "$LOG_FILE"
    cd /root/installation/resources/instalacion_latex
    
    cd relsize
    tex relsize.ini
    cd ..
    cp -r relsize/ /usr/share/texlive/texmf-dist/tex/latex/
    
    cd nonfloat
    tex nonfloat.ini
    cd ..
    cp -r nonfloat/ /usr/share/texlive/texmf-dist/tex/latex/
    
    cd multirow
    tex multirow.ini
    cd ..
    cp -r multirow/ /usr/share/texlive/texmf-dist/tex/latex/
    
    cd arydshln
    tex arydshln.ini
    cd ..
    cp -r arydshln/ /usr/share/texlive/texmf-dist/tex/latex/
    
    cd minitoc
    tex minitoc.ini
    cd ..
    cp -r minitoc/ /usr/share/texlive/texmf-dist/tex/latex/  
    
    cd /usr/share/texlive/texmf-dist
    mv ls-R ls-R.copy
    ls-R>ls-R
    
    mktexlsr >> "$LOG_FILE" 2>&1
    
    echo "" | tee -a "$LOG_FILE"
    echo "----------NTP CONFIGURATION-----------" | tee -a "$LOG_FILE"

    apt install -y ntp >> "$LOG_FILE" 2>&1
    apt install -y ntpdate >> "$LOG_FILE" 2>&1

    mv /etc/ntp.conf /root/installation/backup-files/ntp.conf
    cp /root/installation/resources/ntp.conf /etc
    
    /etc/init.d/ntp restart >> "$LOG_FILE" 2>&1
    ntpdc -n --eval "
    dmp
    exit
    " >> "$LOG_FILE" 2>&1
    
    echo "" | tee -a "$LOG_FILE"
    echo "----------NETWORKS CONFIGURATION-----------" | tee -a "$LOG_FILE"
    # Configuración de red
    mv /etc/network/interfaces /root/installation/backup-files/interfaces
    cp /root/installation/resources/interfaces /etc/network/
    chmod 777 /etc/network/interfaces
    /etc/init.d/networking stop
    /etc/init.d/networking start
    /sbin/ifconfig >> "$LOG_FILE" 2>&1

    #(echo "newpswd"; echo "newpswd") |passwd root >> "$LOG_FILE" 2>&1

    echo "Configuration script completed. Please review and complete manual graphics settings (if necessary) and power management."

    echo "" | tee -a "$LOG_FILE"
    echo "*************FINAL REBOOT**************" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    
    # Limpia el marcador y cron
    rm -f "$FLAG"
    crontab -r
    
    export DEBIAN_FRONTEND=$previous_debian_frontend

    /sbin/reboot
    exit 0
fi