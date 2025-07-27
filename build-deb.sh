#!/bin/bash
set -e

# Load version from file
VERSION=$(cat VERSION)
PKG_NAME="ubuntu-first-run"

# Define paths
ROOT_DIR="$(pwd)"
BUILD_DIR="$ROOT_DIR/build"
DEBIAN_DIR="$BUILD_DIR/DEBIAN"
INSTALL_DIR="$BUILD_DIR/usr/bin"
DOC_DIR="$BUILD_DIR/usr/share/doc/$PKG_NAME"

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$DEBIAN_DIR"
mkdir -p "$INSTALL_DIR"
mkdir -p "$DOC_DIR"
mkdir -p "$BUILD_DIR/usr/share/man/man1"
gzip -9 -c man/ubuntu-first-run.1 > "$BUILD_DIR/usr/share/man/man1/ubuntu-first-run.1.gz"

# Generate debian control file from template
sed "s/__VERSION__/${VERSION}/" debian/control.in > "$DEBIAN_DIR/control"

# Copy executable
cp src/ubuntu-first-run.sh "$INSTALL_DIR/$PKG_NAME"
chmod 755 "$INSTALL_DIR/$PKG_NAME"

# Add changelog
echo "$PKG_NAME ($VERSION) stable; urgency=low" > "$DOC_DIR/changelog"
echo "  * Initial release." >> "$DOC_DIR/changelog"
echo "" >> "$DOC_DIR/changelog"
echo " -- Jesse Hawkins <jesse@thehawkins.us>  $(date -R)" >> "$DOC_DIR/changelog"
gzip -9 "$DOC_DIR/changelog"

# Build the package
OUTPUT_VERSIONED="${PKG_NAME}_${VERSION}_all.deb"
OUTPUT_STATIC="${PKG_NAME}.deb"
dpkg-deb --build "$BUILD_DIR" "$OUTPUT_VERSIONED"

# Also create a static version for GitHub Releases
cp "$OUTPUT_VERSIONED" "$OUTPUT_STATIC"

echo "✅ Build complete:"
echo " - $OUTPUT_VERSIONED"
echo " - $OUTPUT_STATIC"
