---
id: config-file
title: Configuration File Location and Format
category: configuration
tags: [config, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/configuration-file/index.md
related: [config-hooks, config-editor, config-interpreters, config-diff, config-merge, config-git-auto]
---

## Summary

chezmoi reads its configuration from a single file located according to the XDG Base Directory Specification. The file can be in TOML, YAML, JSON, or JSONC format, and controls all aspects of chezmoi behavior including git automation, diff/merge tools, encryption, and editor settings.

## Syntax / Usage

The config file is typically located at:

```
$HOME/.config/chezmoi/chezmoi.$FORMAT
```

Where `$FORMAT` is one of `json`, `jsonc`, `toml`, or `yaml`.

Override with CLI flags:

```sh
chezmoi --config /path/to/config --config-format toml apply
```

## Details

- chezmoi searches for the config file according to XDG Base Directory Specification.
- The base name must be `chezmoi` (e.g., `chezmoi.toml`, `chezmoi.yaml`).
- If multiple config file formats are present in the same directory, chezmoi reports an error.
- Format is auto-detected from the file extension but can be overridden with `--config-format`.
- On Windows the path is `%USERPROFILE%/.config/chezmoi/chezmoi.$FORMAT`.

Key top-level configuration sections include:

| Section         | Purpose                                |
| --------------- | -------------------------------------- |
| `git`           | Auto-commit, auto-push, git command    |
| `diff`          | External diff tool, pager, exclusions  |
| `merge`         | External merge tool                    |
| `edit`          | Editor command and arguments           |
| `interpreters`  | Script interpreter overrides           |
| `hooks`         | Pre/post event hook commands           |
| `pinentry`      | Password entry program                 |
| `textconv`      | Binary-to-text conversion for diffs    |
| `warnings`      | Suppress specific warnings             |
| `add`           | Defaults for the `add` command         |
| `update`        | Custom update command (non-git VCS)    |

Top-level keys include `sourceDir`, `destDir`, `umask`, `color`, `useBuiltinAge`, `useBuiltinGit`, `cacheDir`, `persistentState`.

## Examples

```toml title="~/.config/chezmoi/chezmoi.toml"
sourceDir = "/home/user/.dotfiles"
umask = 0o22

[git]
    autoCommit = true
    autoPush = true

[diff]
    pager = "delta"

[edit]
    command = "nvim"
```

```yaml title="~/.config/chezmoi/chezmoi.yaml"
sourceDir: /home/user/.dotfiles
git:
    autoPush: true
```

```json title="~/.config/chezmoi/chezmoi.json"
{
    "sourceDir": "/home/user/.dotfiles",
    "git": {
        "autoPush": true
    }
}
```

## Caveats / Common Mistakes

- Only one config file format is allowed. Having both `chezmoi.toml` and `chezmoi.yaml` in the same directory causes an error.
- The config file template (`.chezmoi.toml.tmpl` in source state) is evaluated during `chezmoi init` to generate the actual config file -- it is not the config file itself.

## See Also

- config-hooks
- config-editor
- config-interpreters
- config-diff
- config-merge
- config-git-auto
