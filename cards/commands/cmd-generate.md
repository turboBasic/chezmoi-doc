---
id: cmd-generate
title: "chezmoi generate -- Generate helper scripts and commit messages"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/generate.md
related: [cmd-git]
---

## Summary

Generates various outputs for use with chezmoi, including install scripts for GitHub Codespaces and git commit messages that describe source directory changes.

## Syntax / Usage

```sh
chezmoi generate output [args...]
```

## Details

Supported outputs:

| Output                    | Description                                                              |
| ------------------------- | ------------------------------------------------------------------------ |
| `git-commit-message`      | A git commit message describing changes to the source directory          |
| `install.sh`              | An install script suitable for use with GitHub Codespaces                |
| `install-init-shell.sh`   | A script that installs chezmoi, runs `chezmoi init`, and exec's a shell  |

The `install-init-shell.sh` output accepts an optional GitHub username argument.

## Examples

```sh
# Generate an install script
chezmoi generate install.sh > install.sh

# Use generated commit message for git commit
chezmoi git -- commit -m "$(chezmoi generate git-commit-message)"

# Generate install-init script for a specific user
chezmoi generate install-init-shell.sh myusername
```

## See Also

- cmd-git
