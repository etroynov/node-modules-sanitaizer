# NPM Publishing Guide

This document explains how to publish `node-modules-sanitizer` to npm, following the same pattern as Biome.

## Package Structure

The project uses a multi-package structure similar to Biome:

```
node_modules_sanitaizer/
├── package.json                 # Main package
├── npm/
│   ├── cli-darwin-arm64/       # macOS ARM64
│   ├── cli-darwin-x64/         # macOS x64
│   ├── cli-linux-x64/          # Linux x64
│   ├── cli-linux-arm64/        # Linux ARM64
│   └── cli-win32-x64/          # Windows x64
└── scripts/
    ├── build-npm.sh            # Build all platforms
    └── publish-npm.sh          # Publish all packages
```

## How it Works

1. **Main Package** (`node-modules-sanitizer`) - Contains optionalDependencies for all platform-specific packages
2. **Platform Packages** (`@node-modules-sanitizer/cli-*`) - Each contains a binary for a specific platform
3. **npm** automatically installs the correct platform package based on the user's OS

## Prerequisites

Before publishing, you need to:

1. Install Rust cross-compilation targets:
```bash
rustup target add aarch64-apple-darwin
rustup target add x86_64-apple-darwin
rustup target add x86_64-unknown-linux-gnu
rustup target add aarch64-unknown-linux-gnu
rustup target add x86_64-pc-windows-gnu
```

2. Install cross-compilation tools (if needed):
```bash
# For Linux targets on macOS
brew install FiloSottile/musl-cross/musl-cross

# For Windows targets
brew install mingw-w64
```

3. Login to npm:
```bash
npm login
```

## Publishing Steps

### 1. Build All Binaries

```bash
./scripts/build-npm.sh
```

This builds binaries for all supported platforms.

### 2. Test Locally

Before publishing, test the package locally:

```bash
# In each platform package directory
cd npm/cli-darwin-arm64
npm pack
npm install -g node-modules-sanitizer-cli-darwin-arm64-0.1.0.tgz
nmz --help
```

### 3. Publish to npm

```bash
./scripts/publish-npm.sh 0.1.0
```

This will:
1. Update version in all package.json files
2. Build binaries for all platforms
3. Publish all platform-specific packages
4. Publish the main package

### Manual Publishing

If you prefer to publish manually:

```bash
# 1. Update versions
npm version 0.1.0 --no-git-tag-version

# 2. Build binaries
./scripts/build-npm.sh

# 3. Publish platform packages
cd npm/cli-darwin-arm64 && npm publish --access public && cd ../..
cd npm/cli-darwin-x64 && npm publish --access public && cd ../..
cd npm/cli-linux-x64 && npm publish --access public && cd ../..
cd npm/cli-linux-arm64 && npm publish --access public && cd ../..
cd npm/cli-win32-x64 && npm publish --access public && cd ../..

# 4. Publish main package
npm publish --access public
```

## Installation (Users)

Users can install the package with:

```bash
npm install -g node-modules-sanitizer
```

Or use with npx:

```bash
npx node-modules-sanitizer --analyze
```

## CI/CD with GitHub Actions

Create `.github/workflows/publish.yml`:

```yaml
name: Publish to npm

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        include:
          - os: macos-latest
            target: aarch64-apple-darwin
            package: cli-darwin-arm64
          - os: macos-latest
            target: x86_64-apple-darwin
            package: cli-darwin-x64
          - os: ubuntu-latest
            target: x86_64-unknown-linux-gnu
            package: cli-linux-x64
          - os: ubuntu-latest
            target: aarch64-unknown-linux-gnu
            package: cli-linux-arm64
          - os: windows-latest
            target: x86_64-pc-windows-gnu
            package: cli-win32-x64

    steps:
      - uses: actions/checkout@v3
      - uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          target: ${{ matrix.target }}
      
      - name: Build
        run: cargo build --release --target ${{ matrix.target }}
      
      - name: Copy binary
        run: |
          mkdir -p npm/${{ matrix.package }}
          cp target/${{ matrix.target }}/release/nmz* npm/${{ matrix.package }}/
      
      - name: Publish
        run: |
          cd npm/${{ matrix.package }}
          npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}

  publish-main:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
          registry-url: 'https://registry.npmjs.org'
      
      - name: Publish main package
        run: npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

## Version Management

Always keep versions in sync:
- Main package version should match platform package versions
- Use the publish script to ensure consistency

## Troubleshooting

### Cross-compilation issues

If you encounter issues building for different platforms, consider using Docker or GitHub Actions to build on native platforms.

### Binary not found

Make sure the binary path in package.json `bin` field matches the actual binary location.

### Permission denied

After publishing, users might need to run:
```bash
chmod +x $(which nmz)
```

This is automatically handled when using npm's `bin` field correctly.
