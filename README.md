# git-hub-automatisation

## Synopsis

This repository collects

- hooks for git,
- workflows for GitHub,
- further git-related scripts

which the author uses throughout his repositories.

## Repository Structure

- `.github/workflows`: GitHub Actions workflows used for continuous integration, deployment, or other automated tasks triggered by repository events.

- `scripts`: Scripts capturing the core functionality.  
    - `ci`: Scripts used in continuous integration (e.g., GitHub Actions).  
    - `pre-commit`: Scripts integrated with the pre-commit framework to run before committing code.
    - `tools`: Scripts related to git for (non-event based) local use, such as automation helpers or reporting tools.

- `.commitlintrc.js`: Configuration for [Commitlint](https://github.com/conventional-changelog/commitlint), which checks commit messages against a conventional format.

- `.pre-commit-config.yaml`: This file specifies [pre-commit](https://pre-commit.com) git hooks that should be applied to the repository itself.

- `.pre-commit-hooks.yaml`: This file provides pre-commit git hooks that other repositories can apply.
