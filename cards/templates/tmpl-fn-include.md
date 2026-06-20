---
id: tmpl-fn-include
title: "Template Functions: include / includeTemplate"
category: templates
tags: [template, function, composition, reuse]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/include.md
related: [tmpl-fn-output, tmpl-fn-data-formats]
---

## Summary

`include` and `includeTemplate` enable template composition by inserting content from other files. `include` inserts literal file contents while `includeTemplate` executes the file as a template with optional data.

## Syntax / Usage

```
{{ include "filename" }}
{{ includeTemplate "filename" }}
{{ includeTemplate "filename" .data }}
```

## Details

### `include`

Returns the literal contents of the named file. Relative paths are interpreted relative to the **source directory** (i.e., `~/.local/share/chezmoi/`). The file is read as-is with no template processing.

### `includeTemplate`

Returns the result of executing the named file as a template. Accepts optional *data* that becomes the `.` context within the included template.

Relative paths are first searched in `.chezmoitemplates/` and, if not found there, are interpreted relative to the source directory.

This enables reusable template partials stored in `.chezmoitemplates/` that can be parameterized with different data for each inclusion.

## Examples

Include a literal file (e.g., a shared SSH config block):

```
{{ include "dot_ssh/config_common" }}
```

Include a reusable template partial from `.chezmoitemplates/`:

```
{{ includeTemplate "shell-aliases" . }}
```

Pass custom data to a template partial:

```
{{ includeTemplate "git-config-section" (dict "email" "work@company.com" "name" "Work Name") }}
```

## Caveats / Common Mistakes

- `include` does NOT process templates -- if the included file contains `{{ }}` directives, they are inserted literally. Use `includeTemplate` for files that need template evaluation.
- `includeTemplate` searches `.chezmoitemplates/` first for relative paths; `include` does not -- it only looks in the source directory.
- Forgetting to pass `.` (the current data context) to `includeTemplate` means the partial cannot access `.chezmoi` variables or other template data.

## See Also

- [tmpl-fn-output](tmpl-fn-output.md)
- [tmpl-fn-data-formats](tmpl-fn-data-formats.md)
