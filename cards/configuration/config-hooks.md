---
id: config-hooks
title: Hooks (Pre/Post Event Commands)
category: configuration
tags: [config, script]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/configuration-file/hooks.md
related: [config-file, config-interpreters, config-git-auto]
---

## Summary

Hooks let you run commands before and after chezmoi events. Unlike scripts in the source state, hooks always execute -- even in `--dry-run` mode -- and should be fast and idempotent.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[hooks.<event>.pre]
    command = "<command>"
    args = ["arg1", "arg2"]

[hooks.<event>.post]
    command = "<command>"
    args = ["arg1", "arg2"]
```

Alternatively, use a script (executed with the configured interpreter for its extension):

```toml title="~/.config/chezmoi/chezmoi.toml"
[hooks.<event>.post]
    script = "post-hook.ps1"
```

## Details

Each event supports a `.pre` and/or `.post` command. The `.pre` command runs before the event; `.post` runs after.

A hook definition contains either `command` or `script`, plus an optional `args` array of strings:

- `command` -- executed directly.
- `script` -- executed with the configured interpreter for the script's file extension (see interpreters config).

### Defined Events

| Event               | Trigger                                       |
| ------------------- | --------------------------------------------- |
| Any command (e.g. `add`, `apply`) | Running that chezmoi command |
| `git-auto-commit`   | Generating an automatic git commit            |
| `git-auto-push`     | Running an automatic git push                 |
| `read-source-state` | Reading the source state                      |

### Environment Variables

When hooks run, the following environment variables are set:

| Variable             | Value                                          |
| -------------------- | ---------------------------------------------- |
| `CHEZMOI`            | `1`                                            |
| `CHEZMOI_COMMAND`    | The chezmoi command being run                  |
| `CHEZMOI_COMMAND_DIR`| Directory where chezmoi was invoked            |
| `CHEZMOI_ARGS`       | Full arguments to chezmoi (starting with path to executable) |

## Examples

```toml title="~/.config/chezmoi/chezmoi.toml"
[hooks.read-source-state.pre]
    command = "echo"
    args = ["pre-read-source-state-hook"]

[hooks.apply.post]
    command = "echo"
    args = ["post-apply-hook"]

[hooks.add.post]
    script = "post-add-hook.ps1"
```

## Caveats / Common Mistakes

- Hooks run even with `--dry-run`. Do not put destructive operations in hooks unless you account for this.
- Hooks should be fast and idempotent -- they run on every invocation of the associated command.
- The `script` field uses the interpreter configured for the file extension; ensure the interpreter is configured if using non-default extensions.

## See Also

- config-file
- config-interpreters
- config-git-auto
