---
id: cmd-cd
title: "chezmoi cd -- Launch a shell in the source directory"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/cd.md
related: [cmd-source-path]
---

## Summary

Launches a subshell in the chezmoi working tree (source directory), optionally at the source path corresponding to a given target path. Useful for quick edits to source state files.

## Syntax / Usage

```sh
chezmoi cd [path]
```

## Details

chezmoi launches the command set by the `cd.command` configuration variable with any extra arguments specified by `cd.args`. If not configured, chezmoi attempts to detect the user's shell and falls back to an OS-specific default.

If the optional argument *path* is present, the shell is launched in the source directory corresponding to that path.

The shell will have various `CHEZMOI*` environment variables set, as for scripts.

This command does **not** change the directory of the current shell -- it spawns a new subshell. To change the current shell's directory to the source directory, use `cd $(chezmoi source-path)` instead.

## Examples

```sh
# Open a shell in the source directory
chezmoi cd

# Open a shell in the source directory corresponding to home
chezmoi cd ~

# Open a shell in the source directory for ~/.config
chezmoi cd ~/.config

# Change the CURRENT shell to the source directory (no subshell)
cd $(chezmoi source-path)
```

## Caveats / Common Mistakes

- `chezmoi cd` opens a new subshell; exiting it returns you to the original shell. It does not change the working directory of the calling shell.
- To affect the current shell, use the `cd $(chezmoi source-path)` pattern.

## See Also

- cmd-source-path
