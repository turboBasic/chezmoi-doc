---
id: cmd-update
title: "chezmoi update"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/update.md
related: [cmd-apply, cmd-init, cmd-diff]
---

## Summary

Pulls changes from the source repository and applies them to the destination. This is the standard way to sync dotfile updates from a remote repo to the current machine.

## Syntax / Usage

```sh
chezmoi update [flags]
```

## Details

If `update.command` is set in the configuration, chezmoi runs that command with `update.args` in the source directory working tree. Otherwise, chezmoi runs `git pull --autostash --rebase [--recurse-submodules]`, using chezmoi's built-in git if `useBuiltinGit` is true or if `git.command` cannot be found in `$PATH`.

After pulling, chezmoi applies the changes (equivalent to running `chezmoi apply`).

Key flags:

- `-a`, `--apply` -- Apply changes after pulling (default: true). Disable with `--apply=false` to pull without applying.
- `--recurse-submodules` -- Update submodules recursively (default: true). Disable with `--recurse-submodules=false`.
- `-x`, `--exclude` *types* -- Exclude target types from the apply step.
- `-i`, `--include` *types* -- Only include specified target types in the apply step.
- `--init` -- Regenerate the config file from template before applying.
- `-P`, `--parent-dirs` -- Also apply changes to parent directories.
- `-r`, `--recursive` -- Recurse into subdirectories (defaults to true).

## Examples

```sh
# Pull and apply all changes
chezmoi update

# Pull without applying (just update source state)
chezmoi update --apply=false

# Pull and apply, excluding scripts
chezmoi update --exclude=scripts
```

## Caveats / Common Mistakes

- By default `update` runs `git pull --autostash --rebase`, which means local uncommitted changes in the source directory are autostashed and reapplied. If you have conflicts, the rebase may fail and require manual resolution.
- If you set `update.command` to a custom script, chezmoi will not perform any git operations itself -- your script is fully responsible for updating the source directory.
- The `--apply` flag defaults to true. If you only want to pull changes without applying, you must explicitly pass `--apply=false`.

## See Also

- cmd-apply
- cmd-init
- cmd-diff
