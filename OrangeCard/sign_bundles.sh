#!/bin/sh

FRAMEWORKS_DIR="${BUILT_PRODUCTS_DIR}"/"${FRAMEWORKS_FOLDER_PATH}"
PLUGINS_DIR="${BUILT_PRODUCTS_DIR}"/"${PLUGINS_FOLDER_PATH}"

echo "Signing Frameworks"
codesign --verbose=5 --force --sign "$CODE_SIGN_IDENTITY" "$FRAMEWORKS_DIR/CardView.framework/Versions/A"

# always sign inner bundles first
echo "Signing Autoupdate.app then Sparkle.framework"
codesign --verbose=5 --force --sign "$CODE_SIGN_IDENTITY" "$FRAMEWORKS_DIR/Sparkle.framework/Versions/A/Resources/Autoupdate.app"
codesign --verbose=5 --force --sign "$CODE_SIGN_IDENTITY" "$FRAMEWORKS_DIR/Sparkle.framework/Versions/A"
