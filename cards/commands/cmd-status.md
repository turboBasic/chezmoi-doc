---
id: cmd-status
title: "chezmoi status -- Show what apply would change"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/status.md
related: [cmd-verify, cmd-managed]
---

## Summary

Prints the status of managed files and scripts in a two-column format similar to `git status`, showing both what has changed since the last apply and what `chezmoi apply` would do.

## Syntax / Usage

```sh
chezmoi status [--exclude types] [--include types] [--init] [--path-style style] [--recursive]
```

## Details

The output has two columns:

| Character | Meaning   | First column (last-written vs actual) | Second column (actual vs target) |
| --------- | --------- | ------------------------------------- | -------------------------------- |
| Space     | No change | No change                             | No change                        |
| `A`       | Added     | Entry was created                     | Entry will be created            |
| `D`       | Deleted   | Entry was deleted                     | Entry will be deleted            |
| `M`       | Modified  | Entry was modified                    | Entry will be modified           |
| `R`       | Run       | Not applicable                        | Script will be run               |

The first column shows the difference between the last state written by chezmoi and the actual state on disk. The second column shows what effect running `chezmoi apply` would have.

Common flags:
- `-x`, `--exclude` *types* -- exclude entry types
- `-i`, `--include` *types* -- include only these entry types
- `--init` -- simulate init conditions
- `-p`, `--path-style` *style* -- control path output style
- `-r`, `--recursive` -- recurse into directories (default: true)

## Examples

```sh
# Show status of all managed entries
chezmoi status

# Show status of only files
chezmoi status --include=files
```

## See Also

- cmd-verify
- cmd-managed
