#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"

set -eu

# Generate the key

gpg --batch --gen-key "${ROOT_DIR}/spec/gpg.conf"