#!/usr/bin/env bash
# Configure and build the test project against the JUCE installed in ./_d, for each config in CONFIGS
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS="${CONFIGS:-Debug Release}"

GENERATOR_ARGS=()
if command -v ninja >/dev/null 2>&1; then
    GENERATOR_ARGS=(-G Ninja)
fi

for CONFIG in $CONFIGS; do
    BUILD="$ROOT/_build/test/$CONFIG"

    cmake -S "$ROOT" -B "$BUILD" "${GENERATOR_ARGS[@]}" \
        -DCMAKE_BUILD_TYPE="$CONFIG" \
        -DCMAKE_PREFIX_PATH="$ROOT/_d"

    cmake --build "$BUILD" --config "$CONFIG"
done
