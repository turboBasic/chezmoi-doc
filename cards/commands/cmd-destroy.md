---
id: cmd-destroy
title: "chezmoi destroy -- Remove target from source and destination"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/destroy.md
related: [cmd-forget]
---

## Summary

Permanently removes a target from the source state, the destination directory, and the chezmoi state database. This is a destructive operation that deletes files from both your home directory and the source directory.

## Syntax / Usage

```sh
chezmoi destroy [--force] [--recursive] target...
```

## Details

`destroy` removes the target from three places simultaneously:
1. The source state (source directory)
2. The destination directory (home directory)
3. The persistent state database

Flags:
- `--force` -- destroy without prompting for confirmation
- `-r`, `--recursive` -- recursively destroy directories (default: false)

If you only want to stop managing a file without deleting it, use `forget` instead. If you want to remove all traces of chezmoi from your system, use `purge` instead.

## Examples

```sh
# Destroy a single file (will prompt for confirmation)
chezmoi destroy ~/.bashrc

# Destroy without prompting
chezmoi destroy --force ~/.bashrc

# Recursively destroy a directory
chezmoi destroy --recursive ~/.config/nvim
```

## Caveats / Common Mistakes

- This permanently deletes files from your home directory. Only use if you have backups.
- Without `--recursive`, directories will not be removed.
- Prefer `forget` if you just want chezmoi to stop managing a file.

## See Also

- cmd-forget
