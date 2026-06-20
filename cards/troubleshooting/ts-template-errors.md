---
id: ts-template-errors
title: Debugging template errors
category: troubleshooting
tags: [troubleshooting, template, command]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/user-guide/frequently-asked-questions/troubleshooting.md
related: [ts-doctor, ts-edit-blank]
---

## Summary

Template errors in chezmoi can be debugged using `chezmoi execute-template` to test template fragments or entire files interactively, and `chezmoi data` to inspect available template variables.

## Syntax / Usage

```sh
# Test a template fragment
chezmoi execute-template '{{ .chezmoi.hostname }}'

# Test a template file from source directory
chezmoi execute-template < ~/.local/share/chezmoi/dot_zshrc.tmpl

# Test with simulated init-time functions
chezmoi execute-template --init --promptString email=me@home.org < ~/.local/share/chezmoi/.chezmoi.toml.tmpl

# View all available template data
chezmoi data
```

## Details

### Common template error: exec format error

The error `fork/exec /tmp/XXXXXXXXXX.XX: exec format error` when executing a template script occurs when there is a newline before the `#!` shebang line. This happens because a template directive on the first line emits a newline before the shebang.

The fix is to suppress the newline by adding `-` before the closing `}}` on template directives that precede the shebang:

```text
{{ if eq .chezmoi.os "linux" -}}
#!/bin/sh
```

### Common template error: no such file or directory on Nix/Termux

The error `fork/exec ...: no such file or directory` occurs when scripts use a hardcoded shebang like `#!/bin/bash` on systems where `/bin/bash` does not exist (Nix, Termux).

The fix is to make the script a template and use `lookPath`:

```text
#!{{ lookPath "bash" }}
```

### Testing templates interactively

`chezmoi execute-template` interprets each argument as a literal template and outputs the result. Without arguments, it reads from stdin, which is useful for testing whole template files.

Flags for simulating init-time functions:

- `--init` enables simulated init-only functions
- `--promptString prompt=value` simulates `promptString` responses
- `--promptBool prompt=value` simulates `promptBool` responses
- `--promptInt prompt=value` simulates `promptInt` responses
- `--promptChoice prompt=value` simulates `promptChoice` responses
- `-f` / `--file` treats arguments as filenames instead of literal templates
- `--left-delimiter` / `--right-delimiter` sets custom delimiters

### Escaping template delimiters

To produce literal `{{` or `}}` in template output:

```text
{{ "{{" }}
{{ "}}" }}
```

## Examples

Test what OS chezmoi detects:

```sh
chezmoi execute-template '{{ .chezmoi.os }}' / '{{ .chezmoi.arch }}'
```

Dump all chezmoi data as JSON:

```sh
echo '{{ .chezmoi | toJson }}' | chezmoi execute-template
```

Test an init config template with simulated prompts:

```sh
chezmoi execute-template --init --promptString email=me@home.org < ~/.local/share/chezmoi/.chezmoi.toml.tmpl
```

Test a source file directly:

```sh
chezmoi execute-template -f ~/.local/share/chezmoi/dot_zshrc.tmpl
```

Fix shebang newline issue (before):

```text
{{ if eq .chezmoi.os "linux" }}
#!/bin/sh
echo "hello"
{{ end }}
```

Fix shebang newline issue (after):

```text
{{ if eq .chezmoi.os "linux" -}}
#!/bin/sh
echo "hello"
{{ end }}
```

## Caveats / Common Mistakes

- When using `chezmoi execute-template` with stdin on PowerShell, use `cat file | chezmoi execute-template` instead of `<` redirection.
- Templates in `.chezmoitemplates/` are executed with `nil` data by default. You must pass `.` explicitly when including them: `{{ template "part.tmpl" . }}`.
- The `-` whitespace trimmer (`{{-` and `-}}`) removes all adjacent whitespace including newlines, which can unexpectedly join lines.

## See Also

- ts-doctor
- ts-edit-blank
