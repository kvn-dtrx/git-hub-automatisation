#!/bin/bash

# ---
# description: |
#   Checks whether output cells of all iPy notebooks are cleared.
#   Intended to be used as a git pre-commit hook.
# ---

failed=0

notebooks="$(
    git diff --cached --name-only -z |
        grep -z '\.ipynb$' ||
        true
)"

while IFS='' read -r -d '' notebook; do
    if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "$notebook")" ]; then
        echo "Notebook with uncleared output cells found:"
        echo "  ${notebook}"
        failed=1
    fi
    # It must be ensured that the while loop runs in the main shell,
    # otherwise changes to the failed variable would be restricted to subshells!.
done <<<"${notebooks}"

if [ "${failed}" -gt 0 ]; then
    echo "notebooks with uncleared output cells found."
    echo "If you really want to commit, run:"
    echo "  git commit --no-verify"
    exit 1
else
    echo "No notebook with uncleared output cells found."
fi
