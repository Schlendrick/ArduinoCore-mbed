#!/bin/bash

# Build script for limbed.a in devcontainer
# This script should be run inside the devcontainer

set -e

echo "======================================================="
echo "ArduinoCore-mbed Build Environment Setup"
echo "======================================================="

# Activate the virtual environment
echo "Activating Python virtual environment..."
source .venv/bin/activate

# Check if mbed-cli is available
echo "Checking mbed-cli installation..."
if ! command -v mbed &> /dev/null; then
    echo "Error: mbed-cli is not available in PATH"
    echo "Try running: pip install mbed-cli"
    exit 1
fi

echo "mbed-cli version: $(mbed --version)"

# Check if ARM toolchain is available
echo "Checking ARM GCC toolchain..."
if ! command -v arm-none-eabi-gcc &> /dev/null; then
    echo "Error: ARM GCC toolchain not found"
    exit 1
fi

echo "ARM GCC version: $(arm-none-eabi-gcc --version | head -n1)"

# Check if mbed-os repo path is provided
if [ $# -eq 0 ]; then
    MBED_OS_PATH="/tmp/mbed-os"
    echo "Using default mbed-os path: $MBED_OS_PATH"
else
    MBED_OS_PATH="$1"
    echo "Using provided mbed-os path: $MBED_OS_PATH"
fi

# Check if the mbed-os directory exists
if [ ! -d "$MBED_OS_PATH" ]; then
    echo "Error: mbed-os directory not found at $MBED_OS_PATH"
    echo "Please ensure the mbed-os repository is cloned and available."
    exit 1
fi

# Check if we're on the correct branch
echo "Checking mbed-os branch..."
cd "$MBED_OS_PATH"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "extrapatches-6.17.0" ]; then
    echo "Warning: Currently on branch '$CURRENT_BRANCH', expected 'extrapatches-6.17.0'"
    echo "Checking out extrapatches-6.17.0..."
    git checkout extrapatches-6.17.0
fi

echo "mbed-os is on branch: $CURRENT_BRANCH"

# Go back to the ArduinoCore-mbed directory
cd /workspaces/ArduinoCore-mbed

# Make the scripts executable (in case they weren't)
chmod +x ./mbed-os-to-arduino*

echo ""
echo "======================================================="
echo "✅ Environment is ready!"
echo "======================================================="
echo ""
echo "To build for Portenta H7 M7, run:"
echo "  ./mbed-os-to-arduino -r $MBED_OS_PATH PORTENTA_H7_M7:PORTENTA_H7_M7"
echo ""
echo "Other common targets:"
echo "  ARDUINO_NANO33BLE:ARDUINO_NANO33BLE"
echo "  GIGA:GIGA"
echo "  ARDUINO_NICLA:ARDUINO_NICLA"
echo ""
echo "Notes:"
echo "- The -a flag applies patches (many may fail on this mbed-os version)"
echo "- Build works without patches as demonstrated in this session"
echo "- Generated files are placed in variants/<TARGET>/ directory"
echo "======================================================="