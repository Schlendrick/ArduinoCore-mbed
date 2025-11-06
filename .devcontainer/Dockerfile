# Use official Microsoft Dev Containers base image
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Avoid interactive apt prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    git \
    mercurial \
    wget \
    curl \
    ca-certificates \
    unzip \
    tar \
    ninja-build \
    cmake \
    gcc-arm-none-eabi \
    gdb-multiarch \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify ARM GCC installation (for debugging)
RUN arm-none-eabi-gcc --version

# Use the default vscode user (already exists in base image)
USER vscode
WORKDIR /workspaces/ArduinoCore-mbed

# Default shell
CMD [ "bash" ]
