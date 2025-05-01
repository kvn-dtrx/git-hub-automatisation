#!/bin/sh

FYCIGNORE=".fycignore"

PRIVATE_REPO="${GITHUB_REPOSITORY}"

public_repo="${PRIVATE_REPO}-fyc"

git clone --bare "${PRIVATE_REPO}" tmp.git
cd tmp.git || exit 1

if ! gh repo view "${public_repo}" 2 >/dev/null >&1; then
    gh repo create "${public_repo}" --public
fi

if ! git ls-files | grep -q "${FYCIGNORE}"; then
    echo "No ${FYCIGNORE} file present!"
    exit 1
fi

git filter-repo \
    --invert-paths \
    --paths-from-file .fycignore

git filter-repo \
    --invert-paths \
    --path "${FYCIGNORE}"

git remote add fyc-mirror "${public_repo}"

git push --mirror fyc-mirror

cd ..
rm -rf tmp.git
