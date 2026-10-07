#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
(cd packages/nusantara_ui && flutter pub get)
(cd apps/catalog && flutter pub get)
