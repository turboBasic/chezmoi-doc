---
id: cmd-cat
title: "chezmoi cat -- Print target contents to stdout"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/cat.md
related: [cmd-dump, cmd-execute-template]
---

## Summary

Writes the computed target contents of files, scripts, or symlinks to stdout. Useful for previewing what chezmoi would write without actually applying.

## Syntax / Usage

```sh
chezmoi cat target...
```

## Details

Targets must be files, scripts, or symlinks:
- For files: prints the target file contents (after template evaluation, decryption, etc.)
- For scripts: prints the script contents
- For symlinks: prints the symlink target path

This is the rendered output -- templates are evaluated, encrypted files are decrypted. It shows exactly what `chezmoi apply` would write.

## Examples

```sh
# Preview what chezmoi would write for .bashrc
chezmoi cat ~/.bashrc

# Compare current file with what chezmoi would write
diff <(cat ~/.bashrc) <(chezmoi cat ~/.bashrc)
```

## See Also

- cmd-dump
- cmd-execute-template
