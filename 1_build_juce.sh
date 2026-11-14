#!/usr/bin/env bash
# Configure, build and install the JUCE library (git submodule ./JUCE) into ./_d
#
# Every configuration in CONFIGS gets its own build directory; prebuilt module libraries are
# installed into _d/lib/<config>.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/JUCE"
PREFIX="$ROOT/_d"
CONFIGS="${CONFIGS:-Debug Release}"
PREBUILT_MODULES="${PREBUILT_MODULES:-juce_core}"

if [[ ! -f "$SRC/CMakeLists.txt" ]]; then
    git -C "$ROOT" submodule update --init --recursive
fi

GENERATOR_ARGS=()
if command -v ninja >/dev/null 2>&1; then
    GENERATOR_ARGS=(-G Ninja)
fi

for CONFIG in $CONFIGS; do
    BUILD="$ROOT/_build/juce/$CONFIG"

    # -U: JUCE_INSTALL_DESTINATION is cached and embeds the JUCE version; recompute it
    cmake -S "$SRC" -B "$BUILD" "${GENERATOR_ARGS[@]}" -UJUCE_INSTALL_DESTINATION \
        -DCMAKE_BUILD_TYPE="$CONFIG" \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DJUCE_BUILD_EXTRAS=OFF \
        -DJUCE_BUILD_EXAMPLES=OFF \
        -DJUCE_PREBUILT_MODULES="${PREBUILT_MODULES// /;}"

    cmake --build "$BUILD" --config "$CONFIG"
done

# Start from a clean prefix so files from a previous JUCE version do not linger
rm -rf "$PREFIX"

for CONFIG in $CONFIGS; do
    cmake --install "$ROOT/_build/juce/$CONFIG" --config "$CONFIG"
done

echo "JUCE installed to $PREFIX"
