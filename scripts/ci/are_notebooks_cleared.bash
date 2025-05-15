#!/bin/bash

# ---
# description: |
#   Checks whether output cells of all iPy notebooks are cleared.
#   Intended to be used as a GitHub workflow run on pull requests.
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
done < <(
    git diff --name-only --diff-filter=AM -z "${BASE_SHA}" "${HEAD_SHA}" |
        grep -z '\.ipynb$' || true
)

if [ "${failed}" -gt 0 ]; then
    echo "Notebooks with uncleared output cells found."
    echo "Please check if this is intended."
    exit 1
else
    echo "No notebook with uncleared output cells found."
fi
