# Base image: stable Debian
FROM debian:bullseye

LABEL maintainer="Celia Rico Gutiérrez"
LABEL description="Test environment for auto-installer-debian"

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools + test dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    sudo \
    gnupg \
    dos2unix \
    shellcheck \
    cron \
    systemd \
    net-tools \
    vim \
    git \
    && apt-get clean

# Create non-root user (optional)
RUN useradd -ms /bin/bash installer && echo "installer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Ensure execution permissions
RUN chmod +x install.sh scripts/*.sh test/*.sh

# Default command when starting the container
CMD ["bash"]
