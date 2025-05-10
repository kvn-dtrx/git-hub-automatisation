#!/bin/bash

# ---
# description: Checks whether names of commited files contain white spaces.
# ---

failed=0

while IFS='' read -r -d '' file; do
    # Check for whitespace in the filename
    if [[ "${file}" =~ [[:space:]] || "${file}" =~ [A-Z] ]]; then
        echo "⚠️ File name with white spaces or uppercase characters found:"
        echo "  '${file}'"
        failed=1
    fi
    # It must be ensured that the while loop runs in the main shell,
    # otherwise changes to the failed variable would be restricted to subshells!.
    # done < <(git diff --cached --name-only -z)
done < <(git diff --name-only origin/main HEAD)

if [ "${failed}" -gt 0 ]; then
    exit 1
fi
