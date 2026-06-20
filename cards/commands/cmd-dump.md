---
id: cmd-dump
title: "chezmoi dump -- Dump target state as structured data"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/dump.md
related: [cmd-cat, cmd-data, cmd-status]
---

## Summary

Dumps the full target state (type, permissions, contents, etc.) as JSON or YAML. Shows the complete metadata chezmoi has computed for targets, not just the file contents.

## Syntax / Usage

```sh
chezmoi dump [target...] [--format json|yaml] [--exclude types] [--include types] [--init] [--recursive]
```

## Details

If no targets are specified, dumps the entire target state. The output includes entry type, permissions, content (base64 encoded for files), and other attributes.

Common flags:
- `-f`, `--format` *json|yaml* -- output format (default: JSON)
- `-x`, `--exclude` *types* -- exclude entry types
- `-i`, `--include` *types* -- include only these entry types
- `--init` -- simulate init conditions
- `-P`, `--parent-dirs` -- include parent directories
- `-r`, `--recursive` -- recurse into directories (default: true)

## Examples

```sh
# Dump the target state of .bashrc
chezmoi dump ~/.bashrc

# Dump all target state as YAML
chezmoi dump --format=yaml

# Dump and filter with jq
chezmoi dump ~/.bashrc | jq '.type'
```

## See Also

- cmd-cat
- cmd-data
- cmd-status
