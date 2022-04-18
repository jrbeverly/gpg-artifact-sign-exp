#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
ARTIFACTS_DIR="${ROOT_DIR}/artifacts"
DIST_DIR="${ROOT_DIR}/dist"
APT_GPG_KEY_ID="docker-signed-github-actions"

set -eu

if ! command -v gpg &>/dev/null; then
  echo "Required tool 'gpg' not found. Please install it via apt-get:"
  echo "apt-get install gnupg"
  exit 1
fi

if ! command -v github-release &>/dev/null; then
  echo "Required tool 'github-release' not found. Download it from here:"
  echo "https://github.com/c4milo/github-release/releases"
  echo "Just extract the archive and put the binary on your PATH."
  exit 1
fi

function import_gpg_secret() {
  if ! gpg --list-secret-keys | grep "${APT_GPG_KEY_ID}" > /dev/null; then
    keyfile=$(mktemp --tmpdir)
    chmod 0600 "${keyfile}"
    # Get keyfile from somewhere

    gpg --allow-secret-key-import --import "${keyfile}"
    rm -f "${keyfile}"
  fi
}

# Generate new content of Release file
function release_content() {
  cat <<EOF
Origin: jrbeverly
Label: docker-signed-github-actions
Date: $(date -u "+%a, %d %b %Y %H:%M:%S UTC")
Architectures: amd64
EOF
  echo MD5Sum:
   for file in "${ARTIFACTS_DIR}"/*; do
    echo "" "$(md5sum ${file} | cut -d " " -f1)" "$(ls -l ${file} | cut -d " " -f5)" "$(basename "$file")"
   done
  echo SHA1:
   for file in "${ARTIFACTS_DIR}"/*; do
    echo "" "$(sha1sum ${file} | cut -d " " -f1)" "$(ls -l ${file} | cut -d " " -f5)" "$(basename "$file")"
   done
  echo SHA256:
   for file in "${ARTIFACTS_DIR}"/*; do
    echo "" "$(sha256sum ${file} | cut -d " " -f1)" "$(ls -l ${file} | cut -d " " -f5)" "$(basename "$file")"
   done
}

function checksums() {
  cd "${ARTIFACTS_DIR}"
  # md5sum
  for file in *; do
    (cd "${ARTIFACTS_DIR}" && md5sum "$(basename "${file}")" > "${DIST_DIR}/${file}.md5sum")
    gpg --no-tty --output "${DIST_DIR}/${file}.ms5sum.sig" -u "${APT_GPG_KEY_ID}" --detach-sig "${file}"
  done
  
  # sha1sum
  for file in *; do
    (cd "${ARTIFACTS_DIR}" && sha1sum "$(basename "${file}")" > "${DIST_DIR}/${file}.sha1sum")
    gpg --no-tty --output "${DIST_DIR}/${file}.sha1sum.sig" -u "${APT_GPG_KEY_ID}" --detach-sig "${file}"
  done

  # sha512
  for file in *; do
    (cd "${ARTIFACTS_DIR}" && sha256sum "$(basename "${file}")" > "${DIST_DIR}/${file}.sha256sum")
    gpg --no-tty --output "${DIST_DIR}/${file}.sha256sum.sig" -u "${APT_GPG_KEY_ID}" --detach-sig "${file}"
  done
}

# Generate the artifacts
rm -rf "${ARTIFACTS_DIR}" "${DIST_DIR}"
mkdir -p "${ARTIFACTS_DIR}" "${DIST_DIR}"
echo "first_file" > "${ARTIFACTS_DIR}/file1.txt"
echo "second_file" > "${ARTIFACTS_DIR}/file2.txt"
echo "third_file" > "${ARTIFACTS_DIR}/file3.txt"

import_gpg_secret
release_content
checksums
