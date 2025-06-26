# ⚙️ Instalador automático para sistemas Debian y Ubuntu

Este proyecto proporciona un sistema de instalación desatendida y automatizada para sistemas basados en Debian, como Debian 11/12 y Ubuntu. Permite instalar fácilmente paquetes esenciales, aplicar configuraciones del sistema y generar un log del proceso.

> 🛠️ Proyecto personal en uso real, diseñado para automatizar y facilitar la configuración de entornos Linux. En proceso de desarrollo activo.

---

## 🚀 ¿Qué hace este instalador?

- Lee un listado de paquetes desde un archivo `.txt` personalizado
- Instala los paquetes usando `apt`
- Aplica configuraciones del sistema desde ficheros de recursos
- Genera un log con el estado del proceso de instalación
- Pensado para facilitar despliegues rápidos y homogéneos

---

## 📁 Estructura del proyecto

```
.
├── src/
│   ├── debian-installation.sh        # Script principal de instalación
│   ├── packages-installation.sh      # Script auxiliar para gestionar instalación por lotes
│   └── resources/
│       └── pkgs-list.txt             # Lista de paquetes a instalar
├── resources/
│   ├── sshd_config, ntp.conf, fstab  # Configuraciones opcionales
├── packages/
│   ├── gcc  # Paquetes que se necesiten añadir de manera local
├── LOG/                              # Carpeta de logs generados
├── backup-files/                     # Backups opcionales (vacío por defecto)
└── README.md
```

---

## 🧪 Cómo usar

1. Clona el repositorio:

```bash
git clone https://github.com/celiaricogz/auto-installer-debian.git
cd auto-installer-debian
```

2. Añade o edita el archivo de paquetes en `src/resources/pkgs-list.txt`:

```txt
htop
curl
vim
git
```

3. Edita los archivos contenidos en `resources` con la configuración especifica que se busque.

4. Ejecuta el script principal como `root` o con `sudo`:

```bash
sudo bash src/debian-installation.sh
```

---

## 🧠 ¿Para qué usarlo?

- Automatizar el setup de máquinas virtuales o físicas
- Estandarizar entornos de trabajo
- Acelerar despliegues en entornos de testing
- Generar entornos reproducibles y fácilmente documentables

---

## 🛠️ Tecnologías utilizadas

- Bash scripting
- APT package manager
- Logs personalizados
- Configuración modular de sistema

---

## 🧩 Próximas mejoras

- [ ] Soporte para RHEL, CentOS, Arch
- [ ] Detección de distro
- [ ] Opción de desinstalación/reversión
- [ ] Interfaz interactiva tipo `whiptail`
- [ ] Parámetros vía línea de comandos

---

## 👩‍💻 Autora

**Celia Rico Gutiérrez**  
Ingeniera DevOps & Fullstack especializada en automatización, scripting y sistemas Linux.  
🔗 [LinkedIn](https://www.linkedin.com/in/celiaricogutierrez) | [Malt](https://www.malt.es/profile/celiaricogutierrez)

---

📅 _Última actualización: Junio 2025_

