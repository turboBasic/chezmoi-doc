---
id: recipe-ignore
title: Using .chezmoiignore for Machine-Specific Exclusions
category: recipes
tags: [recipe, config, template]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/special-files/chezmoiignore.md
related: [recipe-file-types]
---

## Summary

`.chezmoiignore` lets you exclude files from being applied to the target directory. Because it is interpreted as a template, you can conditionally ignore files based on machine-specific variables like OS, hostname, or custom data.

## Syntax / Usage

```text title="~/.local/share/chezmoi/.chezmoiignore"
# Static pattern -- always ignored
README.md

# Glob patterns
*.txt
*/*.txt

# Directory patterns
backups/      # ignore the folder itself but not contents
backups/**    # ignore contents but not the folder

# Exclude pattern (never removed, takes priority over all includes)
!important-file.txt

# Template conditional
{{- if ne .chezmoi.os "linux" }}
.linux-only-config
{{- end }}
```

## Details

Patterns are matched using `doublestar.Match` against the **target path** (not the source path). This means you write patterns using the actual filenames as they appear in your home directory (e.g., `.bashrc`, not `dot_bashrc`).

`.chezmoiignore` is always interpreted as a template, whether or not it has a `.tmpl` extension. This enables conditional ignoring based on template variables.

Key rules:
- Comments start with `#`. A mid-line `#` must be preceded by whitespace to be treated as a comment.
- Exclude patterns (prefixed with `!`) take priority over all include patterns.
- Targets listed in `.chezmoiignore` will never be removed by `.chezmoiremove`.
- `.chezmoiignore` files in source state subdirectories apply only to that subdirectory.

## Examples

Ignore files based on operating system:

```text title="~/.local/share/chezmoi/.chezmoiignore"
README.md
LICENSE

{{- if ne .chezmoi.os "darwin" }}
.macos-defaults.sh
Library/**
{{- end }}

{{- if ne .chezmoi.os "linux" }}
.Xresources
.xinitrc
{{- end }}

{{- if ne .chezmoi.os "windows" }}
Documents/**
{{- end }}
```

Ignore files based on custom data (e.g., work vs. personal):

```text title="~/.local/share/chezmoi/.chezmoiignore"
{{- if ne .email "firstname.lastname@company.com" }}
.company-directory
.work-vpn-config
{{- end }}

{{- if ne .email "me@home.org" }}
.personal-file
{{- end }}
```

Ignore a folder except for specific contents (Windows example):

```text title="~/.local/share/chezmoi/.chezmoiignore"
{{- if eq .chezmoi.os "windows" }}
Documents/*
!Documents/*PowerShell/
{{- end }}
```

## Caveats / Common Mistakes

- Patterns match against target paths, not source paths. Write `.bashrc`, not `dot_bashrc`.
- A `#` character at the start of a line is always a comment. Mid-line `#` requires preceding whitespace to be recognized as a comment; otherwise it is part of the filename pattern (e.g., `*/*.org#` matches files ending in `#`).
- `backups/` ignores the folder but not its contents; `backups/**` ignores contents but not the folder itself. Use both to ignore everything.

## See Also

- recipe-file-types
