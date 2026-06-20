---
id: config-git-auto
title: Git Auto-Commit and Auto-Push
category: configuration
tags: [config, git]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/daily-operations.md
related: [config-file, config-hooks]
---

## Summary

chezmoi can automatically commit and push changes to the source directory git repository whenever the source state changes. This is controlled by `git.autoCommit` and `git.autoPush` configuration keys, both disabled by default.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[git]
    autoCommit = true
    autoPush = true
```

## Details

### Configuration Keys

| Key                         | Type   | Default | Description                                              |
| --------------------------- | ------ | ------- | -------------------------------------------------------- |
| `autoCommit`                | bool   | `false` | Automatically commit changes to the source directory     |
| `autoPush`                  | bool   | `false` | Automatically push commits to the remote                 |
| `commitMessageTemplate`     | string | (auto)  | Go template for the commit message                       |
| `commitMessageTemplateFile` | string | (none)  | Path to commit message template file (relative to source dir) |
| `command`                   | string | `git`   | Git command to use (allows alternative VCS)              |

### Behavior

- `autoPush` implies `autoCommit`. Setting `autoPush = true` automatically enables auto-commit behavior even if `autoCommit` is not explicitly set.
- If only `autoCommit` is true, changes are committed locally but not pushed.
- When `autoCommit` is true, chezmoi runs `git add` and `git commit` as part of its workflow whenever the source state is modified.
- The default commit message is auto-generated based on the files changed.
- `commitMessageTemplate` is evaluated as a Go template. You can use template functions like `promptString` to interactively request a message.
- `commitMessageTemplateFile` specifies a path relative to the source directory for longer commit message templates.

### Related Hooks

Hooks can be attached to the git automation events:

- `hooks.git-auto-commit.pre` / `hooks.git-auto-commit.post`
- `hooks.git-auto-push.pre` / `hooks.git-auto-push.post`

### Built-in Git

chezmoi includes a built-in git implementation used when `useBuiltinGit` is `auto` (default) and no external `git` command is found in `$PATH`. The built-in git only supports HTTP/HTTPS transports and does not support `git-repo` externals.

To use an alternative VCS (e.g., fossil), set `git.command` to your VCS binary and `useBuiltinGit` to `false`.

## Examples

Auto-commit and push silently:

```toml title="~/.config/chezmoi/chezmoi.toml"
[git]
    autoCommit = true
    autoPush = true
```

Auto-commit only (no push):

```toml title="~/.config/chezmoi/chezmoi.toml"
[git]
    autoCommit = true
```

Prompt for commit message each time:

```toml title="~/.config/chezmoi/chezmoi.toml"
[git]
    autoCommit = true
    commitMessageTemplate = "{{ promptString \"Commit message\" }}"
```

Use a template file for longer commit messages:

```toml title="~/.config/chezmoi/chezmoi.toml"
[git]
    autoCommit = true
    commitMessageTemplateFile = ".commit_message.tmpl"
```

Hook into auto-push events:

```toml title="~/.config/chezmoi/chezmoi.toml"
[git]
    autoCommit = true
    autoPush = true

[hooks.git-auto-push.pre]
    command = "echo"
    args = ["About to push changes..."]
```

## Caveats / Common Mistakes

- Be careful with `autoPush` on public repos. If you accidentally add a secret in plain text, it will be pushed immediately to your public repository.
- `autoPush` implies `autoCommit`. You do not need to set both explicitly, though doing so is harmless and more readable.
- Auto add/commit/push only works with git (or git-compatible VCS via `git.command`). Non-git VCS systems require manual commits.
- The auto-commit workflow includes `git status`, `git add`, and `git commit` internally. There is no separate `git.autoAdd` configuration key.

## See Also

- config-file
- config-hooks
