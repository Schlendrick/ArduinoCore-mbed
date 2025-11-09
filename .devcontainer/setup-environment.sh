#!/bin/bash
set -e

echo "=========================================="
echo "Setting up ArduinoCore-mbed environment..."
echo "=========================================="

# Navigate to workspace
cd /workspaces/ArduinoCore-mbed

# Verify ARM toolchain is available
echo "Checking ARM GCC toolchain..."
if ! command -v arm-none-eabi-gcc &> /dev/null; then
    echo "Error: ARM GCC toolchain not found in PATH"
    echo "Expected path: /opt/gcc-arm-none-eabi-10.3-2021.10/bin"
    exit 1
fi

ARM_GCC_VERSION=$(arm-none-eabi-gcc --version | head -n1)
echo "ARM GCC version: $ARM_GCC_VERSION"

# Check if this is the correct version (10.3)
if [[ ! "$ARM_GCC_VERSION" == *"10.3"* ]]; then
    echo "Warning: Expected GCC ARM 10.3, but found different version"
fi

# Remove any existing venv (in case of rebuild)
if [ -d ".venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf .venv
fi

# Create fresh Python 3.11 virtual environment
echo "Creating Python virtual environment..."
python3 -m venv .venv

# Activate the virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate

# Upgrade pip first
echo "Upgrading pip..."
pip install --upgrade pip

# Install mbed-cli
echo "Installing mbed-cli..."
pip install mbed-cli

# Install essential packages with correct versions
echo "Installing mbed-os dependencies with correct versions..."
pip install colorama "urllib3>=1.26.5" junit-xml "PyYAML>=5.4" jsonschema==2.6.0 \
            "future>=0.18.0,<1.0" six==1.12.0 "requests>=2.20,<3" "idna>=2,<2.8" \
            "pyserial>=3,<=3.4" "jinja2>=2.11.3" "intelhex>=2.3.0,<3.0.0" \
            "mbed-ls>=1.5.1,<2.0" "mbed-host-tests>=1.4.4,<2.0" "mbed-greentea>=0.2.24,<2.0" \
            "beautifulsoup4>=4,<=4.6.3" "pyelftools<=0.28" "pycryptodome>=3.9.3,<4" \
            "pyusb>=1.0.0,<2.0.0" "cryptography>=3.2,<4" "Click>=7.0,<8" "cbor>=1.0.0"

# Check if mbed-os exists and edit requirements.txt to remove hidapi constraints
if [ -d "/tmp/mbed-os" ]; then
    echo "Checking mbed-os requirements..."
    if [ -f "/tmp/mbed-os/requirements.txt" ]; then
        echo "Editing mbed-os requirements.txt to remove hidapi version constraints..."
        # Create a backup and remove hidapi version constraints
        cp /tmp/mbed-os/requirements.txt /tmp/mbed-os/requirements.txt.backup
        sed -i 's/hidapi==.*/hidapi/' /tmp/mbed-os/requirements.txt
        sed -i 's/hidapi>=.*,<.*/hidapi/' /tmp/mbed-os/requirements.txt
        
        echo "Installing remaining mbed-os requirements..."
        pip install -r /tmp/mbed-os/requirements.txt || echo "Some packages failed to install but continuing..."
    else
        echo "Note: /tmp/mbed-os/requirements.txt not found, but essential packages already installed"
    fi
else
    echo "Note: /tmp/mbed-os directory not found, but essential packages already installed"
fi

# Try to install optional packages (allow failures)
echo "Installing optional packages..."
pip install hidapi 2>/dev/null || echo "hidapi installation failed, but not critical"
pip install psutil 2>/dev/null || echo "Using system psutil package"
pip install cmsis-pack-manager 2>/dev/null || echo "cmsis-pack-manager installation failed, but not required"

# Verify mbed-cli installation
echo "Verifying installations..."
mbed --version
python --version

# Make build scripts executable
chmod +x build_limbed.sh 2>/dev/null || echo "build_limbed.sh not found"
chmod +x mbed-os-to-arduino* 2>/dev/null || echo "mbed-os-to-arduino scripts not found"

echo "=========================================="
echo "✅ Environment setup complete!"
echo "=========================================="
echo "ARM GCC Toolchain: $(arm-none-eabi-gcc --version | head -n1)"
echo "Python: $(python --version)"
echo "mbed-cli: $(mbed --version)"
echo ""
echo "You can now run:"
echo "  ./build_limbed.sh"
echo "=========================================="