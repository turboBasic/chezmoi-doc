---
id: tmpl-include
title: "includeTemplate and include Functions"
category: templates
tags: [template, concept, recipe]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/includeTemplate.md
related: [tmpl-syntax, tmpl-functions-overview, tmpl-conditionals]
---

## Summary

Chezmoi provides two functions for composing templates from multiple files: `include` (literal file contents) and `includeTemplate` (execute a file as a template). Combined with `.chezmoitemplates`, these enable DRY configuration by factoring shared logic into reusable partials.

## Syntax / Usage

```text
{{ include "filename" }}
{{ includeTemplate "filename" . }}
{{ includeTemplate "filename" $data }}
```

## Details

### `include` filename

Returns the literal contents of the named file. Relative paths are resolved relative to the source directory. The file is NOT processed as a template.

Use case: including completely separate platform-specific files that contain no template logic.

### `includeTemplate` filename [data]

Executes the named file as a template and returns the result. Relative paths are first searched in `.chezmoitemplates/` and, if not found, resolved relative to the source directory. The optional data argument is passed as `.` inside the included template.

Use case: reusable template partials that need access to variables.

### The `template` action (Go built-in)

Go's built-in `{{ template "name" . }}` action also works with files in `.chezmoitemplates`. The key difference from `includeTemplate` is that `template` is an action (not a function) and cannot be used in pipelines.

Files in `.chezmoitemplates/` are automatically available by their relative path as template names. They are executed with `nil` data by default unless you pass `.` explicitly.

### Passing data to templates

Three approaches:

1. **Pass `.`** to give the sub-template full access to all variables:
   ```text
   {{ template "part.tmpl" . }}
   ```

2. **Pass a scalar** for simple parameterization:
   ```text
   {{ template "alacritty" 12 }}
   ```

3. **Pass a dict** for multiple named parameters:
   ```text
   {{ template "alacritty" dict "fontsize" 12 "font" "DejaVu Sans Mono" }}
   ```

## Examples

Using `include` for platform-specific files:

```text title="dot_bashrc.tmpl"
{{- if eq .chezmoi.os "darwin" -}}
{{-   include ".bashrc_darwin" -}}
{{- else if eq .chezmoi.os "linux" -}}
{{-   include ".bashrc_linux" -}}
{{- end -}}
```

Using `.chezmoitemplates` with the `template` action:

```text title=".chezmoitemplates/git-config.tmpl"
[user]
    email = {{ .email | quote }}
    name = {{ .name | quote }}
```

```text title="dot_gitconfig.tmpl"
{{ template "git-config.tmpl" . }}
[core]
    editor = nvim
```

Using `includeTemplate` in a pipeline (something `template` cannot do):

```text
{{ includeTemplate "snippet.tmpl" . | trim }}
```

Reusable template with dict parameter:

```text title=".chezmoitemplates/alacritty"
some: config
fontsize: {{ .fontsize }}
font: {{ .font }}
more: config
```

```text title="small-font.yml.tmpl"
{{- template "alacritty" dict "fontsize" 12 "font" "DejaVu Sans Mono" -}}
```

Using config data to parameterize templates:

```toml title="~/.config/chezmoi/chezmoi.toml"
[data.alacritty.work]
    fontsize = 14
    font = "Fira Code"
```

```text title="work-font.yml.tmpl"
{{- template "alacritty" .alacritty.work -}}
```

## Caveats / Common Mistakes

- `{{ template "name" }}` without passing data means `.` is `nil` inside the sub-template. Variables like `.chezmoi.os` will not be available. Always pass `.` if you need access to chezmoi variables.
- `include` does NOT evaluate templates. If the included file contains `{{ }}` actions, they appear literally in the output. Use `includeTemplate` or the `template` action for files that need template processing.
- `includeTemplate` searches `.chezmoitemplates` first, then falls back to the source directory. Be careful with naming collisions.
- The `template` action cannot be piped (it is an action, not a function). Use `includeTemplate` when you need pipeline composition (e.g., `| trim`).

## See Also

- tmpl-syntax
- tmpl-functions-overview
- tmpl-conditionals
