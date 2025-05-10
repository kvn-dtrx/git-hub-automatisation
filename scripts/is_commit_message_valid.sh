#!/bin/bash

# ---
# description: Checks whether the commit message is well formatted.
# ---

PREFIXES=(
    "feat"
    "fix"
    "docs"
    "style"
    "refactor"
    "test"
    "chore"
    "perf"
    "ci"
    "build"
    "revert"
    "security"
    "ux"
    "localization"
    "wip"
    "meta"
)

REGEXP=""
REGEXP+="^("
for prefix in "${PREFIXES[@]}"; do
    REGEXP+="${prefix}|"
done
REGEXP="${REGEXP%|}): "

COMMIT_MSG="$(git log -1 --pretty=format:"%s")"

if ! echo "${COMMIT_MSG}" | grep -Eq "${VALID_PREFIXES}"; then
    echo "Commit message does not match:"
    echo "${REGEXP}"
    exit 1
fi
