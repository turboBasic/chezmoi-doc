---
id: tmpl-variables
title: "Built-in Template Variables"
category: templates
tags: [template, concept]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/variables.md
related: [tmpl-syntax, tmpl-data, tmpl-conditionals]
---

## Summary

Chezmoi automatically populates a `.chezmoi` namespace with variables describing the current machine, user, and chezmoi environment. These variables drive conditional logic for machine-to-machine differences.

## Syntax / Usage

```text
{{ .chezmoi.os }}
{{ .chezmoi.hostname }}
{{ .chezmoi.username }}
```

## Details

All built-in variables live under the `.chezmoi` key. Run `chezmoi data` to see their current values as JSON.

### Core variables

| Variable | Type | Description |
|---|---|---|
| `.chezmoi.os` | string | OS identifier (e.g. `darwin`, `linux`, `windows`) from `runtime.GOOS` |
| `.chezmoi.arch` | string | Architecture (e.g. `amd64`, `arm64`) from `runtime.GOARCH` |
| `.chezmoi.hostname` | string | Short hostname (up to first `.`) |
| `.chezmoi.fqdnHostname` | string | Fully-qualified domain name |
| `.chezmoi.username` | string | Current username |
| `.chezmoi.uid` | string | User ID |
| `.chezmoi.gid` | string | Primary group ID |
| `.chezmoi.group` | string | Group name |
| `.chezmoi.homeDir` | string | Home directory (forward slashes) |
| `.chezmoi.sourceDir` | string | Source directory path |
| `.chezmoi.sourceFile` | string | Path of current template relative to source dir |
| `.chezmoi.targetFile` | string | Absolute path of the target file |
| `.chezmoi.cacheDir` | string | Cache directory path |
| `.chezmoi.configFile` | string | Path to the config file |
| `.chezmoi.executable` | string | Path to the chezmoi binary |
| `.chezmoi.workingTree` | string | Working tree of the source directory |

### Path helpers

| Variable | Type | Description |
|---|---|---|
| `.chezmoi.pathSeparator` | string | `/` on unix, `\` on Windows |
| `.chezmoi.pathListSeparator` | string | `:` on unix, `;` on Windows |
| `.chezmoi.rawHomeDir` | string | Home dir with native path separators |

### OS-specific objects

| Variable | Type | Description |
|---|---|---|
| `.chezmoi.kernel` | object | Info from `/proc/sys/kernel` (Linux only, useful for WSL detection) |
| `.chezmoi.osRelease` | object | Parsed `/etc/os-release` (Linux only) |
| `.chezmoi.windowsVersion` | object | Windows version info from registry (Windows only) |

### Runtime info

| Variable | Type | Description |
|---|---|---|
| `.chezmoi.args` | []string | Arguments passed to the chezmoi command |
| `.chezmoi.config` | object | The parsed configuration file |
| `.chezmoi.flags` | object | Selected flags passed to chezmoi |
| `.chezmoi.version.version` | string | Chezmoi version |
| `.chezmoi.version.commit` | string | Git commit of the build |
| `.chezmoi.version.date` | string | Build timestamp |
| `.chezmoi.version.builtBy` | string | Build system identifier |

## Examples

Conditional based on OS:

```text
{{ if eq .chezmoi.os "darwin" -}}
export HOMEBREW_PREFIX=/opt/homebrew
{{ end -}}
```

Accessing Linux distribution info:

```text
{{ if eq .chezmoi.osRelease.id "ubuntu" -}}
# Ubuntu-specific config
{{ end -}}
```

Using hostname for machine-specific blocks:

```text
{{ if eq .chezmoi.hostname "work-laptop" -}}
export HTTP_PROXY=http://proxy.corp:8080
{{ end -}}
```

Inspect all available data:

```sh
chezmoi data
chezmoi data --format=yaml
```

## Caveats / Common Mistakes

- `.chezmoi.hostname` is the short hostname (up to first dot), not the FQDN. Use `.chezmoi.fqdnHostname` for the full name.
- `.chezmoi.osRelease` and `.chezmoi.kernel` are Linux-only; referencing them on macOS or Windows will trigger `missingkey=error`.
- `.chezmoi.uid` and `.chezmoi.gid` are strings, not integers.

## See Also

- tmpl-syntax
- tmpl-data
- tmpl-conditionals
