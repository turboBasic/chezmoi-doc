---
id: tmpl-fn-glob
title: "Template Functions: glob / globCaseInsensitive"
category: templates
tags: [template, function, file-matching, glob]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/glob.md
related: [tmpl-fn-stat, tmpl-fn-include]
---

## Summary

`glob` and `globCaseInsensitive` return lists of files matching a pattern using doublestar glob syntax. They enable templates to dynamically discover and iterate over files in the destination directory.

## Syntax / Usage

```
{{ glob "pattern" }}
{{ globCaseInsensitive "pattern" }}
```

## Details

**`glob`** returns a list of file paths matching *pattern* according to the [`doublestar.Glob`](https://pkg.go.dev/github.com/bmatcuk/doublestar/v4#Glob) implementation. Relative paths in the pattern are interpreted relative to the **destination directory** (typically `$HOME`).

**`globCaseInsensitive`** behaves identically but performs case-insensitive matching on the pattern.

Both support doublestar syntax, which extends standard glob patterns with `**` for recursive directory matching.

The returned value is a list of strings (file paths) that can be iterated with `range`.

## Examples

Iterate over all `.conf` files in a directory:

```
{{ range glob (joinPath .chezmoi.homeDir ".config/myapp/*.conf") }}
# Found: {{ . }}
{{ end }}
```

Conditionally include config based on file existence:

```
{{ if glob (joinPath .chezmoi.homeDir ".ssh/id_*") }}
# SSH keys exist
{{ end }}
```

Case-insensitive matching (useful on macOS/Windows):

```
{{ range globCaseInsensitive (joinPath .chezmoi.homeDir "Documents/*.PDF") }}
{{ . }}
{{ end }}
```

## Caveats / Common Mistakes

- Relative paths are relative to the **destination directory** (usually `$HOME`), not the source directory. This differs from `include` which is relative to the source directory.
- `glob` is not hermetic -- results depend on the current filesystem state. Files created after template evaluation will not be matched.
- An empty result (no matches) is a nil/empty list which is falsy in `{{ if }}` conditions.
- Use `joinPath` to construct absolute patterns for predictable behavior across platforms.

## See Also

- [tmpl-fn-stat](tmpl-fn-stat.md)
- [tmpl-fn-include](tmpl-fn-include.md)
