#!/bin/bash
# Quick one-liner installer for Devbaytech
# Usage: curl -fsSL https://raw.githubusercontent.com/your-repo/main/install.sh | bash

set -e

echo "Installing Devbaytech..."
echo ""

# Clone or detect project
if [ ! -f "package.json" ]; then
    echo "Error: Please run this script from the Devbaytech project directory"
    exit 1
fi

# Make deploy script executable
chmod +x deploy.sh 2>/dev/null || true

# Run deployment
./deploy.sh

echo ""
echo "Installation complete!"
