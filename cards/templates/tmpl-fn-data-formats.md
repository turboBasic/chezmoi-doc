---
id: tmpl-fn-data-formats
title: "Template Functions: Data Format Conversion (JSON, TOML, YAML)"
category: templates
tags: [template, function, data-format, json, toml, yaml]
source: https://github.com/twpayne/chezmoi/blob/main/assets/chezmoi.io/docs/reference/templates/functions/fromJson.md
related: [tmpl-fn-output, tmpl-fn-include]
---

## Summary

Chezmoi provides functions to parse structured data from strings (`fromJson`, `fromJsonc`, `fromToml`, `fromYaml`) and serialize values back to formatted strings (`toPrettyJson`, `toToml`, `toYaml`). These are essential for reading config files, processing command output, and generating structured configuration.

## Syntax / Usage

```
{{ fromJson "json-string" }}
{{ fromJsonc "jsonc-string" }}
{{ fromToml "toml-string" }}
{{ fromYaml "yaml-string" }}

{{ dict "key" "value" | toPrettyJson }}
{{ dict "key" "value" | toPrettyJson "\t" }}
{{ dict "key" "value" | toToml }}
{{ dict "key" "value" | toYaml }}
```

## Details

### Parsing functions

**`fromJson`** -- Parses a JSON string and returns the parsed value. Numbers that fit in a 64-bit signed integer are returned as integers; otherwise as 64-bit floats; otherwise as strings (per RFC 7159 Section 6).

**`fromJsonc`** -- Parses JSONC (JSON with Comments) using `github.com/tailscale/hujson`. Supports `//` and `/* */` comments and trailing commas.

**`fromToml`** -- Parses a TOML string and returns the parsed value as a nested map.

**`fromYaml`** -- Parses a YAML string and returns the parsed value.

### Serialization functions

**`toPrettyJson`** -- Serializes a value to indented JSON. Optional *indent* argument (defaults to two spaces). Useful for generating JSON config files.

**`toToml`** -- Serializes a value to TOML format.

**`toYaml`** -- Serializes a value to YAML format.

All parsing functions return nested maps/slices that can be traversed with dot notation in templates.

## Examples

Parse a TOML section and extract a key:

```
{{ (fromToml "[section]\nkey = \"value\"").section.key }}
```

Parse YAML inline:

```
{{ (fromYaml "key1: value\nkey2: value").key2 }}
```

Generate a JSON config file from template data:

```
{{ dict "a" (dict "b" "c") | toPrettyJson "\t" }}
```

Generate TOML output:

```
{{ dict "key" "value" | toToml }}
```

Generate YAML output:

```
{{ dict "key" "value" | toYaml }}
```

Parse JSON output from a command:

```
{{ $data := output "some-tool" "--output" "json" | fromJson }}
value: {{ $data.nested.key }}
```

Read and parse an included TOML file:

```
{{ $config := include "some-config.toml" | fromToml }}
name = {{ $config.user.name }}
```

## Caveats / Common Mistakes

- `fromJson` handles number precision carefully per RFC 7159 -- very large numbers may be returned as strings rather than numeric types.
- There is no plain `toJson` function -- use `toPrettyJson` for JSON serialization (it defaults to 2-space indent which is standard JSON pretty-printing).
- `fromJsonc` requires the `hujson` parser and accepts comments/trailing commas that standard JSON does not.
- The `toPrettyJson` indent argument is optional and positional -- it comes before the value when piping: `| toPrettyJson "\t"`.

## See Also

- [tmpl-fn-output](tmpl-fn-output.md)
- [tmpl-fn-include](tmpl-fn-include.md)
