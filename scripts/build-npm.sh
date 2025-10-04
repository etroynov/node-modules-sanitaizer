#!/bin/bash

set -e

# Build for macOS only (use GitHub Actions for cross-platform builds)
echo "Building for macOS platforms..."

# Detect current architecture
ARCH=$(uname -m)

if [ "$ARCH" = "arm64" ]; then
  echo "Building for macOS ARM64..."
  cargo build --release
  mkdir -p npm/cli-darwin-arm64
  cp target/release/nmz npm/cli-darwin-arm64/nmz
  echo "✅ macOS ARM64 build complete"
else
  echo "Building for macOS x64..."
  cargo build --release
  mkdir -p npm/cli-darwin-x64
  cp target/release/nmz npm/cli-darwin-x64/nmz
  echo "✅ macOS x64 build complete"
fi

echo ""
echo "⚠️  Note: For Linux and Windows builds, use GitHub Actions"
echo "    See .github/workflows/publish.yml"
