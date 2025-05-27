#!/bin/bash

# ---
# description: |
#   Checks whether the commit message is well formatted.
#   Intended to be used as a pre-commit hook.
# ---

TYPES=(
    "feat"
    "fix"
    "chore"
    "docs"
    "refactor"
    "style"
    "test"
    "wip"
    # "perf"
    # "ci"
    # "build"
    # "revert"
    # "security"
    # "ux"
    # "localization"
    # "meta"
)

TYPE_PATTERN="($(
    IFS='|'
    echo "${TYPES[*]}"
))"

# Full Conventional Commit regex
REGEX="^${TYPE_PATTERN}(\([a-zA-Z0-9_-]+\))?(!)?: .+"

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n1 "$COMMIT_MSG_FILE")

if ! echo "${COMMIT_MSG}" | grep -Eq "${REGEX}"; then
    echo "Invalid commit message format!"
    echo "Commit message must follow Conventional Commits format:"
    echo "  <type>(optional-scope)!: description"
    echo "Allowed types are: ${TYPES[*]}"
    exit 1
fi
