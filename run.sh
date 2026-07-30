
#!/bin/bash
set -e

APP_NAME="MinimalMacApp.app"
ARCH=$(uname -m)
SDK_PATH=$(xcrun --show-sdk-path --sdk macosx)

rm -rf "$APP_NAME"
mkdir -p "$APP_NAME/Contents/MacOS"

cat > Info.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>main</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.minimalmacapp</string>
    <key>CFBundleName</key>
    <string>MinimalMacApp</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
</dict>
</plist>
EOF

echo "Compiling App.swift ($ARCH)..."

xcrun swiftc \
    -target "${ARCH}-apple-macos15.0" \
    -sdk "$SDK_PATH" \
    -parse-as-library \
    -framework SwiftUI \
    -framework RealityKit \
    -framework AppKit \
    -o "$APP_NAME/Contents/MacOS/main" \
    App.swift

cp Info.plist "$APP_NAME/Contents/"
echo -n "applt" > "$APP_NAME/Contents/PkgInfo"

echo "Launching..."
open "$APP_NAME"
