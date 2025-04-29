#!/bin/bash

branch_pattern=""
branch_pattern+="^"
branch_pattern+="("
branch_pattern+="feature\/|"
branch_pattern+="bugfix\/|"
branch_pattern+="hotfix\/|"
branch_pattern+="release\/|"
branch_pattern+="dev\/|"
branch_pattern+="test\/|"
branch_pattern+="experimental\/|"
branch_pattern+="docs\/|"
branch_pattern+="\/\/\/"
branch_pattern+=")"
branch_pattern+="[a-z0-9_-]+$"
branch_pattern+="$"

if [ -n "${GITHUB_REF}" ]; then
    branch_name="$(echo "${GITHUB_REF}")"
else
    branch_name="$(git rev-parse --abbrev-ref HEAD)"
fi

if [[ ! "${branch_name}" =~ ${branch_pattern} ]]; then
    echo "Warning: Branch name '${branch_name}' is not well formatted."
    echo "Branch names should match the regexp:"
    echo "${branch_pattern}"
    echo "Please stick to this convention next time."
    exit 1
fi
