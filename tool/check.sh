#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
flutter --version
dart format --output=none --set-exit-if-changed packages/nusantara_ui/lib packages/nusantara_ui/test apps/catalog/lib apps/catalog/test
(cd packages/nusantara_ui && flutter pub get && flutter analyze --fatal-infos && flutter test)
(cd apps/catalog && flutter pub get && flutter analyze --fatal-infos && flutter test)
