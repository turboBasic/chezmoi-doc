---
id: cmd-archive
title: "chezmoi archive -- Generate archive of target state"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/archive.md
related: [cmd-import, cmd-dump]
---

## Summary

Generates a tar or zip archive of the computed target state. Useful for inspecting what chezmoi would apply, creating backups, or transferring dotfiles to systems without chezmoi.

## Syntax / Usage

```sh
chezmoi archive [target...] [--format format] [--gzip] [--output file] [--exclude types] [--include types] [--recursive]
```

## Details

If no targets are specified, archives the entire target state. If `--output` is set, the format is guessed from the file extension; otherwise the default format is `tar`.

Supported formats:

| Format   |
| -------- |
| `tar`    |
| `tar.gz` |
| `tgz`    |
| `zip`    |

Flags:
- `-f`, `--format` *format* -- output format
- `-z`, `--gzip` -- compress with gzip (automatic for tar.gz/tgz, ignored for zip)
- `--output` *file* -- write to file instead of stdout
- `-x`, `--exclude` *types* -- exclude entry types
- `-i`, `--include` *types* -- include only these entry types
- `--init` -- simulate init conditions
- `-P`, `--parent-dirs` -- include parent directories
- `-r`, `--recursive` -- recurse into directories (default: true)

## Examples

```sh
# Pipe to tar to list the target state
chezmoi archive | tar tvf -

# Write a gzipped tarball
chezmoi archive --output=dotfiles.tar.gz

# Write a zip file
chezmoi archive --output=dotfiles.zip

# Archive only specific targets
chezmoi archive ~/.bashrc ~/.zshrc --output=shells.tar.gz
```

## See Also

- cmd-import
- cmd-dump
