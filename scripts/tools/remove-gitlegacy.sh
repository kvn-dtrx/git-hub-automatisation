#!/bin/sh

# ---
# description: |
#   Makes a clean-up in the specified git repositories
#   according to the current gitignore files.
# ---

# In this context, very informative:
# [[https://blog.tinned-software.net/remove-files-from-git-history]]

# ---

# [ "$#" -eq 0 ] &&
#     1="~/Downloads/plain-text"

for arg in "${@}"; do
    (
        # As often with git, operating from the repository makes life easier
        cd "${arg}" ||
            exit 1

        # Checks if there is indeed a git repository.
        [ ! -d ".git" ] &&
            echo "${arg} seems to contain no git repository" &&
            exit 1

        # Fetches all ignored files and removes them from affected commits
        git status --ignored --porcelain |
            awk '/[^\/]$/ {print $2}' |
            while IFS=$'\n' readline -r ignored_file; do
                git filter-branch \
                    --prune-empty \
                    --index-filter "git rm --cached --ignore-unmatch ${file}" \
                    -- --all
                # WARNING: `git rm` without `--cached` is (often) simply rm with some git management!
            done

        # # NOTE: The list of files that are currently tracked would be returned by
        # git ls-tree --full-tree --name-only -r HEAD

        # Deletes remaining references in old histories
        git for-each-ref \
            --format 'delete %(refname)' refs/original |
            git update-ref --stdin

        git reflog expire --expire="now" --all

        # Cleans up files that are now not referenced anymore
        git gc --prune="now"
    )
done
