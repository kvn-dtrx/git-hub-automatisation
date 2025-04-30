#!/bin/sh

for private_repo in "${@}"; do
    public_repo="${private_repo}-fyc"

    git clone --bare "${private_repo}" tmp.git
    cd tmp.git || exit 1

    if ! gh repo view "${public_repo}" 2 >/dev/null >&1; then
        gh repo create "$PUBLIC_REPO_NAME" --public
    fi

    git filter-repo --path secrets.json --invert-paths
    git filter-repo --path config/ --invert-paths

    git remote add mirror "${public_repo}"

    git push --mirror mirror

    cd ..
    rm -rf tmp.git
done
