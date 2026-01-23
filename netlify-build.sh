#!/usr/bin/env bash
set -euo pipefail

# Install Flutter to $HOME/flutter if not already present
if [ ! -d "$HOME/flutter" ]; then
  git clone --depth 1 https://github.com/flutter/flutter.git -b stable "$HOME/flutter"
fi

# Ensure flutter is on PATH
export PATH="$HOME/flutter/bin:$HOME/flutter/bin/cache/dart-sdk/bin:$PATH"

# Enable web support, ensure artifacts are downloaded
flutter config --enable-web
flutter --version
flutter precache --web

# Get packages and build
flutter pub get
flutter build web --release
