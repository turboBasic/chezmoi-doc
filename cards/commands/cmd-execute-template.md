---
id: cmd-execute-template
title: "chezmoi execute-template -- Evaluate templates"
category: commands
tags: [command, template]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/execute-template.md
related: [cmd-data, cmd-cat]
---

## Summary

Executes template strings or files and prints the result to stdout. Essential for testing and debugging templates before committing them to the source state.

## Syntax / Usage

```sh
chezmoi execute-template [flags] [template...]
echo 'template' | chezmoi execute-template
chezmoi execute-template --file path/to/template
```

## Details

Template arguments are interpreted as literal template strings with no whitespace added between arguments in the output. If no templates are specified, the template is read from stdin.

Flags:
- `-f`, `--file` -- treat arguments as filenames rather than literal templates
- `-i`, `--init` -- include simulated functions only available during `chezmoi init` (promptBool, promptString, etc.)
- `--left-delimiter` *delimiter* -- set the left template delimiter
- `--right-delimiter` *delimiter* -- set the right template delimiter
- `--promptBool` *pairs* -- simulate promptBool with comma-separated prompt=value pairs
- `--promptChoice` *pairs* -- simulate promptChoice
- `--promptInt` *pairs* -- simulate promptInt
- `--promptMultichoice` *pairs* -- simulate promptMultichoice
- `-p`, `--promptString` *pairs* -- simulate promptString
- `--stdinisatty` *bool* -- simulate the stdinIsATTY function
- `--with-stdin` -- set `.chezmoi.stdin` to the contents of standard input when run with arguments

For simulated prompt functions, *pairs* is a comma-separated list of `prompt=value` pairs. If the prompt does not match any pair, the function returns a type-appropriate default (false, zero, or the prompt string unchanged).

## Examples

```sh
# Test a simple template expression
chezmoi execute-template '{{ .chezmoi.sourceDir }}'

# Concatenate template expressions (no whitespace between arguments)
chezmoi execute-template '{{ .chezmoi.os }}' / '{{ .chezmoi.arch }}'

# Read template from stdin
echo '{{ .chezmoi | toJson }}' | chezmoi execute-template

# Simulate init with promptString
chezmoi execute-template --init --promptString email=me@home.org < ~/.local/share/chezmoi/.chezmoi.toml.tmpl

# Execute a template file
chezmoi execute-template --file ~/.local/share/chezmoi/dot_bashrc.tmpl
```

## Caveats / Common Mistakes

- Without `--init`, init-only functions like `promptString` are not available and will cause errors.
- Multiple template arguments are concatenated without spaces -- use explicit separators if needed.

## See Also

- cmd-data
- cmd-cat
