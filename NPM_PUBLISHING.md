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

1. **Setup npm token in GitHub Secrets:**
   - Go to https://www.npmjs.com/settings/YOUR_USERNAME/tokens
   - Create a new "Automation" token
   - Add it to your GitHub repository secrets as `NPM_TOKEN`
   - Settings → Secrets and variables → Actions → New repository secret

2. **Update repository URLs in package.json:**
   - Replace `your-username` with your actual GitHub username
   - Update homepage, bugs, and repository URLs

## Publishing Steps

### 🚀 Automated Publishing (Recommended)

The easiest way to publish is using GitHub Actions:

```bash
# 1. Run the publish script
./scripts/publish-npm.sh 0.1.0

# 2. Push to GitHub to trigger automated publishing
git push && git push --tags
```

This will:
1. ✅ Update version in all package.json files
2. ✅ Create a git commit and tag
3. ✅ GitHub Actions builds binaries for all platforms (macOS, Linux, Windows)
4. ✅ Automatically publishes all packages to npm

### 🛠️ Local Build (macOS only)

If you want to build locally for testing:

```bash
./scripts/build-npm.sh
```

This only builds for your current macOS architecture (ARM64 or x64).

### 🧪 Test Locally

Before publishing, test the package:

```bash
# Build for your platform
./scripts/build-npm.sh

# Test the binary
./npm/cli-darwin-arm64/nmz --help  # or cli-darwin-x64
```

### ⚙️ Manual Publishing (Advanced)

If you need to publish manually without GitHub Actions:

```bash
# 1. Build for your platform only
cargo build --release
cp target/release/nmz npm/cli-darwin-arm64/nmz  # or cli-darwin-x64

# 2. Publish your platform package
cd npm/cli-darwin-arm64 && npm publish --access public && cd ../..

# Note: You'll need to build on other platforms (Linux/Windows) 
# or use GitHub Actions for complete cross-platform support
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

## 🤖 GitHub Actions Workflow

The workflow is already configured in `.github/workflows/publish.yml`. It automatically:

1. **Triggers** when you push a git tag starting with `v` (e.g., `v0.1.0`)
2. **Builds** binaries on native platforms:
   - macOS (ARM64 and x64)
   - Linux (x64 and ARM64)
   - Windows (x64)
3. **Publishes** all platform packages and the main package to npm

The workflow handles cross-compilation automatically, so you don't need to worry about build tools on macOS!

## Version Management

Always keep versions in sync:
- Main package version should match platform package versions
- Use the publish script to ensure consistency

## 🔧 Troubleshooting

### ❌ "Cross-compilation failed" on macOS

**Solution:** Use GitHub Actions! The local build script only builds for macOS. Push your tag to GitHub and let the workflow handle all platforms.

### ❌ "NPM_TOKEN not found" in GitHub Actions

**Solution:** 
1. Create an npm automation token at https://www.npmjs.com/settings/YOUR_USERNAME/tokens
2. Add it as a secret in your GitHub repo: Settings → Secrets and variables → Actions → New repository secret
3. Name it exactly `NPM_TOKEN`

### ❌ Package already exists

**Solution:** You can't republish the same version. Bump the version number:
```bash
./scripts/publish-npm.sh 0.1.1
```

### ⚠️ Testing before publishing

Test locally on your macOS:
```bash
./scripts/build-npm.sh
./npm/cli-darwin-arm64/nmz --analyze --path ./node_modules
```

For other platforms, wait for GitHub Actions to build, or test in a Docker container.
