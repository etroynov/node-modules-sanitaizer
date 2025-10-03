#!/bin/bash

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: ./scripts/publish-npm.sh <version>"
  exit 1
fi

echo "Publishing version $VERSION..."

# Update version in all package.json files
npm version $VERSION --no-git-tag-version
cd npm/cli-darwin-arm64 && npm version $VERSION --no-git-tag-version && cd ../..
cd npm/cli-darwin-x64 && npm version $VERSION --no-git-tag-version && cd ../..
cd npm/cli-linux-x64 && npm version $VERSION --no-git-tag-version && cd ../..
cd npm/cli-linux-arm64 && npm version $VERSION --no-git-tag-version && cd ../..
cd npm/cli-win32-x64 && npm version $VERSION --no-git-tag-version && cd ../..

# Build binaries
./scripts/build-npm.sh

# Publish platform-specific packages
echo "Publishing platform packages..."
cd npm/cli-darwin-arm64 && npm publish --access public && cd ../..
cd npm/cli-darwin-x64 && npm publish --access public && cd ../..
cd npm/cli-linux-x64 && npm publish --access public && cd ../..
cd npm/cli-linux-arm64 && npm publish --access public && cd ../..
cd npm/cli-win32-x64 && npm publish --access public && cd ../..

# Publish main package
echo "Publishing main package..."
npm publish --access public

echo "Published version $VERSION successfully!"
