# Instalador automático para sistemas basados en Debian

Este proyecto proporciona un instalador modular y automatizado para sistemas Debian y Ubuntu. Permite configurar entornos de forma desatendida mediante scripts Bash organizados por fases.

> Desarrollado como herramienta personal para automatizar y estandarizar despliegues en sistemas reales.

---

## Características

- Instalación modular basada en Bash
- Lista de paquetes definida en un archivo `.txt`
- Aplicación de configuraciones del sistema desde plantillas
- Logs detallados por cada fase del proceso
- Fácilmente extensible y adaptable

---

## Estructura del proyecto

```
auto-installer-debian/
├── install.sh                  # Punto de entrada principal
├── scripts/                    # Scripts modulares (ejecutados en orden)
│   ├── 01_prepare.sh
│   ├── 02_update_sources.sh
│   ├── ...
├── config/                     # Archivos de configuración
│   ├── sources.list
│   └── pkgs-list.txt
├── resources/                  # Plantillas y configuraciones del sistema
├── backup/                     # Copias de seguridad automáticas
├── logs/                       # Archivos de log por ejecución
├── test/                       # Scripts de testing
├── docker/                     # Dockerfile y entorno de prueba
└── .github/workflows/          # Linter Shellcheck (CI)
```

---

## Cómo usar

1. Clona el repositorio:

```bash
git clone https://github.com/celiaricogz/auto-installer-debian.git
cd auto-installer-debian
```

2. Edita la lista de paquetes en `config/pkgs-list.txt`:

```txt
htop
curl
vim
git
```

3. Revisa o adapta los archivos de configuración en `resources/`.

4. Ejecuta el script principal como root:

```bash
sudo bash install.sh
```

---

## Uso del Makefile

Este repositorio incluye un `Makefile` para facilitar tareas comunes:

```bash
make run      # Ejecuta el instalador principal
make test     # Lanza el test básico de estructura
make lint     # Ejecuta shellcheck sobre todos los scripts Bash
make logs     # Muestra los últimos logs generados
make clean    # Elimina logs y backups generados
```

---

## Testing e integración continua

El script `test/basic_test.sh` valida la estructura mínima del proyecto (scripts presentes, ejecutables, etc.).

Además, el repositorio incluye un flujo de trabajo de GitHub Actions que ejecuta `shellcheck` automáticamente en cada `push` para asegurar la calidad del código Bash.

---

## Entorno de pruebas con Docker

Para validar la instalación sin afectar el sistema real, puedes usar el `Dockerfile` incluido:

```bash
cd docker
docker build -t auto-installer .
docker run -it --rm auto-installer
```

Esto crea un entorno Debian donde puedes lanzar los scripts de instalación de forma aislada.

---

## ¿Por qué usarlo?

- Estandarizar la configuración de máquinas
- Evitar errores manuales y ahorrar tiempo
- Facilitar el mantenimiento de entornos reproducibles
- Automatizar entornos de desarrollo o testing

---

## Tecnologías utilizadas

- Bash scripting
- APT (Advanced Package Tool)
- Logging con timestamp
- Ejecución modular por fases
- GitHub Actions para control de calidad
- Docker para pruebas de entorno

---

## Próximas mejoras

- [ ] Soporte para otras distribuciones (RHEL, Arch)
- [ ] Detección automática del sistema operativo
- [ ] Función de desinstalación
- [ ] Interfaz interactiva (`whiptail`)
- [ ] Soporte de parámetros por línea de comandos

---

## Autora

**Celia Rico Gutiérrez**  
Ingeniera DevOps en Indra Simulación | Automatización Linux | Infraestructura como Código  
🔗 [LinkedIn](https://www.linkedin.com/in/celiaricogutierrez) | [Malt](https://www.malt.es/profile/celiaricogutierrez)

---

_Última actualización: Julio 2025_