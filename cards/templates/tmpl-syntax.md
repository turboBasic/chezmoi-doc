---
id: tmpl-syntax
title: "Go text/template Syntax Basics in Chezmoi"
category: templates
tags: [template, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/templating.md
related: [tmpl-variables, tmpl-conditionals, tmpl-functions-overview, tmpl-include]
---

## Summary

Chezmoi uses Go's `text/template` syntax for dynamic file content. Template actions are enclosed in `{{` and `}}` delimiters, and the result determines the target file contents (or symlink target).

## Syntax / Usage

```text
{{ .variableName }}
{{ functionName arg1 arg2 }}
{{ arg1 | functionName }}
{{- .trimmed -}}
```

## Details

A source file is treated as a template when either:

- The file name has a `.tmpl` suffix.
- The file resides in the `.chezmoitemplates` directory (or a subdirectory).

Text outside `{{ }}` actions is copied literally. Inside the delimiters you can place variables, pipelines (using `|`), or control structures (`if`, `else`, `range`, `with`, `template`, `block`).

Chezmoi uses `text/template`'s `missingkey=error` option by default, meaning misspelled or missing map keys raise an error. This can be overridden in the config file:

```toml
[template]
    options = ["missingkey=zero"]
```

If the template result for a file is empty, the target file is removed (unless the source has an `empty_` prefix). For symlinks, leading/trailing whitespace is stripped from the result before use.

### Whitespace trimming

Place a minus sign next to a delimiter to strip adjacent whitespace:

- `{{-` trims whitespace before the action.
- `-}}` trims whitespace after the action.

This removes all tabs, spaces, newlines, and carriage returns in the trimmed direction.

### Custom delimiters (directives)

If the default delimiters conflict with file content, override them per-file:

```sh
#!/bin/sh
# chezmoi:template:left-delimiter="# [[" right-delimiter=]]

# [[ "true" ]]
```

Directive lines are removed from the output.

## Examples

Simple variable interpolation:

```text
HOSTNAME={{- .chezmoi.hostname }}
```

Pipeline with a function:

```text
[user]
    email = {{ .email | quote }}
```

Testing a template from the command line:

```sh
chezmoi execute-template '{{ .chezmoi.os }}/{{ .chezmoi.arch }}'
```

Testing a template file via stdin:

```sh
chezmoi execute-template < dot_zshrc.tmpl
```

## Caveats / Common Mistakes

- Forgetting the leading dot: variables are accessed as `.chezmoi.os`, not `chezmoi.os`.
- With `missingkey=error` (the default), a typo in a variable name causes `chezmoi apply` to fail rather than silently producing empty output.
- Whitespace trimming (`{{-` / `-}}`) is greedy and removes all adjacent whitespace including newlines, which can collapse lines unexpectedly.

## See Also

- tmpl-variables
- tmpl-conditionals
- tmpl-functions-overview
- tmpl-include
