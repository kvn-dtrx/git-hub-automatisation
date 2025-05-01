#!/bin/sh

set -e

UPSTREAM_URL="$(
    git config --get remote.origin.url |
        sed -E 's|github.com/[^/]*/|github.com/ORIGINAL_OWNER/|'
)"

git remote add upstream "${UPSTREAM_URL}"
git fetch upstream

DEFAULT_BRANCH="$(
    git remote show upstream |
        awk '/HEAD branch/ {print $NF}'
)"

git checkout "${DEFAULT_BRANCH}"
git merge "upstream/${DEFAULT_BRANCH}" --allow-unrelated-histories

git push origin "${DEFAULT_BRANCH}"
