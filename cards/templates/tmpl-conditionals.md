---
id: tmpl-conditionals
title: "Using if/else for Machine Differences"
category: templates
tags: [template, concept, recipe]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/manage-machine-to-machine-differences.md
related: [tmpl-syntax, tmpl-variables, tmpl-data]
---

## Summary

Chezmoi's `if`/`else if`/`else`/`end` control structures let you include or exclude content based on the current machine's OS, hostname, or any custom data variable. This is the primary mechanism for managing machine-to-machine configuration differences.

## Syntax / Usage

```text
{{ if CONDITION }}
  content for true
{{ else if OTHER_CONDITION }}
  content for other
{{ else }}
  fallback content
{{ end }}
```

## Details

### Comparison functions

| Function | Meaning |
|---|---|
| `eq a b` | a == b (also accepts multiple args: true if a equals any of b, c, ...) |
| `ne a b` | a != b |
| `lt a b` | a < b |
| `le a b` | a <= b |
| `gt a b` | a > b |
| `ge a b` | a >= b |

### Boolean functions

| Function | Meaning |
|---|---|
| `not x` | Boolean negation |
| `and x y ...` | True if all arguments are truthy (short-circuit semantics) |
| `or x y ...` | True if any argument is truthy (short-circuit semantics) |

### Combining conditions

Use parentheses to chain operators:

```text
{{ if (and (eq .chezmoi.os "linux") (ne .email "me@home.org")) }}
...
{{ end }}
```

Parentheses are required to prevent all arguments from being passed to the outer function.

### Empty template result removes file

If the entire template result is empty after execution, chezmoi removes the target file. This lets you conditionally include entire files.

### Using .chezmoiignore for coarser control

For ignoring entire files or directories on specific machines, `.chezmoiignore` is a template that specifies patterns:

```text
{{- if ne .chezmoi.hostname "work-laptop" }}
.work
{{- end }}
```

Note the inverted logic: chezmoi installs everything by default, so you ignore what you do not want.

## Examples

OS-based conditional:

```text title="dot_bashrc.tmpl"
{{ if eq .chezmoi.os "darwin" -}}
export HOMEBREW_PREFIX=/opt/homebrew
eval "$(brew shellenv)"
{{ else if eq .chezmoi.os "linux" -}}
export PATH="$HOME/.local/bin:$PATH"
{{ end -}}
```

Hostname-based conditional:

```text title="dot_bashrc.tmpl"
# common config
export EDITOR=vi

{{- if eq .chezmoi.hostname "work-laptop" }}
# work-only config
export HTTP_PROXY=http://proxy.corp:8080
{{- end }}
```

Combined conditions:

```text
{{ if (and (eq .chezmoi.os "linux") (eq .chezmoi.arch "arm64")) -}}
# ARM64 Linux specific
{{ end -}}
```

Multi-value eq (true if os matches any listed value):

```text
{{ if eq .chezmoi.os "darwin" "linux" -}}
# unix-like systems
{{ end -}}
```

Using custom data variables:

```text
{{ if .isWork -}}
[http]
    proxy = http://proxy.corp:8080
{{ end -}}
```

Ignoring files per machine (in `.chezmoiignore`):

```text
README.md
{{- if ne .chezmoi.os "darwin" }}
Library
{{- end }}
{{- if ne .chezmoi.os "linux" }}
.config/systemd
{{- end }}
```

## Caveats / Common Mistakes

- Forgetting whitespace trimming: `{{ if ... }}` leaves a blank line. Use `{{- if ... }}` or `{{ if ... -}}` to avoid it.
- `.chezmoiignore` uses inverted logic (ignore if NOT the target machine). Accidentally using `eq` instead of `ne` will ignore files on the wrong machine.
- `eq` with multiple arguments checks if the first arg equals ANY of the others. `{{ if eq .chezmoi.os "darwin" "linux" }}` means "if os is darwin OR linux".
- Boolean `and`/`or` evaluate all arguments regardless (no true short-circuit in the Go sense), so side-effect functions will still execute.

## See Also

- tmpl-syntax
- tmpl-variables
- tmpl-data
