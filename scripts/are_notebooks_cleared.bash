#!/bin/bash

# ---
# description: |
#   Checks whether iPy notebooks contain uncleared output cells.
#   Intended to be used as a pre-commit hook.
# ---

failed=0

while IFS='' read -r -d '' notebook; do
    if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "$notebook")" ]; then
        echo "Notebook with uncleared output cells found:"
        echo "  ${notebook}"
        failed=1
    fi
    # It must be ensured that the while loop runs in the main shell,
    # otherwise changes to the failed variable would be restricted to subshells!.
done < <(find . -name "*.ipynb" -print0)

if [ "${failed}" -gt 0 ]; then
    echo "Commit aborted due to uncleared output cells."
    echo "If you really want to commit, run:"
    echo "  git commit --no-verify"
    exit 1
else
    echo "No uncleared output cells found."
fi
