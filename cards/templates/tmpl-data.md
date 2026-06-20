---
id: tmpl-data
title: "Template Data Sources"
category: templates
tags: [template, concept, config]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/special-files/chezmoidata-format.md
related: [tmpl-variables, tmpl-syntax, tmpl-conditionals]
---

## Summary

Chezmoi templates can access data from three sources (later sources override earlier ones): built-in `.chezmoi` variables, `.chezmoidata` files/directories in the source state, and the `[data]` section of the config file. This allows defining custom variables for use in templates.

## Syntax / Usage

```toml title="~/.config/chezmoi/chezmoi.toml"
[data]
    email = "me@home.org"
    name = "My Name"
```

```toml title="~/.local/share/chezmoi/.chezmoidata.toml"
fontSize = 12
editor = "nvim"
```

## Details

### Data source priority (later wins)

1. Built-in `.chezmoi.*` variables (populated by chezmoi).
2. `.chezmoidata.$FORMAT` files in the source state.
3. Files within `.chezmoidata/` directories in the source state.
4. The `[data]` section of the configuration file (`~/.config/chezmoi/chezmoi.toml`).

### .chezmoidata files

Supported formats: `json`, `jsonc`, `toml`, `yaml`.

Multiple `.chezmoidata.$FORMAT` files can exist in the source state (including in subdirectories). They are all merged into the root of the data dictionary in lexical (alphabetical) filesystem order. Only dictionaries are deep-merged; all other values (including lists) are replaced entirely.

### .chezmoidata/ directory

A `.chezmoidata/` directory can contain multiple data files of any supported format. They follow the same merging rules as `.chezmoidata.$FORMAT` files.

### Config file data section

The `[data]` section of the config file defines per-machine variables. This is ideal for values that differ between machines (email, credentials, machine role). Variable names must start with a letter followed by zero or more letters/digits.

### Important constraints

- `.chezmoidata` files and directories cannot themselves be templates. They are read before the template engine starts.
- For dynamic data that depends on the machine environment, use the `[data]` section of `.chezmoi.$FORMAT.tmpl` (the config template evaluated at `chezmoi init` time), or use runtime functions like `output`, `fromJson`, `fromYaml` within templates.

## Examples

Defining data in TOML config:

```toml title="~/.config/chezmoi/chezmoi.toml"
[data]
    email = "me@home.org"
    isWork = false

[data.git]
    signingKey = "ABC123"
```

Using in a template:

```text title="dot_gitconfig.tmpl"
[user]
    email = {{ .email | quote }}
{{ if .isWork -}}
[http]
    proxy = http://proxy.corp:8080
{{ end -}}
```

Shared data file in source state:

```toml title="~/.local/share/chezmoi/.chezmoidata.toml"
[packages]
    common = ["git", "curl", "jq", "ripgrep"]
```

Viewing all resolved data:

```sh
chezmoi data
chezmoi data --format=yaml
```

## Caveats / Common Mistakes

- `.chezmoidata` files cannot use template syntax. If you need computed values, define them in the config template (`.chezmoi.toml.tmpl`) or use runtime functions.
- When multiple data files define the same key, later files (by alphabetical order) overwrite earlier ones. Lists are replaced entirely, not appended.
- The `[data]` section in the config file is per-machine and not synced via the source repo. Use `.chezmoidata` for shared data and `[data]` for machine-specific overrides.

## See Also

- tmpl-variables
- tmpl-syntax
- tmpl-conditionals
