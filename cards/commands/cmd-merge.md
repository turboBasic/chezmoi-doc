---
id: cmd-merge
title: "chezmoi merge -- Three-way merge between destination, source, and target"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/merge.md
related: [cmd-re-add, cmd-status]
---

## Summary

Performs a three-way merge between the destination state (what is on disk), the source state (what is in the source directory), and the target state (what chezmoi would write). Used to reconcile manual edits with source changes.

## Syntax / Usage

```sh
chezmoi merge target...
```

## Details

The merge tool is defined by the `merge.command` configuration variable and defaults to `vimdiff`. If multiple targets are specified, the merge tool is invoked separately and sequentially for each target.

The order of arguments passed to the merge command is controlled by `merge.args`, which defaults to `["{{ .Destination }}", "{{ .Source }}", "{{ .Target }}"]`. Each argument is interpreted as a template with these variables:
- `.Destination` -- path of the file in the destination directory
- `.Source` -- path of the file in the source state
- `.Target` -- path of the computed target state (temporary file)

If `merge.args` does not contain any template arguments, `.Destination`, `.Source`, and `.Target` are appended automatically.

If the target state cannot be computed (e.g., template errors or undecryptable encrypted files), a two-way merge is performed instead.

## Examples

```sh
# Merge .bashrc
chezmoi merge ~/.bashrc

# Merge multiple files sequentially
chezmoi merge ~/.bashrc ~/.zshrc
```

## Caveats / Common Mistakes

- If no merge tool is configured and `vimdiff` is not available, the command will fail.
- The target state is written to a temporary file; the merge tool must handle three file arguments.

## See Also

- cmd-re-add
- cmd-status
