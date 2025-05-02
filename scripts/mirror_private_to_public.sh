#!/bin/sh

FYCIGNORE=".fycignore"

PRIVATE_REPO="https://github.com/${GITHUB_REPOSITORY}"
# PRIVATE_REPO="https://github.com/kvn-dtrx/xperiments"

public_repo="${PRIVATE_REPO}-fyc"

TMPDIR=$(mktemp -d -t repo-to-mirror.XXX)
# TMPDIR=tmp.git

git clone \
    --branch main \
    --single-branch \
    "${PRIVATE_REPO}" \
    "${TMPDIR}"

(
    cd "${TMPDIR}" ||
        {
            echo "Failed to enter temporary directory"
            exit 1
        }

    if ! gh repo view "${public_repo}" >/dev/null 2>&1; then
        gh repo create "${public_repo}" --public
    fi

    if ! git ls-tree -r --name-only HEAD | grep -q "${FYCIGNORE}"; then
        echo "No ${FYCIGNORE} file present!"
        exit 0
    fi

    git filter-repo \
        --invert-paths \
        --paths-from-file "${FYCIGNORE}"

    git filter-repo \
        --invert-paths \
        --path "${FYCIGNORE}"

    git remote add fyc-mirror "${public_repo}"

    git push --mirror fyc-mirror

)

rm -rf "${TMPDIR}"
