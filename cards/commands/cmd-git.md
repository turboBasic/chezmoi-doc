---
id: cmd-git
title: "chezmoi git -- Run git in the source directory"
category: commands
tags: [command, git]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/git.md
related: [cmd-cd, cmd-source-path]
---

## Summary

Runs `git` with the given arguments in the chezmoi working tree (source directory). A convenience wrapper so you do not need to `cd` into the source directory first.

## Syntax / Usage

```sh
chezmoi git [args...]
chezmoi git -- [flags] [args...]
```

## Details

Executes git in the source directory. Any flags intended for git (not chezmoi) must appear after `--` to prevent chezmoi from interpreting them as its own flags.

## Examples

```sh
# Stage all changes
chezmoi git add .

# Stage a specific source file
chezmoi git add dot_gitconfig

# Commit (note -- before the -m flag)
chezmoi git -- commit -m "Add .gitconfig"

# Push changes
chezmoi git push

# View log
chezmoi git -- log --oneline -10
```

## Caveats / Common Mistakes

- Flags like `-m`, `--oneline`, etc. must come after `--` or chezmoi will try to interpret them.
- `chezmoi git commit -m "msg"` will fail because `-m` is parsed by chezmoi. Use `chezmoi git -- commit -m "msg"` instead.

## See Also

- cmd-cd
- cmd-source-path
