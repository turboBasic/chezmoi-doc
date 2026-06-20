---
id: config-editor
title: Editor Configuration
category: configuration
tags: [config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/configuration-file/editor.md
related: [config-file, cmd-edit]
---

## Summary

chezmoi uses a configurable editor for commands like `chezmoi edit`. The editor is resolved from configuration, then environment variables, with platform-specific fallbacks.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[edit]
    command = "nvim"
    args = ["-u", "NONE"]
    minDuration = "0"
```

## Details

The editor is selected using the first non-empty value from this priority list:

1. `edit.command` configuration variable
2. `$VISUAL` environment variable
3. `$EDITOR` environment variable
4. `notepad.exe` on Windows, `vi` on all other systems

Configuration keys under the `[edit]` section:

| Key           | Type     | Default | Description                                  |
| ------------- | -------- | ------- | -------------------------------------------- |
| `command`     | string   | (none)  | Editor command                               |
| `args`        | []string | (none)  | Extra arguments passed to the editor         |
| `minDuration` | duration | `1s`    | Minimum editor session duration before warning |

If the editor returns in less than `minDuration`, chezmoi emits a warning (useful for detecting editors that fork to background). Set `minDuration` to `"0"` to disable this warning.

## Examples

Use VS Code as the editor:

```toml title="~/.config/chezmoi/chezmoi.toml"
[edit]
    command = "code"
    args = ["--wait"]
```

Use neovim with no extra arguments:

```toml title="~/.config/chezmoi/chezmoi.toml"
[edit]
    command = "nvim"
```

Disable the fast-exit warning:

```toml title="~/.config/chezmoi/chezmoi.toml"
[edit]
    command = "nvim"
    minDuration = "0"
```

## Caveats / Common Mistakes

- Editors that fork (like `code` without `--wait`, or `gvim` without `-f`) will return immediately, triggering the `minDuration` warning. Always pass the "wait" flag for GUI editors.
- If `edit.command` is set, `$VISUAL` and `$EDITOR` are ignored entirely.

## See Also

- config-file
