---
id: tmpl-fn-lookpath
title: "Template Functions: lookPath / findExecutable / findOneExecutable"
category: templates
tags: [template, function, path-lookup, conditional]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/lookPath.md
related: [tmpl-fn-output, tmpl-fn-stat]
---

## Summary

`lookPath`, `findExecutable`, and `findOneExecutable` search for executables on the system. They are the primary mechanism for conditionally including configuration based on which programs are installed.

## Syntax / Usage

```
{{ lookPath "program" }}
{{ findExecutable "program" (list "dir1" "dir2") }}
{{ findOneExecutable (list "prog1" "prog2") (list "dir1" "dir2") }}
```

## Details

### `lookPath`

Searches for an executable named *file* in the directories listed in the `PATH` environment variable. If the file contains a slash, it is tried directly without consulting PATH. Returns the path to the executable, or an empty string if not found.

The return value of the first successful call is cached for subsequent calls with the same file.

### `findExecutable`

Searches for a single executable named *file* in the specified *path-list* directories. The path-list directories are relative to `$HOME`. Returns the full path (directory + filename) or an empty string if not found.

Provided as an alternative to `lookPath` so you can search directories that will be in PATH *after* `chezmoi apply` (e.g., `~/.cargo/bin` that gets added to PATH by a managed shell config).

Results are cached for identical parameters.

### `findOneExecutable`

Searches for the first matching executable from *file-list* across directories in *path-list*. Each directory is searched for all candidates before moving to the next directory. Returns the full path or empty string.

Useful for finding the "best available" variant of a tool (e.g., `eza` vs `exa`).

Results are cached for identical parameters.

### Shared properties

- All three are **not hermetic**: results depend on filesystem state at evaluation time.
- On Windows, the resulting path includes the first matching executable extension from `%PathExt%`.

## Examples

Conditionally include config if a tool exists:

```
{{ if lookPath "diff-so-fancy" }}
# diff-so-fancy is in $PATH
{{ end }}
```

Check for an executable in directories that will be in PATH after apply:

```
{{ if findExecutable "mise" (list "bin" "go/bin" ".cargo/bin" ".local/bin") }}
# $HOME/.cargo/bin/mise exists and will probably be in $PATH after apply
{{ end }}
```

Find the first available alternative:

```
{{ if findOneExecutable (list "eza" "exa") (list "bin" "go/bin" ".cargo/bin" ".local/bin") }}
# One of eza or exa is available
{{ end }}
```

Guard an `output` call to avoid template failure:

```
{{ if lookPath "kubectl" }}
current-context: {{ output "kubectl" "config" "current-context" | trim }}
{{ end }}
```

## Caveats / Common Mistakes

- `lookPath` searches the current `PATH`; `findExecutable`/`findOneExecutable` search relative to `$HOME`. They serve different use cases.
- These functions are not hermetic -- if a binary is installed after the template was last evaluated, results change. Be cautious with caching assumptions.
- `findExecutable` and `findOneExecutable` path-list entries are relative to the home directory, not absolute paths or relative to CWD.
- An empty string is falsy in Go templates, so you can use these directly in `{{ if }}` conditions.

## See Also

- [tmpl-fn-output](tmpl-fn-output.md)
- [tmpl-fn-stat](tmpl-fn-stat.md)
