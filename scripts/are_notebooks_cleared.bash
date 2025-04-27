#!/bin/bash

# ---
# description: Checks whether iPy notebooks contain uncleared output cells.
# ---

failed=0

while IFS='' read -r -d '' notebook; do
    if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "$notebook")" ]; then
        echo "The notebook ${notebook} contains uncleared output cells and should not be committed!"
        failed=1
    fi
    # It must be ensured that the while loop runs in the main shell,
    # otherwise changes to the failed variable would be restricted to subshells!.
done < <(find . -name "*.ipynb" -print0)

if [ "${failed}" -gt 0 ]; then
    exit 1
else
    echo "No uncleared output cells found."
fi
