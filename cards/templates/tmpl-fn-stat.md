---
id: tmpl-fn-stat
title: "Template Functions: stat / lstat"
category: templates
tags: [template, function, filesystem, conditional]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/stat.md
related: [tmpl-fn-lookpath, tmpl-fn-glob]
---

## Summary

`stat` and `lstat` query file metadata (existence, type, size, permissions, modification time). They are the primary way to conditionally include configuration based on whether files or directories exist on the target system.

## Syntax / Usage

```
{{ stat "/path/to/file" }}
{{ lstat "/path/to/file" }}
{{ (stat "/path/to/file").type }}
{{ (stat "/path/to/file").isDir }}
```

## Details

### `stat`

Runs `os.Stat` on the given path. Follows symlinks (returns info about the symlink target).

- If the path exists: returns a struct with fields `name`, `size`, `mode`, `perm`, `modTime`, `isDir`, and `type`.
- If the path does not exist: returns a false value (usable directly in `{{ if }}`).
- If `os.Stat` returns any other error: raises a template error.

### `lstat`

Runs `os.Lstat` on the given path. Does NOT follow symlinks (returns info about the symlink itself).

Same return behavior as `stat` but the `type` field will be `"symlink"` for symbolic links rather than following through to the target.

### Returned fields

| Field     | Type   | Description                                      |
|-----------|--------|--------------------------------------------------|
| `name`    | string | Base name of the file                            |
| `size`    | int    | Size in bytes                                    |
| `mode`    | string | Full file mode (type + permissions)              |
| `perm`    | string | Permission bits                                  |
| `modTime` | time   | Last modification time                           |
| `isDir`   | bool   | Whether the path is a directory                  |
| `type`    | string | File type (e.g., "file", "dir", "symlink")       |

### Hermeticity

Both functions are **not hermetic**: their return values depend on the filesystem state at template evaluation time. Use with caution.

## Examples

Check if a directory exists:

```
{{ if stat (joinPath .chezmoi.homeDir ".pyenv") }}
# ~/.pyenv exists
export PYENV_ROOT="$HOME/.pyenv"
{{ end }}
```

Check if a path is a symlink (using `lstat`):

```
{{ if eq (joinPath .chezmoi.homeDir ".xinitrc" | lstat).type "symlink" }}
# ~/.xinitrc exists and is a symlink
{{ end }}
```

Check if a file is a directory:

```
{{ if (stat "/opt/homebrew").isDir }}
# Homebrew is installed in /opt/homebrew (Apple Silicon)
{{ end }}
```

Combine with `joinPath` for cross-platform paths:

```
{{ if stat (joinPath .chezmoi.homeDir ".local" "bin" "mise") }}
# mise binary exists
{{ end }}
```

## Caveats / Common Mistakes

- `stat` follows symlinks; `lstat` does not. Use `lstat` when you need to detect whether something is a symlink.
- When a path does not exist, `stat`/`lstat` return a falsy value -- do NOT try to access fields on it (e.g., `(stat "/nonexistent").type` will error). Always guard with `{{ if }}`.
- These are not hermetic -- if the filesystem changes between evaluations, results change. Do not rely on deterministic output for reproducibility.
- The `type` field value for regular files is `"file"`, for directories is `"dir"`, and for symlinks (via `lstat`) is `"symlink"`.

## See Also

- [tmpl-fn-lookpath](tmpl-fn-lookpath.md)
- [tmpl-fn-glob](tmpl-fn-glob.md)
