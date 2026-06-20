---
id: cmd-apply
title: "chezmoi apply"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/apply.md
related: [cmd-diff, cmd-update, cmd-init]
---

## Summary

Ensures that target files match the desired target state defined in the source directory, updating them as necessary. This is the primary command for applying your dotfile configuration to the current machine.

## Syntax / Usage

```sh
chezmoi apply [target...]
```

If no targets are specified, the state of all targets is ensured.

## Details

When `chezmoi apply` runs, it compares each target's current state in the destination directory against the desired target state computed from the source directory. If they differ, chezmoi updates the target. If a target has been modified since chezmoi last wrote it, the user is prompted before overwriting.

Key flags:

- `-x`, `--exclude` *types* -- Exclude target types from the operation.
- `-i`, `--include` *types* -- Only include specified target types.
- `--init` -- Regenerate the config file from the config file template before applying.
- `-P`, `--parent-dirs` -- Also apply changes to parent directories of the specified targets.
- `-r`, `--recursive` -- Recurse into subdirectories (defaults to true).
- `--source-path` -- Specify targets by their source path rather than target path. Useful for applying changes after editing source files directly.

## Examples

```sh
# Apply all targets
chezmoi apply

# Preview what would change without modifying anything
chezmoi apply --dry-run --verbose

# Apply a single file
chezmoi apply ~/.bashrc
```

## Caveats / Common Mistakes

- If you have modified a target file outside of chezmoi since the last apply, chezmoi will prompt before overwriting. Use `--force` (global flag) to skip this prompt.
- The `--recursive` flag defaults to true, so applying a directory will apply all its contents.

## See Also

- cmd-diff
- cmd-update
- cmd-init
