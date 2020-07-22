#!/usr/bin/env sh

set -e

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: $(basename "$0") [install_dir]"
  echo "install_dir defaults to /usr/local if omitted"
  exit 0
fi

readonly PROJECT_ROOT="$(dirname "$0")"
readonly INSTALL_DIR="${1-"/usr/local"}"

install -d -m 755 "${INSTALL_DIR}/bin" "${INSTALL_DIR}/lib/archive"
install -m 755 "${PROJECT_ROOT}/bin"/* "${INSTALL_DIR}/bin"
install -m 755 "${PROJECT_ROOT}/lib/archive"/* "${INSTALL_DIR}/lib/archive"

echo "Installed archive"
