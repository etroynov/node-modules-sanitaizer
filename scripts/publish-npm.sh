#!/bin/bash

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: ./scripts/publish-npm.sh <version>"
  exit 1
fi

echo "🚀 Publishing version $VERSION using GitHub Actions..."
echo ""
echo "This script will:"
echo "  1. Update version in all package.json files"
echo "  2. Commit and tag the release"
echo "  3. Push to GitHub (which triggers automated publishing)"
echo ""

# Update version in all package.json files
echo "📝 Updating versions..."
npm version $VERSION --no-git-tag-version --allow-same-version
cd npm/cli-darwin-arm64 && npm version $VERSION --no-git-tag-version --allow-same-version && cd ../..
cd npm/cli-darwin-x64 && npm version $VERSION --no-git-tag-version --allow-same-version && cd ../..
cd npm/cli-linux-x64 && npm version $VERSION --no-git-tag-version --allow-same-version && cd ../..
cd npm/cli-linux-arm64 && npm version $VERSION --no-git-tag-version --allow-same-version && cd ../..
cd npm/cli-win32-x64 && npm version $VERSION --no-git-tag-version --allow-same-version && cd ../..

# Commit changes
echo "📦 Committing version bump..."
git add package.json npm/*/package.json
git commit -m "chore: bump version to $VERSION"

# Create and push tag
echo "🏷️  Creating tag v$VERSION..."
git tag "v$VERSION"

echo ""
echo "✅ Ready to publish!"
echo ""
echo "Run the following command to trigger automated publishing:"
echo "  git push && git push --tags"
echo ""
echo "GitHub Actions will automatically build and publish for all platforms."
