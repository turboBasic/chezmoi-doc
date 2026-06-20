---
id: concept-working-tree
title: "Working Tree vs Source Directory"
category: concepts
tags: [concept, git]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/concepts.md
related: [concept-source-state]
---

## Summary

The working tree is the git working tree that contains the source directory. Normally they are the same directory, but the working tree can be a parent of the source directory, allowing additional files (like a README or CI config) to live alongside the chezmoi source state in the same git repository.

## Details

By default, `chezmoi init` creates a git repository at `~/.local/share/chezmoi`, which serves as both the git working tree and the source directory. In this default configuration, the two are identical.

However, chezmoi supports configurations where the working tree is a **parent** of the source directory. This is useful when you want your dotfiles repository to contain files that are not part of the chezmoi source state (e.g., a `README.md`, `.github/` directory, scripts, or documentation).

In such a setup:
- The **working tree** is the root of the git repository (e.g., `~/dotfiles/`)
- The **source directory** is a subdirectory within it (e.g., `~/dotfiles/home/`)

chezmoi only looks at the source directory for computing the target state. Everything else in the working tree is invisible to chezmoi's apply logic but is still tracked by git.

The working tree location affects commands like `chezmoi cd` (which opens a shell in the working tree) and `chezmoi git` (which runs git commands in the working tree).

## Examples

Default setup (working tree equals source directory):

```sh
chezmoi init
# Creates ~/.local/share/chezmoi as both git working tree and source directory
```

Repository structure when working tree is a parent of the source directory:

```
~/dotfiles/              <- git working tree
  README.md
  .github/
  home/                  <- source directory (configured via sourceDir or .chezmoiroot)
    dot_bashrc
    dot_gitconfig
```

Using `.chezmoiroot` to set the source directory relative to the working tree:

```sh
# In the git repo root, create .chezmoiroot with content:
echo "home" > ~/dotfiles/.chezmoiroot
```

Open a shell in the working tree (for git operations):

```sh
chezmoi cd
# Opens shell in the working tree, not necessarily the source directory
```

Run git commands in the working tree:

```sh
chezmoi git -- status
chezmoi git -- add -A
chezmoi git -- commit -m "Update dotfiles"
```

## Caveats / Common Mistakes

- Confusing the working tree with the source directory. Only files in the source directory are used to compute the target state. A `README.md` at the working tree root is not applied to your home directory.
- When using `.chezmoiroot`, the file must be in the root of the git working tree and contain the relative path to the source directory.
- `chezmoi cd` opens a shell in the **working tree**, which may differ from the source directory if `.chezmoiroot` is used.

## See Also

- concept-source-state
