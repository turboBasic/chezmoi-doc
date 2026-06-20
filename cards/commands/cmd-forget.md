---
id: cmd-forget
title: "chezmoi forget -- Stop managing a target"
category: commands
tags: [command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/forget.md
related: [cmd-destroy, cmd-managed]
---

## Summary

Removes targets from the source state so chezmoi stops managing them. The actual files in the destination directory are left untouched.

## Syntax / Usage

```sh
chezmoi forget target...
```

## Details

`chezmoi forget` removes entries from the source state only. The files in the home directory remain intact. Targets must have entries in the source state. Externals cannot be forgotten with this command.

This is the safe way to stop managing a file without deleting it. Compare with `destroy` which also removes the file from the destination directory.

## Examples

```sh
# Stop managing .bashrc (file remains in ~)
chezmoi forget ~/.bashrc
```

## Caveats / Common Mistakes

- Externals (files defined in `.chezmoiexternal.*`) cannot be removed with `forget`.
- This only removes the source state entry; the target file is left as-is.

## See Also

- cmd-destroy
- cmd-managed
