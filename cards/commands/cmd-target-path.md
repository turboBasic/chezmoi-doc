---
id: cmd-target-path
title: "chezmoi target-path -- Print target path for a source path"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/target-path.md
related: [cmd-source-path]
---

## Summary

Prints the target (destination) path corresponding to a source state path. The inverse of `source-path`. Without arguments, prints the target directory (typically the home directory).

## Syntax / Usage

```sh
chezmoi target-path [source-path...]
```

## Details

If no source paths are specified, prints the target directory (usually `~`). If one or more source paths are specified, prints the corresponding target path for each, resolving chezmoi naming conventions (e.g., `dot_` to `.`, `private_` prefix removed, etc.).

## Examples

```sh
# Print the target directory
chezmoi target-path

# Print the target path for a source file
chezmoi target-path ~/.local/share/chezmoi/dot_zshrc
# Output: /home/user/.zshrc
```

## See Also

- cmd-source-path
