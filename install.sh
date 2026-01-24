#!/bin/bash

# kats installer for macOS and Linux
# This will download and install kats so you can use it from anywhere

set -e

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required to install kats"
    exit 1
fi

# Check if we're running on macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    INSTALL_DIR="/usr/local/bin"
    SUDO=""
    if [[ ! -w "$INSTALL_DIR" ]]; then
        SUDO="sudo"
    fi
elif [[ "$OSTYPE" == "linux"* ]]; then
    INSTALL_DIR="/usr/local/bin"
    SUDO="sudo"
else
    echo "Error: This installer only works on macOS and Linux"
    echo "Your system: $OSTYPE"
    exit 1
fi

# Check if kats is already installed
if command -v kats &> /dev/null; then
    echo "kats is already installed at: $(command -v kats)"
    echo "Use 'kats --version' to check the current version"
    exit 0
fi

# Download and install kats
echo "Installing kats globally..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Download the kats script
KATS_URL="https://raw.githubusercontent.com/laticee/kats/main/kats"

if ! curl -s -L "$KATS_URL" -o "$TEMP_DIR/kats"; then
    echo "Error: Failed to download kats from $KATS_URL"
    echo "Please check your internet connection and try again"
    echo "You can also install manually from:"
    echo "https://github.com/laticee/kats"
    exit 1
fi

# Make it executable
chmod +x "$TEMP_DIR/kats"

# Install to system
$SUDO mkdir -p "$INSTALL_DIR"
$SUDO mv "$TEMP_DIR/kats" "$INSTALL_DIR/kats"

# Verify installation
if command -v kats &> /dev/null; then
    echo "kats installed successfully!"
    echo ""
    echo "You can now run kats from anywhere:"
    echo "  kats [directory]"
    echo "  kats --help"
    echo ""
    
    # Show version
    kats --version
else
    echo "Error: Installation failed - kats is not in your PATH"
    echo "Try installing manually or check your PATH configuration"
    exit 1
fi
