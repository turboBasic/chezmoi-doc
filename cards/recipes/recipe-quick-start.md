---
id: recipe-quick-start
title: Getting Started Workflow
category: recipes
tags: [recipe, command, git]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/quick-start.md
related: [recipe-new-machine]
---

## Summary

The core chezmoi workflow for managing dotfiles on your current machine: initialize, add files, edit, preview changes, apply, and push to a remote repository.

## Syntax / Usage

```sh
# Initialize chezmoi (creates ~/.local/share/chezmoi)
chezmoi init

# Add a dotfile to management
chezmoi add ~/.bashrc

# Edit the source state of a managed file
chezmoi edit ~/.bashrc

# Preview changes without applying
chezmoi diff

# Apply changes (verbose)
chezmoi -v apply

# Commit and push changes
chezmoi cd
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:$GITHUB_USERNAME/dotfiles.git
git branch -M main
git push -u origin main
exit
```

## Details

chezmoi stores the desired state of dotfiles in `~/.local/share/chezmoi` (the source directory). When you run `chezmoi apply`, it calculates the desired contents for each dotfile and makes the minimum changes required to match that desired state.

`chezmoi add` copies a file from the home directory into the source directory with appropriate naming (e.g., `~/.bashrc` becomes `dot_bashrc`).

`chezmoi edit` opens the source file in your `$EDITOR`. Changes are not applied until you explicitly run `chezmoi apply`.

The `-v` (verbose) flag prints exactly what changes will be made. The `-n` (dry run) flag prevents actual changes. Combining `-n -v` shows what would happen without doing anything.

chezmoi can be configured to automatically commit and push changes by setting `git.autoCommit = true` and `git.autoPush = true` in the config file.

## Examples

Full first-time workflow:

```sh
# Initialize
chezmoi init

# Add some dotfiles
chezmoi add ~/.bashrc
chezmoi add ~/.gitconfig
chezmoi add ~/.vimrc

# Make an edit
chezmoi edit ~/.bashrc

# Dry-run to see what would change
chezmoi -n -v apply

# Apply for real
chezmoi -v apply

# Push to remote
chezmoi cd
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:$GITHUB_USERNAME/dotfiles.git
git push -u origin main
exit
```

Enable auto-commit and auto-push:

```toml title="~/.config/chezmoi/chezmoi.toml"
[git]
    autoCommit = true
    autoPush = true
```

## Caveats / Common Mistakes

- Be careful with `autoPush` if your dotfiles repo is public -- accidentally adding a secret in plain text will push it to the public repo.
- `chezmoi edit` edits the source file, not the target file directly. The target is only updated on `chezmoi apply`.

## See Also

- recipe-new-machine
- recipe-file-types
