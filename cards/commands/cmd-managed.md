---
id: cmd-managed
title: "chezmoi managed -- List all managed entries"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/managed.md
related: [cmd-status, cmd-forget]
---

## Summary

Lists all entries in the destination directory that chezmoi manages, in alphabetical order. Supports filtering by type and path, and output in tree, JSON, or YAML format.

## Syntax / Usage

```sh
chezmoi managed [path...] [--exclude types] [--include types] [--format json|yaml] [--path-style style] [--tree]
```

## Details

When no paths are supplied, lists all managed entries in the destination directory. When one or more paths are given, lists only managed entries under those paths.

Common flags:
- `-x`, `--exclude` *types* -- exclude entry types from the listing
- `-i`, `--include` *types* -- include only these entry types (files, dirs, symlinks, encrypted, etc.)
- `-f`, `--format` *json|yaml* -- output in structured format
- `-0`, `--nul-path-separator` -- use NUL as path separator (useful with `xargs -0`)
- `-p`, `--path-style` *style* -- control path output format
- `-t`, `--tree` -- display as a tree

## Examples

```sh
# List all managed entries
chezmoi managed

# List only managed files
chezmoi managed --include=files

# List managed files and symlinks
chezmoi managed --include=files,symlinks

# List only managed directories
chezmoi managed -i dirs

# List managed files under ~/.config
chezmoi managed -i files ~/.config

# List managed entries excluding encrypted, showing source-relative paths
chezmoi managed --exclude=encrypted --path-style=source-relative
```

## See Also

- cmd-status
- cmd-forget
