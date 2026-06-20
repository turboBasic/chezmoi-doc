---
id: cmd-diff
title: "chezmoi diff"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/diff.md
related: [cmd-apply, cmd-update]
---

## Summary

Prints the difference between the target state (what chezmoi wants) and the destination state (what currently exists on disk). Use this to preview what `chezmoi apply` would change.

## Syntax / Usage

```sh
chezmoi diff [flags] [target...]
```

If no targets are specified, prints differences for all targets.

## Details

By default, the diff shows what changes chezmoi would make to the destination to bring it in line with the target state.

If `diff.pager` is set in the configuration file, output is piped through it.

If `diff.command` is set, that external command is invoked for each individual file difference with `diff.args` as arguments. Each element of `diff.args` is interpreted as a template with `.Destination` and `.Target` variables available (paths to the destination and target state files respectively). Default `diff.args`: `["{{ .Destination }}", "{{ .Target }}"]`. If `diff.args` contains no template arguments, `{{ .Destination }}` and `{{ .Target }}` are appended automatically.

Key flags:

- `--pager` *pager* -- Set the pager for output. Configuration: `diff.pager`.
- `--reverse` -- Reverse the diff direction: show changes to the target required to match the destination. Configuration: `diff.reverse`.
- `--script-contents` -- Show script contents in the diff output (default: true).
- `-x`, `--exclude` *types* -- Exclude target types.
- `-i`, `--include` *types* -- Only include specified target types.
- `--init` -- Regenerate the config file from template before computing diff.
- `-P`, `--parent-dirs` -- Also diff parent directories.
- `-r`, `--recursive` -- Recurse into subdirectories (defaults to false for `diff`).

## Examples

```sh
# Show all pending changes
chezmoi diff

# Show changes for a specific file
chezmoi diff ~/.bashrc

# Use an external diff tool (configured in chezmoi.toml)
# [diff]
#   command = "delta"
chezmoi diff
```

## Caveats / Common Mistakes

- Unlike most other chezmoi commands, `--recursive` defaults to **false** for `diff`. To see changes in subdirectories, pass `-r` explicitly.
- The `--reverse` flag is useful when you want to see what changed in the destination relative to what chezmoi expects (e.g., to identify manual edits).

## See Also

- cmd-apply
- cmd-update
