#!/bin/bash
set -e

# Load version from file
VERSION=$(cat VERSION)
PKG_NAME="ubuntu-first-run"

# Set paths
ROOT_DIR="$(pwd)"
BUILD_DIR="$ROOT_DIR/build"
DEBIAN_DIR="$BUILD_DIR/DEBIAN"
INSTALL_DIR="$BUILD_DIR/usr/local/bin"
SOURCE_SCRIPT="src/ubuntu-first-run.sh"

# Clean and recreate build directories
rm -rf "$BUILD_DIR"
mkdir -p "$DEBIAN_DIR"
mkdir -p "$INSTALL_DIR"

# Generate debian control file from template
sed "s/__VERSION__/${VERSION}/" debian/control.in > "$DEBIAN_DIR/control"

# Copy executable
cp "$SOURCE_SCRIPT" "$INSTALL_DIR/ubuntu-first-run"
chmod 755 "$INSTALL_DIR/ubuntu-first-run"

# Build the .deb package
OUTPUT_VERSIONED="${PKG_NAME}_${VERSION}_all.deb"
OUTPUT_STATIC="${PKG_NAME}.deb"
dpkg-deb --build "$BUILD_DIR" "$OUTPUT_VERSIONED"

# Also create a static file for GitHub "latest" release link
cp "$OUTPUT_VERSIONED" "$OUTPUT_STATIC"

# Done
echo "✅ Build complete:"
echo " - $OUTPUT_VERSIONED"
echo " - $OUTPUT_STATIC"
