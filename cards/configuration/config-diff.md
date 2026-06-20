---
id: config-diff
title: Diff Tool Configuration
category: configuration
tags: [config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/tools/diff.md
related: [config-file, config-merge, cmd-diff]
---

## Summary

chezmoi includes a built-in diff but supports configuring an external diff tool, a pager for diff output, content exclusions, direction reversal, and textconv filters for binary files.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[diff]
    command = "<diff-program>"
    args = ["{{ .Destination }}", "{{ .Target }}"]
    pager = "<pager-program>"
    exclude = ["scripts"]
    reverse = false
```

## Details

### Configuration Keys

| Key              | Type     | Default                                    | Description                                      |
| ---------------- | -------- | ------------------------------------------ | ------------------------------------------------ |
| `command`        | string   | (built-in)                                 | External diff command                            |
| `args`           | []string | `["{{ .Destination }}", "{{ .Target }}"]`  | Arguments (template with `.Destination`, `.Target`) |
| `pager`          | string   | (none)                                     | Pager for diff output                            |
| `exclude`        | []string | (none)                                     | Entry types to exclude (e.g., `scripts`, `externals`) |
| `reverse`        | bool     | `false`                                    | Reverse diff direction                           |
| `scriptContents` | bool     | `true`                                     | Show script contents in diff                     |

### Template Variables in `args`

- `.Destination` -- path to the file in the destination (current) state
- `.Target` -- path to the file in the target (desired) state

If `args` contains no template variables, `{{ .Destination }}` and `{{ .Target }}` are appended automatically.

### Textconv

The `[[textconv]]` array transforms binary files before diffing:

```toml
[[textconv]]
    pattern = "**/*.plist"
    command = "plutil"
    args = ["-convert", "xml1", "-o", "-", "-"]
```

If a target path matches multiple patterns, the entry with the longest pattern wins.

## Examples

Use meld as the diff tool:

```toml title="~/.config/chezmoi/chezmoi.toml"
[diff]
    command = "meld"
    args = ["--diff", "{{ .Destination }}", "{{ .Target }}"]
```

Use VS Code:

```toml title="~/.config/chezmoi/chezmoi.toml"
[diff]
    command = "code"
    args = ["--wait", "--diff"]
```

Use delta as a pager:

```toml title="~/.config/chezmoi/chezmoi.toml"
[diff]
    pager = "delta"
```

Use diff-so-fancy as a pager:

```toml title="~/.config/chezmoi/chezmoi.toml"
[diff]
    pager = "diff-so-fancy"
```

Exclude scripts from diff output:

```toml title="~/.config/chezmoi/chezmoi.toml"
[diff]
    exclude = ["scripts"]
```

## Caveats / Common Mistakes

- If you generate your config file from a template (`.chezmoi.toml.tmpl`), you must escape `{{` and `}}` in `diff.args` as `{{ "{{" }}` and `{{ "}}" }}`.
- The pager can be disabled with `--no-pager` flag or by setting `diff.pager` to an empty string.
- When using `diff.command`, the built-in diff is not used. To force the built-in diff, pass `--use-builtin-diff`.

## See Also

- config-file
- config-merge
