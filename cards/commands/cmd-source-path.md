---
id: cmd-source-path
title: "chezmoi source-path -- Print source path for a target"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/source-path.md
related: [cmd-target-path, cmd-cd]
---

## Summary

Prints the source directory path corresponding to a target path. Without arguments, prints the root source directory. Useful for scripting and for navigating to source files.

## Syntax / Usage

```sh
chezmoi source-path [target...]
```

## Details

If no targets are specified, prints the source directory (typically `~/.local/share/chezmoi`). If one or more targets are specified, prints the corresponding source file path for each.

This is commonly used to:
- Change the current shell's directory to the source directory: `cd $(chezmoi source-path)`
- Open a source file in an editor: `$EDITOR $(chezmoi source-path ~/.bashrc)`

## Examples

```sh
# Print the source directory
chezmoi source-path

# Print the source path for .bashrc
chezmoi source-path ~/.bashrc

# Change to the source directory in the current shell
cd $(chezmoi source-path)
```

## See Also

- cmd-target-path
- cmd-cd
