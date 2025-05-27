#!/usr/bin/env bash

# ---
# description: |
#   Strips all files from the repository that
#   are not listed in the `.pubignore` file.
# ---

# NOTE: As git does not track renames, older directory and file
# names must also be listed in the `.pubignore` file in order
# fully remove them from the repository history.

set -e

PUBIGNORE_NAME=".pubignore"
REPO_PUB_SUFFIX="-pub"

repo_src_path="$(git rev-parse --show-toplevel)"
repo_tar_path="${repo_src_path}${REPO_PUB_SUFFIX}"
pubignore_path="${repo_src_path}/${PUBIGNORE_NAME}"

rm -rf "${repo_tar_path}"
git clone "${repo_src_path}" "${repo_tar_path}"
cd "${repo_tar_path}"

if ! git ls-tree -r --name-only HEAD | grep -q "${PUBIGNORE_NAME}"; then
    echo "No ${PUBIGNORE_NAME} file present!"
    exit 0
fi

git filter-repo \
    --force \
    --invert-paths \
    --paths-from-file "${pubignore_path}"

git filter-repo \
    --force \
    --invert-paths \
    --path "${pubignore_path}"
