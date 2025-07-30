#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="claudebox"
SOURCE_SCRIPT="./claudebox"

if [[ ! -f "$SOURCE_SCRIPT" ]]; then
    echo "Error: $SOURCE_SCRIPT not found in current directory" >&2
    exit 1
fi

if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "Creating directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

echo "Installing $SCRIPT_NAME to $INSTALL_DIR/"
cp "$SOURCE_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "✓ Successfully installed $SCRIPT_NAME to $INSTALL_DIR/"
echo "✓ Made $SCRIPT_NAME executable"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "⚠️  Warning: $HOME/.local/bin is not in your PATH"
    echo "   Add this to your shell configuration file (~/.zshrc, ~/.bashrc, etc.):"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "   Or run the script with the full path:"
    echo "   $INSTALL_DIR/$SCRIPT_NAME"
else
    echo ""
    echo "🎉 You can now run: $SCRIPT_NAME"
fi