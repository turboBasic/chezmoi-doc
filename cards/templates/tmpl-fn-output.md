---
id: tmpl-fn-output
title: "Template Functions: output / outputList"
category: templates
tags: [template, function, command-execution]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/output.md
related: [tmpl-fn-lookpath, tmpl-fn-include]
---

## Summary

`output` and `outputList` execute external commands during template evaluation and return their stdout. They enable dynamic configuration based on system state, command output, or external tool queries.

## Syntax / Usage

```
{{ output "command" "arg1" "arg2" }}
{{ output "command" "arg1" "arg2" | trim }}

{{- $args := (list "arg1" "arg2") }}
{{ outputList "command" $args | trim }}
```

## Details

**`output`** takes the command name followed by individual arguments as separate string parameters. It returns the raw stdout of the command including any trailing newline.

**`outputList`** is identical in behavior but accepts arguments as a list, enabling programmatic construction of the argument list. This is useful when arguments are computed in earlier template logic.

Both functions:

- Return stdout as a string
- Cause template execution to fail with an error if the command exits non-zero
- Execute every time the template is evaluated (not cached)
- Require the command to be both idempotent and fast (user responsibility)

Use `| trim` to strip trailing newlines from command output.

## Examples

Get the current kubectl context:

```
current-context: {{ output "kubectl" "config" "current-context" | trim }}
```

Using `outputList` with a programmatically built argument list:

```
{{- $args := (list "config" "current-context") }}
current-context: {{ outputList "kubectl" $args | trim }}
```

Conditionally include config based on a command's output:

```
{{ $gitEmail := output "git" "config" "--global" "user.email" | trim }}
[user]
  email = {{ $gitEmail }}
```

## Caveats / Common Mistakes

- Commands run on every template evaluation (e.g., during `chezmoi apply`, `chezmoi diff`, `chezmoi status`). Slow commands degrade performance across all chezmoi operations.
- If the command is not found or returns a non-zero exit code, the entire template fails. Guard with `lookPath` if the command may not be installed.
- Output includes trailing newlines -- always pipe through `| trim` unless you want them.
- Commands must be idempotent since they run repeatedly.

## See Also

- [tmpl-fn-lookpath](tmpl-fn-lookpath.md)
- [tmpl-fn-include](tmpl-fn-include.md)
