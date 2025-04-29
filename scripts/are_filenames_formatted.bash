#!/bin/bash

# ---
# description: Checks whether names of staged files contain white spaces.
# ---

failed=0

while IFS='' read -r -d '' file; do
    if [[ "${file}" =~ " " ]]; then
        echo "File name with white spaces found: '${file}'."
        failed=1
    fi
    # It must be ensured that the while loop runs in the main shell,
    # otherwise changes to the failed variable would be restricted to subshells!.
done < <(git diff --cached --name-only -z)

if [ "${failed}" -gt 0 ]; then
    exit 1
else
    echo "No file names with white spaces."
fi
