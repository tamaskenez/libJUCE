#!/usr/bin/env bash
# Configure and build the test project against the JUCE installed in ./_d
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$ROOT/_build/test"
CONFIG="${CONFIG:-Release}"

GENERATOR_ARGS=()
if command -v ninja >/dev/null 2>&1; then
    GENERATOR_ARGS=(-G Ninja)
fi

cmake -S "$ROOT" -B "$BUILD" "${GENERATOR_ARGS[@]}" \
    -DCMAKE_BUILD_TYPE="$CONFIG" \
    -DCMAKE_PREFIX_PATH="$ROOT/_d"

cmake --build "$BUILD" --config "$CONFIG"
