#!/bin/bash

set -e

# Build for all platforms
echo "Building for all platforms..."

# macOS ARM64
echo "Building for macOS ARM64..."
cargo build --release --target aarch64-apple-darwin
cp target/aarch64-apple-darwin/release/nmz npm/cli-darwin-arm64/nmz

# macOS x64
echo "Building for macOS x64..."
cargo build --release --target x86_64-apple-darwin
cp target/x86_64-apple-darwin/release/nmz npm/cli-darwin-x64/nmz

# Linux x64
echo "Building for Linux x64..."
cargo build --release --target x86_64-unknown-linux-gnu
cp target/x86_64-unknown-linux-gnu/release/nmz npm/cli-linux-x64/nmz

# Linux ARM64
echo "Building for Linux ARM64..."
cargo build --release --target aarch64-unknown-linux-gnu
cp target/aarch64-unknown-linux-gnu/release/nmz npm/cli-linux-arm64/nmz

# Windows x64
echo "Building for Windows x64..."
cargo build --release --target x86_64-pc-windows-gnu
cp target/x86_64-pc-windows-gnu/release/nmz.exe npm/cli-win32-x64/nmz.exe

echo "Build complete!"
