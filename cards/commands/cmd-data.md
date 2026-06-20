---
id: cmd-data
title: "chezmoi data -- Print computed template data"
category: commands
tags: [command, template]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/commands/data.md
related: [cmd-execute-template, cmd-dump]
---

## Summary

Writes the computed template data to stdout in JSON or YAML format. Use this to inspect what variables are available in templates (`.chezmoi.*` and user-defined data).

## Syntax / Usage

```sh
chezmoi data [--format json|yaml]
```

## Details

Outputs all template data that chezmoi computes and makes available inside `.tmpl` files. This includes the `.chezmoi` namespace (os, arch, hostname, username, etc.) as well as any user-defined data from `.chezmoidata.*` files and the config file's `[data]` section.

The default output format is JSON. Use `--format yaml` for YAML output.

## Examples

```sh
# Print all template data as JSON
chezmoi data

# Print all template data as YAML
chezmoi data --format=yaml

# Pipe into jq to inspect a specific key
chezmoi data | jq '.chezmoi.os'
```

## See Also

- cmd-execute-template
- cmd-dump
