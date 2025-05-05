#!/bin/sh

# ---
# description: Checks whether the commit contains ignored files.
# ---

ignored_files=$(
    git status --ignored --porcelain |
        awk '/^!!/ {print $2}' |
        xargs git diff --cached --name-only
)

if [ -n "${ignored_files}" ]; then
    echo "Warning: You are trying to commit ignored files:"
    echo "${ignored_files}"
    echo "If you really want to commit, run: git commit --no-verify"
    exit 1
fi
