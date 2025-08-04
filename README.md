# Automatic Installer for Debian-based Systems

This project provides a modular and automated installer for Debian and Ubuntu systems. It allows unattended environment setup through Bash scripts organized by phases.

> Developed as a personal tool to automate and standardize deployments on real systems.

---

## Features

- Modular installation based on Bash
- Package list defined in a `.txt` file
- System configuration applied from templates
- Detailed logs for each phase of the process
- Easily extensible and adaptable

---

## Project Structure

```
auto-installer-debian/
├── install.sh                  # Main entry point
├── scripts/                    # Modular scripts (executed in order)
│   ├── 01_prepare.sh
│   ├── 02_update_sources.sh
│   ├── ...
├── config/                     # Configuration files
│   ├── sources.list
│   └── pkgs-list.txt
├── resources/                  # System templates and configurations
├── backup/                     # Automatic backups
├── logs/                       # Log files per execution
├── test/                       # Testing scripts
├── docker/                     # Dockerfile and test environment
└── .github/workflows/          # Shellcheck linter (CI)
```

---

## How to Use

1. Clone the repository:

```bash
git clone https://github.com/celiaricogz/auto-installer-debian.git
cd auto-installer-debian
```

2. Edit the package list in `config/pkgs-list.txt`:

```txt
htop
curl
vim
git
```

3. Review or adapt the configuration files in `resources/`.

4. Run the main script as root:

```bash
sudo bash install.sh
```

---

## Using the Makefile

This repository includes a `Makefile` to simplify common tasks:

```bash
make run      # Runs the main installer
make test     # Launches the basic structure test
make lint     # Runs shellcheck on all Bash scripts
make logs     # Shows the latest generated logs
make clean    # Removes generated logs and backups
```

---

## Testing and Continuous Integration

The `test/basic_test.sh` script validates the minimum project structure (scripts present, executables, etc.).

Additionally, the repository includes a GitHub Actions workflow that automatically runs `shellcheck` on every `push` to ensure Bash code quality.

---

## Test Environment with Docker

To validate the installation without affecting your real system, you can use the included `Dockerfile`:

```bash
cd docker
docker build -t auto-installer .
docker run -it --rm auto-installer
```

This creates a Debian environment where you can run the installation scripts in isolation.

---

## Why Use It?

- Standardize machine configuration
- Avoid manual errors and save time
- Facilitate maintenance of reproducible environments
- Automate development or testing environments

---

## Technologies Used

- Bash scripting
- APT (Advanced Package Tool)
- Logging with timestamp
- Modular execution by phases
- GitHub Actions for quality control
- Docker for environment testing

---

## Upcoming Improvements

- [ ] Support for other distributions (RHEL, Arch)
- [ ] Automatic OS detection
- [ ] Uninstall function
- [ ] Interactive interface (`whiptail`)
- [ ] Command-line parameter support

---

## Author

**Celia Rico Gutiérrez**  
DevOps Engineer — Dockerized delivery, modular architecture, CI/CD pipelines 

[<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" alt="LinkedIn Logo" width="35" style="vertical-align:middle; margin-right:8px;"/>](https://www.linkedin.com/in/celiaricogutierrez)
[<img src="https://play-lh.googleusercontent.com/1r1DdWXDT9K7D2yBwPkVyXQFEjLL0cMrR6SxBvcNXXwpi8aZN0ZKS61CVdtvK6pmpg" alt="Malt Logo" width="35" style="vertical-align:middle; margin-right:8px;"/>](https://www.malt.es/profile/celiaricogutierrez)
[<img src="https://images.icon-icons.com/3781/PNG/512/upwork_icon_231982.png" alt="Malt Logo" width="35" style="vertical-align:middle;"/>](https://www.upwork.com/freelancers/~01898dfb872ff48b7a?mp_source=share)

---

_\~Last updated: August 2025\~_
