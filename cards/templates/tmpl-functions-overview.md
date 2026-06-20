---
id: tmpl-functions-overview
title: "Overview of Available Template Functions"
category: templates
tags: [template, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/index.md
related: [tmpl-syntax, tmpl-include, tmpl-variables]
---

## Summary

Chezmoi templates have access to all standard Go `text/template` functions, the full sprig library of helper functions, and chezmoi-specific functions for file inclusion, password managers, JSON/TOML/YAML parsing, command execution, and more.

## Details

### Function sources

1. **Go `text/template` built-ins**: `print`, `printf`, `println`, `len`, `index`, `slice`, `call`, `html`, `js`, `urlquery`, and comparison functions (`eq`, `ne`, `lt`, `le`, `gt`, `ge`).

2. **Sprig library** (http://masterminds.github.io/sprig/): String manipulation (`trim`, `upper`, `lower`, `replace`, `contains`, `hasPrefix`, `hasSuffix`, `quote`, `squote`, `nospace`, `abbrev`, `wrap`), list functions (`list`, `first`, `last`, `append`, `prepend`, `concat`, `uniq`, `without`), dict functions (`dict`, `get`, `set`, `hasKey`, `keys`, `values`, `merge`), type conversion (`toString`, `toInt`, `toFloat64`), encoding (`b64enc`, `b64dec`), crypto, date/time, path, regex, and more.

3. **Chezmoi-specific functions** (selected highlights):

| Function | Purpose |
|---|---|
| `include` | Include literal file contents from source directory |
| `includeTemplate` | Execute a file as a template and include the result |
| `output` / `outputList` | Run a command and return stdout |
| `exec` | Run a command and return combined output |
| `lookPath` / `findExecutable` / `findOneExecutable` | Find executables on PATH |
| `glob` / `globCaseInsensitive` | Glob file patterns |
| `stat` / `lstat` | File stat information |
| `joinPath` | Join path components |
| `fromJson` / `fromJsonc` / `fromToml` / `fromYaml` / `fromIni` | Parse structured data |
| `toJson` / `toPrettyJson` / `toToml` / `toYaml` / `toIni` | Serialize to format |
| `comment` | Prefix lines with a comment character |
| `encrypt` / `decrypt` | Encrypt/decrypt data |
| `hexEncode` / `hexDecode` | Hex encoding |
| `jq` | Apply jq expressions to data |
| `replaceAllRegex` | Regex-based string replacement |
| `stdinIsATTY` | Check if stdin is a terminal |
| `warnf` | Print a warning message during template execution |
| `quoteList` | Quote a list of strings for shell use |
| `setValueAtPath` / `deleteValueAtPath` / `pruneEmptyDicts` | Manipulate nested dicts |

4. **Password manager functions**: `onepassword*`, `bitwarden*`, `keepassxc*`, `lastpass*`, `pass`, `vault`, `secret`, `gopass*`, `doppler*`, and many more. Each password manager has its own set of template functions.

### Pipeline syntax

Functions can be chained using pipelines:

```text
{{ .email | quote }}
{{ output "hostname" | trim }}
{{ .chezmoi.os | printf "OS: %s" }}
```

## Examples

Using sprig string functions:

```text
export USER={{ .chezmoi.username | upper }}
```

Running a command and using its output:

```text
{{ output "cat" "/etc/hostname" | trim }}
```

Parsing JSON from a command:

```text
{{ $data := output "some-command" "--format=json" | fromJson -}}
value = {{ $data.key }}
```

Checking if an executable exists:

```text
{{ if lookPath "brew" -}}
eval "$(brew shellenv)"
{{ end -}}
```

Using dict to build structured data:

```text
{{ dict "name" .chezmoi.hostname "os" .chezmoi.os | toYaml }}
```

## Caveats / Common Mistakes

- `output` executes a command every time the template is evaluated (on every `chezmoi apply`). Expensive commands slow down chezmoi.
- Sprig's `env` function can read environment variables, but chezmoi may run in contexts where expected variables are not set.
- Function names are case-sensitive: `fromJson` not `fromjson`.

## See Also

- tmpl-syntax
- tmpl-include
- tmpl-variables
