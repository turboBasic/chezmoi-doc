---
id: cmd-re-add
title: "chezmoi re-add -- Update source state from destination changes"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/re-add.md
related: [cmd-merge, cmd-status]
---

## Summary

Re-adds modified files from the destination directory back into the source state, preserving `encrypted_` attributes. Templates and non-file entries are skipped. Use this to pull in changes made directly to files in the home directory.

## Syntax / Usage

```sh
chezmoi re-add [target...] [--exclude types] [--include types] [--re-encrypt] [--recursive]
```

## Details

If no targets are specified, all modified files are re-added. If one or more targets are given, only those targets are re-added.

Behavior:
- Preserves `encrypted_` attributes (re-encrypts the file)
- Will NOT overwrite templates (`.tmpl` files are skipped)
- Only operates on files; directories, symlinks, and scripts are ignored
- Directories are recursed into by default

Flags:
- `-x`, `--exclude` *types* -- exclude entry types
- `-i`, `--include` *types* -- include only these entry types
- `--re-encrypt` -- re-encrypt encrypted files
- `-r`, `--recursive` -- recurse into directories (default: true)

If you want to re-add a single file unconditionally (including templates), use `chezmoi add --force` instead.

## Examples

```sh
# Re-add all modified files
chezmoi re-add

# Re-add a specific file
chezmoi re-add ~/.bashrc

# Re-add without recursing into subdirectories
chezmoi re-add --recursive=false ~/.config/git
```

## Caveats / Common Mistakes

- Templates are never overwritten by `re-add`. If you need to update a template source, edit it directly or use `chezmoi add --force`.
- This does not add new files -- only files already managed by chezmoi are updated.

## See Also

- cmd-merge
- cmd-status
