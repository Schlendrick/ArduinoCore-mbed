# Use official Microsoft Dev Containers base image
FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Avoid interactive apt prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
# Remove any existing ARM toolchain to avoid conflicts
RUN apt-get update && apt-get remove -y gcc-arm-none-eabi || true

# Install system dependencies first
RUN apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-psutil \
    git \
    mercurial \
    wget \
    curl \
    ca-certificates \
    unzip \
    tar \
    xz-utils \
    ninja-build \
    cmake \
    gdb-multiarch \
    jq \
    rsync \
    libudev-dev \
    libusb-1.0-0-dev \
    libhidapi-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install GCC ARM 10.3 toolchain manually (the specific version needed)
# Detect architecture and download appropriate version
RUN ARCH=$(uname -m) && \
    cd /tmp && \
    if [ "$ARCH" = "x86_64" ]; then \
        echo "Downloading x86_64 ARM toolchain..." && \
        wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 && \
        tar -xjf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -C /opt && \
        rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2; \
    elif [ "$ARCH" = "aarch64" ]; then \
        echo "Downloading aarch64 ARM toolchain..." && \
        wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-aarch64-linux.tar.bz2 && \
        tar -xjf gcc-arm-none-eabi-10.3-2021.10-aarch64-linux.tar.bz2 -C /opt && \
        rm gcc-arm-none-eabi-10.3-2021.10-aarch64-linux.tar.bz2; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi

# Add ARM toolchain to PATH
ENV PATH="/opt/gcc-arm-none-eabi-10.3-2021.10/bin:${PATH}"

# Install Rust (needed for cmsis-pack-manager)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Note: ARM GCC verification skipped during build to avoid Rosetta issues on Apple Silicon
# The toolchain will be verified at runtime when the container starts

# Clone the Arduino mbed-os repository and checkout the correct branch
# This is done at build time since it's a large download and rarely changes
RUN git clone https://github.com/arduino/mbed-os.git /tmp/mbed-os && \
    cd /tmp/mbed-os && \
    git checkout extrapatches-6.17.0 && \
    # Make the directory accessible to vscode user
    chown -R vscode:vscode /tmp/mbed-os

# Switch to vscode user for the remainder
USER vscode
WORKDIR /workspaces/ArduinoCore-mbed

# Default shell
CMD [ "bash" ]
