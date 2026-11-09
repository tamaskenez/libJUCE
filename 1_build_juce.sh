#!/usr/bin/env bash
# Configure, build and install the JUCE library (git submodule ./JUCE) into ./_d
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/JUCE"
BUILD="$ROOT/_build/juce"
PREFIX="$ROOT/_d"
CONFIG="${CONFIG:-Release}"

if [[ ! -f "$SRC/CMakeLists.txt" ]]; then
    git -C "$ROOT" submodule update --init --recursive
fi

GENERATOR_ARGS=()
if command -v ninja >/dev/null 2>&1; then
    GENERATOR_ARGS=(-G Ninja)
fi

cmake -S "$SRC" -B "$BUILD" "${GENERATOR_ARGS[@]}" \
    -DCMAKE_BUILD_TYPE="$CONFIG" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DJUCE_BUILD_EXTRAS=OFF \
    -DJUCE_BUILD_EXAMPLES=OFF

cmake --build "$BUILD" --config "$CONFIG"
cmake --install "$BUILD" --config "$CONFIG"

echo "JUCE installed to $PREFIX"
