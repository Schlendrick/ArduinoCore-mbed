# ArduinoCore-mbed DevContainer Setup

This devcontainer provides a complete development environment for building `libmbed.a` for ArduinoCore-mbed projects using the **official ARM GCC 10.3 toolchain**.

## What's Pre-installed and Auto-configured

The devcontainer includes all the necessary tools and dependencies:

- **Official ARM GCC 10.3 Toolchain**: `gcc-arm-none-eabi-10.3-2021.10` with complete C++ standard library
- **Python 3.11**: Automatically configured in a virtual environment (`.venv`) with all required packages
- **mbed-cli**: The Mbed command-line interface (auto-installed via `postCreateCommand`)
- **All mbed-os dependencies**: Automatically installed including essential and optional packages
- **Build tools**: `jq`, `rsync`, `cmake`, `ninja-build`
- **Arduino mbed-os repository**: Pre-cloned at `/tmp/mbed-os` on the `extrapatches-6.17.0` branch

## Quick Start

1. **Open in DevContainer**: When you open this project in VS Code, it will prompt you to reopen in container. Click "Reopen in Container".

2. **Container Setup**: The container will build and automatically:
   - Download and install official ARM GCC 10.3 toolchain (ARM64/x86_64 auto-detected)
   - Configure Python virtual environment
   - Install mbed-cli and all dependencies
   - Set up PATH for ARM toolchain

3. **Ready to Build**: Once the container is ready, you can immediately run:
   ```bash
   ./build_limbed.sh
   ```

4. **Execute Build**: The script will use the Linux-specific build process:
   ```bash
   ./mbed-os-to-arduino -r /tmp/mbed-os PORTENTA_H7_M7:PORTENTA_H7_M7
   ```

## ✅ Verified Working Setup

This devcontainer has been tested and verified to work on:
- **ARM64 (Apple Silicon)**: Automatically uses aarch64 ARM toolchain
- **x86_64 (Intel/AMD)**: Automatically uses x86_64 ARM toolchain

**Last tested**: Successfully compiled complete PORTENTA_H7_M7 target without errors

## ARM Toolchain Details

This setup uses the **official ARM GCC 10.3 toolchain** which provides:
- Complete C++ standard library (including `<chrono>`, `<memory>`, etc.)
- Same version used by Arduino IDE and official mbed builds
- Optimized for ARM Cortex-M development

**Installation Location**: `/opt/gcc-arm-none-eabi-10.3-2021.10/`
**Automatically added to PATH**: Available as `arm-none-eabi-gcc`

## Manual Commands (if needed)

```bash
# Check ARM toolchain version
arm-none-eabi-gcc --version
# Should show: gcc version 10.3.1 (GNU Arm Embedded Toolchain 10.3-2021.10)

# Activate Python environment (if not already active)
source .venv/bin/activate

# Verify mbed-cli installation
mbed --version

# Run setup script manually (if needed)
.devcontainer/setup-environment.sh
```

## Troubleshooting

### ARM Toolchain Issues
If you get "No such file or directory" for C++ headers like `<chrono>`:
- **Solution**: The container needs to be rebuilt to install the official ARM toolchain
- **Check**: Run `arm-none-eabi-gcc --version` - should show version 10.3.1

### Python/mbed-cli Issues
If `mbed` command is not found:
```bash
# Activate virtual environment
source .venv/bin/activate

# If still not working, recreate environment
rm -rf .venv
.devcontainer/setup-environment.sh
```

### Container Rebuild Required
If you encounter persistent issues:
1. **Rebuild Container**: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"
2. **Wait for ARM toolchain download** (~2-3 minutes)
3. **Verify setup**: Check `arm-none-eabi-gcc --version`