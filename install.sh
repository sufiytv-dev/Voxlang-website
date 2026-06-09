#!/usr/bin/env bash

# Enforce strict execution: abort on error, uninitialized variables, or pipe failures.
set -euo pipefail

# Define formatting colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

echo -e "\n${CYAN} VOXLANG ${NC}"
echo "Initializing native toolchain deployment..."

# 1. Detect Environment (OS & Architecture)
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

if [ "$OS" = "darwin" ]; then
    TARGET="macos-amd64"
elif [ "$OS" = "linux" ]; then
    if [ "$ARCH" = "x86_64" ]; then
        TARGET="linux-amd64"
    else
        echo -e "${RED}[!] Unsupported Linux architecture: $ARCH${NC}"
        exit 1
    fi
else
    echo -e "${RED}[!] Unsupported operating system: $OS${NC}"
    exit 1
fi

echo -e "${GRAY} [+] Detected target environment: $TARGET${NC}"

# Map target to binary name
BINARY_NAME="vxm-${TARGET}"
if [ "$OS" = "darwin" ]; then
    # For macOS, we use the amd64 binary for both Intel and Rosetta 2
    BINARY_NAME="vxm-macos-amd64"
fi

VOX_URL="https://github.com/sufiytv-dev/Voxlang/releases/download/v0.1-bootstrap/${BINARY_NAME}"
INSTALL_DIR="$HOME/.vox/bin"
VOX_PATH="$INSTALL_DIR/vox"

# 2. Prepare Sovereign Directory
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${GRAY} [+] Creating directory matrix at $INSTALL_DIR${NC}"
    mkdir -p "$INSTALL_DIR"
fi

# 3. Download the binary
echo -e "${CYAN} [+] Downloading toolchain...${NC}"
if ! curl -fsSL "$VOX_URL" -o "$VOX_PATH"; then
    echo -e "${RED} [!] Download failed. Ensure network connectivity and URI validity.${NC}"
    exit 1
fi

# Make binary executable
chmod +x "$VOX_PATH"

# 4. Path Mapping
PROFILE="/dev/null"
if [ -n "${BASH_VERSION:-}" ]; then
    PROFILE="$HOME/.bashrc"
elif [ -n "${ZSH_VERSION:-}" ]; then
    PROFILE="$HOME/.zshrc"
else
    PROFILE="$HOME/.profile"
fi

if ! grep -q "$INSTALL_DIR" "$PROFILE" 2>/dev/null; then
    echo "" >> "$PROFILE"
    echo "# Voxlang Toolchain" >> "$PROFILE"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$PROFILE"
    echo -e "${GRAY} [v] Added to $PROFILE${NC}"
else
    echo -e "${GRAY} [v] Path already mapped in $PROFILE${NC}"
fi

echo -e "\n${GREEN} >>> Deployment complete. The compiler is sound.${NC}"
echo -e "${GRAY} >>> Run 'source $PROFILE' or open a new terminal, then type 'vox --version' to begin.${NC}\n"
