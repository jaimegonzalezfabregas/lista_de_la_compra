#!/usr/bin/env bash
# Copies images from en-US/images to all locale folders under fastlane/metadata/android
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ANDROID_META="$ROOT_DIR/android"
EN_IMAGES="$ANDROID_META/en-US/images"

if [ ! -d "$EN_IMAGES" ]; then
  echo "Source images directory not found: $EN_IMAGES" >&2
  exit 1
fi

echo "Copying images from $EN_IMAGES to locale folders..."

for locale_dir in "$ANDROID_META"/*/; do
  # skip en-US itself
  if [ "${locale_dir%/}" = "$ANDROID_META/en-US" ]; then
    continue
  fi
  echo "Processing $locale_dir"
  mkdir -p "$locale_dir/images"
  # copy files (preserve subdirs)
  rsync -a "$EN_IMAGES/" "$locale_dir/images/"
done

echo "Done."
