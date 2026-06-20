---
id: cmd-verify
title: "chezmoi verify -- Check if targets match target state"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/verify.md
related: [cmd-status, cmd-doctor]
---

## Summary

Verifies that all targets match their computed target state. Exits with code 0 if everything matches, or code 1 if any target is out of sync. Useful in scripts and CI to check drift.

## Syntax / Usage

```sh
chezmoi verify [target...] [--exclude types] [--include types] [--init] [--recursive]
```

## Details

If no targets are specified, all managed targets are checked. The command produces no output on success -- only the exit code indicates the result.

Common flags:
- `-x`, `--exclude` *types* -- exclude entry types
- `-i`, `--include` *types* -- include only these entry types
- `--init` -- simulate init conditions
- `-P`, `--parent-dirs` -- include parent directories
- `-r`, `--recursive` -- recurse into directories (default: true)

Exit codes:
- 0: all targets match their target state
- 1: one or more targets do not match

## Examples

```sh
# Verify all targets
chezmoi verify

# Verify a single file
chezmoi verify ~/.bashrc

# Use in a script
if chezmoi verify; then
  echo "Everything is in sync"
else
  echo "Drift detected"
fi
```

## See Also

- cmd-status
- cmd-doctor
