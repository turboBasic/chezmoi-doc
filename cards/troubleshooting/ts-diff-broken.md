---
id: ts-diff-broken
title: Broken diff output or missing colors
category: troubleshooting
tags: [troubleshooting, command, config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/frequently-asked-questions/troubleshooting.md
related: [ts-doctor]
---

## Summary

`chezmoi diff` output appears monochrome with raw ANSI escape sequences (e.g. `ESC[37m`) when the configured pager does not pass through control characters. The fix is to configure the pager to handle raw escape sequences.

## Syntax / Usage

```sh
chezmoi diff
chezmoi diff --color=false
chezmoi diff --no-pager
```

## Details

By default, chezmoi pipes diff output containing ANSI color escape sequences into a pager (default: `less`). If the pager does not pass through these sequences, the output shows literal escape codes instead of colors.

The root cause is that `less` needs the `-R` (or `--RAW-CONTROL-CHARS`) option to display ANSI sequences correctly. Many systems configure this by default, but not all.

Three approaches to fix this:

1. Set the `LESS` environment variable globally.
2. Set the `pager` configuration variable in the chezmoi config file.
3. Use `--color=false` or `--no-pager` flags to sidestep the issue.

If you use a custom pager (via `pager` config or `PAGER` env var), ensure that pager supports raw control characters.

You can also configure an external diff command via `diff.command` and `diff.args` in the configuration file. The template variables `.Destination` and `.Target` are available in `diff.args` elements.

## Examples

Fix via environment variable:

```sh
export LESS=-R
```

Fix via chezmoi configuration file:

```toml title="~/.config/chezmoi/chezmoi.toml"
pager = "less -R"
```

Disable colors entirely:

```sh
chezmoi diff --color=false
```

Disable pager entirely:

```sh
chezmoi diff --no-pager
```

Use an external diff tool (e.g. delta):

```toml title="~/.config/chezmoi/chezmoi.toml"
[diff]
    pager = "delta"
```

## Caveats / Common Mistakes

- Setting `PAGER=less` without `LESS=-R` will still produce broken output.
- The `--color=false` flag disables colors for all output, not just the pager.
- If `diff.command` is set, chezmoi invokes it for each individual file difference rather than producing unified output.

## See Also

- ts-doctor
