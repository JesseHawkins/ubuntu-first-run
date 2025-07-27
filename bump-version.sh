#!/bin/bash
set -e

USAGE="Usage: $0 [--patch | --minor | --major]"

if [ $# -ne 1 ]; then
  echo "$USAGE"
  exit 1
fi

VERSION=$(cat VERSION)
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

case $1 in
  --patch)
    PATCH=$((PATCH + 1))
    ;;
  --minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  --major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  *)
    echo "$USAGE"
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "$NEW_VERSION" > VERSION
echo "✅ Version updated to $NEW_VERSION"
